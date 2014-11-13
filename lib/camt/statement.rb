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
      node.at("./Bal/Tp/CdOrPrtry/Cd[text()='#{balance_type}']/../../..")
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
      Amount.new(balance_type_node).value
    end

    def get_end_balance
      # Find the (only) balance node with code ClosingBalance, or
      # the second (and last) balance node with code InterimBalance in
      # the case of continued pagination.
      #
      # :param node: BkToCstmrStmt/Stmt/Bal node
      balance_type_node = nil
      ['CLBD', 'ITBD'].detect{|code| balance_type_node = get_balance_type_node(node, code) }
      Amount.new(balance_type_node).value if balance_type_node
    end

    def parse_Ntry(node)
      # :param node: Ntry node
      Transaction.new(node, country_code)
    end
  end
end
