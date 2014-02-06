require 'test_helper'

module Camt
  class FileTest < Test::Unit::TestCase

    def setup
      @file = Camt::File.parse (::File.dirname(__FILE__) + '/../../files/camt.xml')
    end

    def test_should_have_messages
      assert @file.messages.any?
    end

    def test_should_have_statements
      assert @file.statements.any?
    end

    def test_should_have_transactions
      assert @file.transactions.any?
    end

  end
end