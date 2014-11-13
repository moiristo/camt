module Camt
  class Parser

    attr_accessor :file

    def parse_Stmt(node)
      # Parse a single Stmt node.
      #
      # Be sure to craft a unique, but short enough statement identifier,
      # as it is used as the basis of the generated move lines' names
      # which overflow when using the full IBAN and CAMT statement id.
      Statement.new(node, file.country_code)
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

    def parse file
      self.file = file
      file.doc.remove_namespaces!
      file.doc.xpath('//BkToCstmrStmt').map{|node| parse_message node }
    end

  end
end
