module Camt
  class Parser
    def get_balance_type_node node, balance_type
      # :param node: BkToCstmrStmt/Stmt/Bal node
      # :param balance type: one of 'OPBD', 'PRCD', 'ITBD', 'CLBD'
      return node.at("./Bal/Tp/CdOrPrtry/Cd[text()='#{balance_type}']/../../..")
    end

    def parse_amount(node)
      # Parse an element that contains both Amount and CreditDebitIndicator
      #
      # :return: signed amount
      # :returntype: float

      sign = node.at('./CdtDbtInd').text == 'DBIT' ? -1 : 1
      return sign * node.at('./Amt').text.to_f
    end

    def get_start_balance(node)
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

    def get_end_balance(node)
      # Find the (only) balance node with code ClosingBalance, or
      # the second (and last) balance node with code InterimBalance in
      # the case of continued pagination.
      #
      # :param node: BkToCstmrStmt/Stmt/Bal node
      balance_type_node = nil
      ['CLBD', 'ITBD'].detect{|code| balance_type_node = get_balance_type_node(node, code) }
      parse_amount balance_type_node
    end

    def parse_Stmt node
      # Parse a single Stmt node.
      #
      # Be sure to craft a unique, but short enough statement identifier,
      # as it is used as the basis of the generated move lines' names
      # which overflow when using the full IBAN and CAMT statement id.

      statement = Statement.new

      statement.id = node.at('./Id').text
      statement.electronic_sequence_number = node.at('./ElctrncSeqNb').text
      statement.created_at = Time.parse(node.at('./CreDtTm').text)
      statement.local_account = node.at('./Acct/Id').text.strip
      statement.local_currency = node.at('./Acct/Ccy').text
      statement.date = Time.parse(node.at('./Ntry[1]/ValDt/Dt | ./Ntry[1]/ValDt/DtTm').text)
      statement.start_balance = get_start_balance(node)
      statement.end_balance = get_end_balance(node)
      statement.transactions = node.xpath('./Ntry').map{ |node| parse_Ntry(node) }

      statement
    end

    def get_transfer_type node
      # Map properietary codes from BkTxCd/Prtry/Cd.
      # :param node: BkTxCd/Prtry node
      { proprietary_code: node.at('./Cd').text, proprietary_issuer: node.at('./Issr').text } if node
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

      transaction_details[:party] = get_party_values node

      transaction_details
    end

    def parse_message node
      group_header_node = node.at('./GrpHdr')

      group_header = GroupHeader.new
      group_header.message_id       = group_header_node.at('./MsgId').text
      group_header.created_at       = Time.parse(group_header_node.at('./CreDtTm').text)
      group_header.additional_info  = group_header_node.at('./AddtlInf').try(:text)

      if recipient_node = group_header_node.at('./MsgRcpt')
        group_header.recipient = {
          name: recipient_node.at('./Nm').try(:text),
          postal_address: recipient_node.at('./PstlAdr').try(:text),
          identification: recipient_node.at('./Id').try(:text),
          country_of_residence: recipient_node.at('./CtryOfRes').try(:text),
          contact_details: recipient_node.at('./CtctDtls').try(:text)
        }
      end

      if pagination_node = group_header_node.at('./MsgPgntn')
        group_header.pagination = { page: pagination_node.at('./PgNb').text, last_page: (pagination_node.at('./LastPgInd').text == 'true') }
      end

      message = Message.new
      message.group_header = group_header
      message.statements = node.xpath('./Stmt').map{|node| parse_Stmt node }

      message
    end

    def parse doc
      doc.remove_namespaces!
      doc.xpath('//BkToCstmrStmt').map{|node| parse_message node }
    end

  end
end