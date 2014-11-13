require_relative "../support/camt.053_integration"

RSpec.describe "camt.xml" do

  let(:expected_iban) { "NL77ABNA0574908765" }
  let(:expected_currency) { "EUR" }

  it_behaves_like "any CAMT.053 file"

end
