require_relative "../support/camt.053_integration"

RSpec.describe "camt_switzerland_01.xml" do

  let(:expected_id) { "KOBE111130009991" }
  let(:expected_electronic_sequence_number) { "1" }
  let(:expected_creation_time) { "2011-11-30T14:09:00.00Z" }
  let(:expected_iban) { "CH8809000000505005006" }
  let(:expected_currency) { "CHF" }
  let(:expected_date) { "2011-11-30" }
  let(:expected_start_balance) { 191.99 }
  let(:expected_end_balance) { 190.99 }

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
