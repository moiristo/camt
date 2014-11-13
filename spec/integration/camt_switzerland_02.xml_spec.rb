require_relative "../support/camt.053_integration"

RSpec.describe "camt_switzerland_02.xml" do

  let(:expected_iban) { "CH9581320000001998736" }
  let(:expected_currency) { "CHF" }

  it_behaves_like "any CAMT.053 file"

end
