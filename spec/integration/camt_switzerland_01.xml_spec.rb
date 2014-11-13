require_relative "../support/camt.053_integration"

RSpec.describe "camt_switzerland_01.xml" do

  let(:expected_iban) { "CH8809000000505005006" }
  let(:expected_currency) { "CHF" }

  let :expected_transactions do
    [
        {
            ex_date: "2011-11-30",
            eff_date: "2011-11-30",
            type: nil,
            amount: 3.50,
            details: [
                {party: {}}
            ]
        },
        {
            ex_date: "2011-11-30",
            eff_date: "2011-11-30",
            type: nil,
            amount: -4.50,
            details: [
                {references: ["123457"], party: {}}
            ]
        }
    ]
  end

  it_behaves_like "any CAMT.053 file"

end
