require_relative "../support/camt.053_integration"

RSpec.describe "camt_switzerland_01.xml" do

  let(:expected_iban) { "CH8809000000505005006" }
  let(:expected_currency) { "CHF" }

  it_behaves_like "any CAMT.053 file"

end
