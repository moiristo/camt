require 'nokogiri'
require 'time'

require 'camt/version'
require 'camt/object_extension'
require 'camt/file'
require 'camt/parser'

module Camt

  # Define structs

  Message = Struct.new(:group_header, :statements)
  GroupHeader = Struct.new(:message_id, :created_at, :recipient, :pagination, :additional_info)

  Statement = Struct.new(
    :id,
    :date,
    :created_at,
    :local_account,
    :local_currency,
    :start_balance,
    :end_balance,
    :electronic_sequence_number,
    :transactions
  )

  Transaction = Struct.new(
    :execution_date,
    :effective_date,
    :transfer_type,
    :transferred_amount,
    :transaction_details
  )

end
