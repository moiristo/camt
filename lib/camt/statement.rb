module Camt
  class Statement

    attr_reader :node, :country_code

    def initialize(xml_node, country_code)
      @node = xml_node
      @country_code = country_code
    end

    def id
      @id ||= node.at('./Id').text
    end

    def electronic_sequence_number
      @electronic_sequence_number ||= node.at('./ElctrncSeqNb').text
    end

    def created_at
      @created_at ||= Time.parse(node.at('./CreDtTm').text)
    end

    def local_account
      @local_account ||= node.at('./Acct/Id').text.strip
    end

    alias_method :iban, :local_account

    def local_currency
      @local_currency ||= node.at('./Acct/Ccy').try(:text) ||
          node.at('./Bal/Amt').attribute("Ccy").value
    end

    def date
      @date ||= Date.parse(node.at('./Ntry[1]/ValDt/Dt | ./Ntry[1]/ValDt/DtTm').text)
    end

    def start_balance
      @start_balance ||= get_start_balance
    end

    def end_balance
      @end_balance ||= get_end_balance
    end

    def transactions
      @transactions ||= node.xpath('./Ntry').map { |node| parse_Ntry(node) }
    end

    private

    def get_balance_type_node node, balance_type
      # :param node: BkToCstmrStmt/Stmt/Bal node
      # :param balance type: one of 'OPBD', 'PRCD', 'ITBD', 'CLBD'
      return node.at("./Bal/Tp/CdOrPrtry/Cd[text()='#{balance_type}']/../../..")
    end

    def get_start_balance
      # Find the (only) balance node with code OpeningBalance, or
      # the only one with code 'PreviousClosingBalance'
      # or the first balance node with code InterimBalance in
      # the case of preceeding pagination.
      #
      # :param node: BkToCstmrStmt/Stmt/Bal node
      balance_type_node = nil
      ['OPBD', 'PRCD', 'ITBD'].detect{|code| balance_type_node = get_balance_type_node(node, code) }
      parse_amount balance_type_node
    end

    def get_end_balance
      # Find the (only) balance node with code ClosingBalance, or
      # the second (and last) balance node with code InterimBalance in
      # the case of continued pagination.
      #
      # :param node: BkToCstmrStmt/Stmt/Bal node
      balance_type_node = nil
      ['CLBD', 'ITBD'].detect{|code| balance_type_node = get_balance_type_node(node, code) }
      parse_amount(balance_type_node) if balance_type_node
    end

    def parse_Ntry node
      # :param node: Ntry node

      transaction = Transaction.new
      transaction.execution_date      = node.at('./BookgDt/Dt | ./BookgDt/DtTm').text
      transaction.effective_date      = node.at('./ValDt/Dt | ./ValDt/DtTm').text
      transaction.transfer_type       = get_transfer_type(node.at('./BkTxCd/Prtry'))
      transaction.transferred_amount  = parse_amount(node)
      transaction.transaction_details = node.xpath('.//NtryDtls//TxDtls').map{ |node| parse_TxDtls(node) }

      transaction
    end

    def parse_amount(node)
      # Parse an element that contains both Amount and CreditDebitIndicator
      #
      # :return: signed amount
      # :returntype: float

      sign = node.at('./CdtDbtInd').text == 'DBIT' ? -1 : 1
      return sign * node.at('./Amt').text.to_f
    end

    def get_transfer_type node
      # Map properietary codes from BkTxCd/Prtry/Cd.
      # :param node: BkTxCd/Prtry node
      { proprietary_code: node.at('./Cd').text, proprietary_issuer: node.at('./Issr').text } if node
    end

    def get_party_values node
      # Determine to get either the debtor or creditor party node
      # and extract the available data from it
      values = {}

      party_type = node.at('../../CdtDbtInd').text == 'CRDT' ? 'Dbtr' : 'Cdtr'

      party_node = node.at("./RltdPties/#{party_type}")
      account_node = node.at("./RltdPties/#{party_type}Acct/Id")
      bic_node = node.at("./RltdAgts/#{party_type}Agt/FinInstnId/BIC")

      if party_node
        values[:remote_owner] = party_node.at('./Nm').try(:text)
        values[:remote_owner_country] = party_node.at('./PstlAdr/Ctry').try(:text)
        values[:remote_owner_address] = party_node.at('./PstlAdr/AdrLine').try(:text)
      end

      if account_node
        values[:remote_account] = account_node.at('./IBAN').try(:text)
        values[:remote_account] ||= account_node.at('./Othr/Id').try(:text)
        values[:remote_bank_bic] = bic_node.text if bic_node
      end

      return values
    end

    def parse_TxDtls node
      # Parse a single TxDtls node
      transaction_details = {}

      if (unstructured = node.xpath('./RmtInf/Ustrd')).any?
        transaction_details[:messages] = unstructured.map(&:text)
      end

      if (structured = node.xpath('./RmtInf/Strd/CdtrRefInf/Ref | ./Refs/EndToEndId')).any?
        transaction_details[:references] = structured.map(&:text)
      end

      if mandate_identifier = node.at('./Refs/MndtId').try(:text)
        transaction_details[:mandate_identifier] = mandate_identifier
      end

      if reason = node.at('./RtrInf/Rsn/Cd').try(:text)
        reason_language = Camt::Reasons.keys.include?(country_code) ? country_code : 'EN'
        transaction_details[:reason] = { code: reason, description: Camt::Reasons[reason_language][reason] }
      end

      transaction_details[:party] = get_party_values node

      transaction_details
    end
  end
end
