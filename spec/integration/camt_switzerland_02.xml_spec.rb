require_relative "../support/camt.053_integration"

RSpec.describe "camt_switzerland_02.xml" do

  let(:expected_id) { "STMID-C053.01.00.10-110725163809-01" }
  let(:expected_electronic_sequence_number) { "147" }
  let(:expected_creation_time) { "2011-07-25T09:30:47Z" }
  let(:expected_iban) { "CH9581320000001998736" }
  let(:expected_currency) { "CHF" }
  let(:expected_date) { "2011-07-25" }
  let(:expected_start_balance) { 2501.50 }
  let(:expected_end_balance) { 2397.2 }

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
            ],
            purpose: "E2EID-P001.01.00.01-110718163809-01 123456789012345678901234567 " \
                     "E2EID-P001.01.00.01-110718163809-02 210000000003139471430009017"
        },
        {
            ex_date: "2011-07-25",
            eff_date: "2011-07-24",
            type: nil,
            amount: -250.0,
            details: [
                {references: ["E2EID-P001.01.00.02-110718163809-01"], party: {}}
            ],
            purpose: "E2EID-P001.01.00.02-110718163809-01"
        }
    ]
  end
end
