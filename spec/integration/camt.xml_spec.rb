require_relative "../support/camt.053_integration"

RSpec.describe "camt.xml" do

  let(:expected_id) { "0574908765.2013-04-02" }
  let(:expected_electronic_sequence_number) { "0070" }
  let(:expected_creation_time) { "2013-04-12T10:55:08.66+02:00" }
  let(:expected_iban) { "NL77ABNA0574908765" }
  let(:expected_currency) { "EUR" }
  let(:expected_date) { "2013-04-02" }
  let(:expected_start_balance) { 1000.01 }
  let(:expected_end_balance) { 100.01 }

  let :expected_transactions do
    [
        {
            ex_date: "2013-04-02",
            eff_date: "2013-04-02",
            type: {proprietary_code: "N196", proprietary_issuer: "ABNAMRO"},
            amount: 1.0,
            details: []
        },
        {
            ex_date: "2013-04-02",
            eff_date: "2013-04-02",
            type: {proprietary_code: "N654", proprietary_issuer: "ABNAMRO"},
            amount: 1.0,
            details: [
                {
                    messages: ["OMSCHRIJVING"],
                    references: ["NOTPROVIDED"],
                    party: {
                        remote_owner: "NAAM",
                        remote_owner_country: nil,
                        remote_owner_address: nil,
                        remote_account: "NL46ABNA0499998748",
                        remote_bank_bic: "ABNANL2A"
                    }
                }
            ]
        },
        {
            ex_date: "2013-04-02",
            eff_date: "2013-04-02",
            type: {proprietary_code: "N946", proprietary_issuer: "ABNAMRO"},
            amount: 1.0,
            details: [
                {
                    references: ["NOTPROVIDED", "1234567812345678"],
                    party: {
                        remote_owner: "NAAM",
                        remote_owner_country: nil,
                        remote_owner_address: nil,
                        remote_account: "NL46ABNA0499998748",
                        remote_bank_bic: "ABNANL2A"
                    }
                }
            ]
        },
        {
            ex_date: "2013-04-02",
            eff_date: "2013-04-02",
            type: {proprietary_code: "N946", proprietary_issuer: "ABNAMRO"},
            amount: 10.0,
            details: [
                {
                    references: ["NOTPROVIDED", "1234567812345678"],
                    party: {
                        remote_owner: "NAAM",
                        remote_owner_country: nil,
                        remote_owner_address: nil,
                        remote_account: "NL46ABNA0499998748",
                        remote_bank_bic: "ABNANL2A"}
                },
                {
                    references: ["NOTPROVIDED", "1234567812345678"],
                    party: {
                        remote_owner: "NAAM",
                        remote_owner_country: nil,
                        remote_owner_address: nil,
                        remote_account: "NL46ABNA0499998748",
                        remote_bank_bic: "ABNANL2A"
                    }
                },
                {
                    references: ["NOTPROVIDED", "1234567812345678"],
                    party: {
                        remote_owner: "NAAM",
                        remote_owner_country: nil,
                        remote_owner_address: nil,
                        remote_account: "NL46ABNA0401378749",
                        remote_bank_bic: "ABNANL2A"
                    }
                },
                {
                    references: ["NOTPROVIDED", "1234567812345678"],
                    party: {
                        remote_owner: "NAAM",
                        remote_owner_country: nil,
                        remote_owner_address: nil,
                        remote_account: "NL46ABNA0401378749",
                        remote_bank_bic: "ABNANL2A"
                    }
                },
                {
                    references: ["NOTPROVIDED", "1234567812345678"],
                    party: {
                        remote_owner: "NAAM",
                        remote_owner_country: nil,
                        remote_owner_address: nil,
                        remote_account: "NL46ABNA0401378749",
                        remote_bank_bic: "ABNANL2A"
                    }
                },
                {
                    references: ["NOTPROVIDED", "1234567812345678"],
                    party: {
                        remote_owner: "NAAM",
                        remote_owner_country: nil,
                        remote_owner_address: nil,
                        remote_account: "NL46ABNA0401378749",
                        remote_bank_bic: "ABNANL2A"
                    }
                },
                {
                    references: ["NOTPROVIDED", "1234567812345678"],
                    party: {
                        remote_owner: "NAAM",
                        remote_owner_country: nil,
                        remote_owner_address: nil,
                        remote_account: "NL46ABNA0401378749",
                        remote_bank_bic: "ABNANL2A"
                    }
                },
                {
                    references: ["NOTPROVIDED", "1234567812345678"],
                    party: {
                        remote_owner: "NAAM",
                        remote_owner_country: nil,
                        remote_owner_address: nil,
                        remote_account: "NL46ABNA0401378749",
                        remote_bank_bic: "ABNANL2A"
                    }
                },
                {
                    references: ["NOTPROVIDED", "1234567812345678"],
                    party: {
                        remote_owner: "NAAM",
                        remote_owner_country: nil,
                        remote_owner_address: nil,
                        remote_account: "NL46ABNA0401378749",
                        remote_bank_bic: "ABNANL2A"
                    }
                },
                {
                    references: ["NOTPROVIDED", "1234567812345678"],
                    party: {
                        remote_owner: "NAAM",
                        remote_owner_country: nil,
                        remote_owner_address: nil,
                        remote_account: "NL46ABNA0401378749",
                        remote_bank_bic: "ABNANL2A"
                    }
                }
            ]
        },
        {
            ex_date: "2013-04-02",
            eff_date: "2013-04-02",
            type: {proprietary_code: "N944", proprietary_issuer: "ABNAMRO"},
            amount: 1.0,
            details: [
                {
                    messages: ["2305271368 0050001248302363 pid2305271368t Mud Masters Mud Masters"],
                    references: ["01-04-2013 21:01 0050001248302363"],
                    party: {
                        remote_owner: "ING Bank",
                        remote_owner_country: nil,
                        remote_owner_address: nil,
                        remote_account: "NL21INGB0000773837",
                        remote_bank_bic: "INGBNL2A"
                    }
                }
            ]
        },
        {
            ex_date: "2013-04-02",
            eff_date: "2013-04-02",
            type: {proprietary_code: "N658", proprietary_issuer: "ABNAMRO"},
            amount: -1.0,
            details: [
                {
                    messages: ["2013-33"],
                    references: ["NOTPROVIDED"],
                    party: {
                        remote_owner: "Naam",
                        remote_owner_country: "NL",
                        remote_owner_address: nil,
                        remote_account: "NL87SNSB0941352955",
                        remote_bank_bic: "SNSBNL2A"
                    }
                }
            ]
        },
        {
            ex_date: "2013-04-02",
            eff_date: "2013-04-02",
            type: {proprietary_code: "N655", proprietary_issuer: "ABNAMRO"},
            amount: -2.0,
            details: [
                {
                    messages: ["2013-33"],
                    references: ["NOTPROVIDED"],
                    party: {
                        remote_owner: "Naam",
                        remote_owner_country: "NL",
                        remote_owner_address: nil,
                        remote_account: "NL87SNSB0941352955",
                        remote_bank_bic: "SNSBNL2A"
                    }
                },
                {
                    messages: ["2013-33"],
                    references: ["NOTPROVIDED"],
                    party: {
                        remote_owner: "Naam",
                        remote_owner_country: "NL",
                        remote_owner_address: nil,
                        remote_account: "NL87SNSB0941352955",
                        remote_bank_bic: "SNSBNL2A"
                    }
                }
            ]
        },
        {
            ex_date: "2013-04-02",
            eff_date: "2013-04-02",
            type: {proprietary_code: "N652", proprietary_issuer: "ABNAMRO"},
            amount: -2.0,
            details: []
        },
        {
            ex_date: "2013-04-02",
            eff_date: "2013-04-02",
            type: {proprietary_code: "N248", proprietary_issuer: "ABNAMRO"},
            amount: -1.0,
            details: [
                {
                    messages: ["REF 2202389041/ 708723862112/ 5401939189"],
                    references: ["540193918971"],
                    mandate_identifier: "N000001861650",
                    party: {
                        remote_owner: "Naam/SA",
                        remote_owner_country: "BE",
                        remote_owner_address: "Straat 34",
                        remote_account: "BE21319980275903",
                        remote_bank_bic: "BBRUBEBB"
                    }
                }
            ]
        },
        {
            ex_date: "2012-04-02",
            eff_date: "2012-04-02",
            type: {proprietary_code: "N247", proprietary_issuer: "ABNAMRO"},
            amount: 7.0,
            details: [
                {
                    messages: ["SIT DRIVER LI NOSIT DRIVER LI NOSITSIT DRIVER LI NOSIT DRIVER LI NOSITSIT DRIVER LI " \
                               "NOSIT DRIVER LI NOSITSIT DRIVER LI NOSIT DRIVER LI NOSIT"],
                    references: ["SDD SIT 024-1"],
                    mandate_identifier: "mandateref24-1",
                    party: {
                        remote_owner: "R12 SDD SIT2",
                        remote_owner_country: "NL",
                        remote_owner_address: "R12 SDD SIT2",
                        remote_account: "NL27ABNA0562326340",
                        remote_bank_bic: "ABNANL2A"
                    }
                },
                {
                    messages: ["SIT DRIVER LI NOSIT DRIVER LI NOSITSIT DRIVER LI NOSIT DRIVER LI NOSITSIT DRIVER LI " \
                               "NOSIT DRIVER LI NOSITSIT DRIVER LI NOSIT DRIVER LI NOSIT"],
                    references: ["SDD SIT 024-2"],
                    mandate_identifier: "mandateref24-2",
                    party: {
                        remote_owner: "R12 SDD SIT2",
                        remote_owner_country: "NL",
                        remote_owner_address: "R12 SDD SIT2",
                        remote_account: "NL27ABNA0562326340",
                        remote_bank_bic: "ABNANL2A"
                    }
                },
                {
                    messages: ["SIT DRIVER LI NOSIT DRIVER LI NOSITSIT DRIVER LI NOSIT DRIVER LI NOSITSIT DRIVER LI " \
                               "NOSIT DRIVER LI NOSITSIT DRIVER LI NOSIT DRIVER LI NOSIT"],
                    references: ["SDD SIT 024-3"],
                    mandate_identifier: "mandateref24-3",
                    party: {
                        remote_owner: "R12 SDD SIT2",
                        remote_owner_country: "NL",
                        remote_owner_address: "R12 SDD SIT2",
                        remote_account: "NL27ABNA0562326340",
                        remote_bank_bic: "ABNANL2A"
                    }
                },
                {
                    messages: ["SIT DRIVER LI NOSIT DRIVER LI NOSITSIT DRIVER LI NOSIT DRIVER LI NOSITSIT DRIVER LI " \
                               "NOSIT DRIVER LI NOSITSIT DRIVER LI NOSIT DRIVER LI NOSIT"],
                    references: ["SDD SIT 024-4"],
                    mandate_identifier: "mandateref24-4",
                    party: {
                        remote_owner: "R12 SDD SIT2",
                        remote_owner_country: "NL",
                        remote_owner_address: "R12 SDD SIT2",
                        remote_account: "NL27ABNA0562326340",
                        remote_bank_bic: "ABNANL2A"
                    }
                },
                {
                    messages: ["SIT DRIVER LI NOSIT DRIVER LI NOSITSIT DRIVER LI NOSIT DRIVER LI NOSITSIT DRIVER LI " \
                               "NOSIT DRIVER LI NOSITSIT DRIVER LI NOSIT DRIVER LI NOSIT"],
                    references: ["SDD SIT 024-5"],
                    mandate_identifier: "mandateref24-5",
                    party: {
                        remote_owner: "R12 SDD SIT2",
                        remote_owner_country: "NL",
                        remote_owner_address: "R12 SDD SIT2",
                        remote_account: "NL27ABNA0562326340",
                        remote_bank_bic: "ABNANL2A"
                    }
                },
                {
                    messages: ["SIT DRIVER LI NOSIT DRIVER LI NOSITSIT DRIVER LI NOSIT DRIVER LI NOSITSIT DRIVER LI " \
                               "NOSIT DRIVER LI NOSITSIT DRIVER LI NOSIT DRIVER LI NOSIT"],
                    references: ["SDD SIT 024-6"],
                    mandate_identifier: "mandateref24-6",
                    party: {
                        remote_owner: "R12 SDD SIT2",
                        remote_owner_country: "NL",
                        remote_owner_address: "R12 SDD SIT2",
                        remote_account: "NL27ABNA0562326340",
                        remote_bank_bic: "ABNANL2A"
                    }
                },
                {
                    messages: ["SIT DRIVER LI NOSIT DRIVER LI NOSITSIT DRIVER LI NOSIT DRIVER LI NOSITSIT DRIVER LI " \
                               "NOSIT DRIVER LI NOSITSIT DRIVER LI NOSIT DRIVER LI NOSIT"],
                    references: ["SDD SIT 024-7"],
                    mandate_identifier: "mandateref24-7",
                    party: {
                        remote_owner: "R12 SDD SIT2",
                        remote_owner_country: "NL",
                        remote_owner_address: "R12 SDD SIT2",
                        remote_account: "NL27ABNA0562326340",
                        remote_bank_bic: "ABNANL2A"
                    }
                }
            ]
        },
        {
            ex_date: "2012-04-02",
            eff_date: "2012-04-02",
            type: {proprietary_code: "N247", proprietary_issuer: "ABNAMRO"},
            amount: 7.0,
            details: []
        },
        {
            ex_date: "2012-04-02",
            eff_date: "2012-04-02",
            type: {proprietary_code: "N246", proprietary_issuer: "ABNAMRO"},
            amount: -1.0,
            details: [
                {
                    messages: ["Levering maand mei, zie nota 1234556. Uw klantnummer 123455666"],
                    references: ["1234567X908303803"],
                    mandate_identifier: "123456789XXmandaat",
                    reason: {
                        code: "MS03",
                        description: "Reason not specified"
                    },
                    party: {
                        remote_owner: "Debtor",
                        remote_owner_country: "NL",
                        remote_owner_address: "R12 SDD SIT2",
                        remote_account: "NL27ABNA0562326340",
                        remote_bank_bic: "ABNANL2A"
                    }
                }
            ]
        },
        {
            ex_date: "2012-04-02",
            eff_date: "2012-04-02",
            type: {proprietary_code: "N245", proprietary_issuer: "ABNAMRO"},
            amount: -921.0,
            details: [
                {
                    messages: ["Levering maand mei, zie nota 1234557. Uw klantnummer 123455666"],
                    references: ["1234567X908303804"],
                    mandate_identifier: "123456788XXmandaat",
                    reason: {
                        code: "MS03",
                        description: "Reason not specified"
                    },
                    party: {
                        remote_owner: "Debtor",
                        remote_owner_country: "NL",
                        remote_owner_address: "R12 SDD SIT2",
                        remote_account: "NL27ABNA0592326340",
                        remote_bank_bic: "ABNANL2A"
                    }
                }
            ]
        }
    ]
  end

  it_behaves_like "any CAMT.053 file"

end
