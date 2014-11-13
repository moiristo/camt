module Camt
  class Transaction

    attr_reader :node, :country_code

    def initialize(xml_node, country_code)
      @node = xml_node
      @country_code = country_code
    end

    def execution_date
      @execution_date ||= Date.parse(node.at('./BookgDt/Dt | ./BookgDt/DtTm').text)
    end

    def effective_date
      @effective_date ||= Date.parse(node.at('./ValDt/Dt | ./ValDt/DtTm').text)
    end

    def transfer_type
      @transfer_type ||= get_transfer_type(node.at('./BkTxCd/Prtry'))
    end

    alias_method :type, :transfer_type

    def transferred_amount
      @transferred_amount ||= Amount.new(node).value
    end

    alias_method :amount, :transferred_amount

    def transaction_details
      @transaction_details ||= node.xpath('.//NtryDtls//TxDtls').map { |node| parse_TxDtls(node) }
    end

    alias_method :details, :transaction_details

    private

    def get_transfer_type(node)
      # Map properietary codes from BkTxCd/Prtry/Cd.
      # :param node: BkTxCd/Prtry node
      { proprietary_code: node.at('./Cd').text, proprietary_issuer: node.at('./Issr').text } if node
    end

    def get_party_values(node)
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

      values
    end

    def parse_TxDtls(node)
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
