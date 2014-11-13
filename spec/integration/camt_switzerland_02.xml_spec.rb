require_relative "../support/camt.053_integration"

RSpec.describe "camt_switzerland_02.xml" do

  let(:expected_iban) { "CH9581320000001998736" }
  let(:expected_currency) { "CHF" }

  it_behaves_like "any CAMT.053 file"

  let :expected_transactions do
    [
        {
            ex_date: "2011-07-25",
            eff_date: "2011-07-25",
            type: nil,
            amount: 145.7,
            details: [
                {references: ["E2EID-P001.01.00.01-110718163809-01", "123456789012345678901234567"], party: {}},
                {references: ["E2EID-P001.01.00.01-110718163809-02", "210000000003139471430009017"], party: {}}
            ]
        },
        {
            ex_date: "2011-07-25",
            eff_date: "2011-07-24",
            type: nil,
            amount: -250.0,
            details: [
                {references: ["E2EID-P001.01.00.02-110718163809-01"], party: {}}
            ]
        }
    ]
  end
end
