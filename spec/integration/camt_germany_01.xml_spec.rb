require_relative "../support/camt.053_integration"

RSpec.describe "camt_germany_01.xml" do

  let(:expected_id) { "2736482736482" }
  let(:expected_electronic_sequence_number) { "101" }
  let(:expected_creation_time) { "2008-09-01T17:30:47.0+01:00" }
  let(:expected_iban) { "DE87200500001234567890" }
  let(:expected_currency) { "EUR" }
  let(:expected_date) { "2008-09-01" }
  let(:expected_start_balance) { 112.72 }
  let(:expected_end_balance) { 158780.32 }

  let :expected_transactions do
    [
        {
            ex_date: "2008-09-01",
            eff_date: "2008-09-01",
            type: nil,
            amount: 100.0,
            details: [
                {
                    messages: ["Rechnungsnr. 4711 vom 20.08.2008"],
                    references: ["Ende-zu-Ende-Id des Ueberweisenden"],
                    party: {
                        remote_owner: "Herr Ueberweisender",
                        remote_owner_country: nil,
                        remote_owner_address: nil,
                        remote_account: "DE21500500001234567897"
                    }
                }
            ],
            purpose: "SEPA GUTSCHRIFT"
        },
        {
            ex_date: "2008-09-01",
            eff_date: "2008-09-01",
            type: nil,
            amount: 200.0,
            details: [
                {
                    messages: ["Angabe des urspruenglichen Verwendungszweckes"],
                    references: ["Urspr. E2E-Id der Hintransaktion"],
                    reason: {
                        code: "AC01",
                        description: "Account identifier incorrect (i.e. invalid IBAN)"
                    },
                    party: {}
                }
            ],
            purpose: "SEPA RUECKBUCHUNG"
        },
        {
            ex_date: "2008-09-01",
            eff_date: "2008-09-01",
            type: nil,
            amount: -50.0,
            details: [
                {
                    messages: ["Telefonrechnung August 2009, Vertragsnummer 3536456345"],
                    references: ["E2E-Id vergeben vom Glaeubiger"],
                    mandate_identifier: "Ref. des SEPA-Lastschriftmandats",
                    party: {
                        remote_owner: "Glaeubigerfirma",
                        remote_owner_country: nil,
                        remote_owner_address: nil
                    }
                }
            ],
            purpose: "SEPA LASTSCHRIFT"
        },
        {
            ex_date: "2008-09-02",
            eff_date: "2008-09-02",
            type: nil,
            amount: 100.0,
            details: [
                {
                    messages: ["Rechnungsnr 4711 - Warenlieferung vom 20.08.2008"],
                    party: {
                        remote_owner: "Herr Überweisender",
                        remote_owner_country: nil,
                        remote_owner_address: nil,
                        remote_account: "1234567890"
                    }
                }
            ],
            purpose: "ÜBERWEISUNGSGUTSCHRIFT"
        },
        {
            ex_date: "2008-09-02",
            eff_date: "2008-09-02",
            type: nil,
            amount: 200.0,
            details: [
                {
                    messages: ["Angabe des ursprünglichen Verwendungszweckes"],
                    party: {}
                }
            ],
            purpose: "RÜCKÜBERWEISUNG"
        },
        {
            ex_date: "2008-09-02",
            eff_date: "2008-09-02",
            type: nil,
            amount: -50.0,
            details: [
                {
                    messages: ["Telefonrechnung August 2009, Vertragsnummer 3536456345"],
                    party: {
                        remote_owner: "Telefongesellschaft ABC",
                        remote_owner_country: nil,
                        remote_owner_address: nil
                    }
                }
            ],
            purpose: "LASTSCHRIFT"
        },
        {
            ex_date: "2008-09-03",
            eff_date: "2008-09-03",
            type: nil,
            amount: -276.0,
            details: [
                {
                    messages: ["Telefonrechnung August 2009, Vertragsnummer 3536456345"],
                    references: ["79892"],
                    mandate_identifier: "10001",
                    party: {
                        remote_owner: "Telefongesellschaft ABC",
                        remote_owner_country: nil,
                        remote_owner_address: nil
                    }
                },
                {
                    messages: ["Telefonrechnung August 2009, Vertragsnummer 536456888"],
                    references: ["768768"],
                    mandate_identifier: "10002",
                    party: {
                        remote_owner: "Telefongesellschaft ABC",
                        remote_owner_country: nil,
                        remote_owner_address: nil
                    }
                },
                {
                    messages: ["Telefonrechnung August 2009, Vertragsnummer 3536456345"],
                    references: ["45456465"],
                    mandate_identifier: "10003",
                    party: {
                        remote_owner: "Telefongesellschaft ABC",
                        remote_owner_country: nil,
                        remote_owner_address: nil
                    }
                }
            ],
            purpose: "SEPA Direct Debit (Einzelbuchung-Soll,Core)"
        },
        {
            ex_date: "2008-09-03",
            eff_date: "2008-09-03",
            type: nil,
            amount: -100876.0,
            details: [
                {
                    party: {}
                }
            ],
            purpose: "SEPA Credit Transfer (Sammler-Soll)"
        },
        {
            ex_date: "2008-09-03",
            eff_date: "2008-09-03",
            type: nil,
            amount: -276.0,
            details: [
                {
                    party: {}
                }
            ],
            purpose: "SEPA Direct Debit (Einzelbuchung-Soll,Core)"
        },
        {
            ex_date: "2008-09-04",
            eff_date: "2008-09-04",
            type: nil,
            amount: 259595.60,
            details: [
                {
                    messages: ["Invoice No. 4545"],
                    party: {
                        remote_owner: "West Coast Ltd.",
                        remote_owner_country: "US",
                        remote_owner_address: "52, Main Street",
                        remote_account: "546237687",
                        remote_bank_bic: "BANKUSNY"
                    }
                }
            ],
            purpose: "AZV-UEBERWEISUNGSGUTSCHRIFT"
        }
    ]
  end

  it_behaves_like "any CAMT.053 file"

end
