RSpec.describe Camt::Transaction do

  let(:filename) { "camt.xml" }
  let(:file) { Camt::File.parse(::File.expand_path("../sample_files/" << filename, __FILE__)) }
  let(:doc) { file.doc.tap { |doc| doc.remove_namespaces! } }
  let(:node) { doc.xpath('//BkToCstmrStmt/Stmt/Ntry')[1] }
  let(:country_code) { "NL" }

  subject { described_class.new(node, country_code) }

  describe "#execution_date" do
    let(:expected) { Date.parse("2013-04-02") }

    it "has the value from the parsed file" do
      expect(subject.execution_date).to eq expected
    end
  end

  describe "#effective_date" do
    let(:expected) { Date.parse("2013-04-02") }

    it "has the value from the parsed file" do
      expect(subject.effective_date).to eq expected
    end
  end

  describe "#transfer_type" do
    let(:expected) { {proprietary_code: "N654", proprietary_issuer: "ABNAMRO"} }

    it "has the value from the parsed file" do
      expect(subject.transfer_type).to eq expected
    end
  end

  describe "#transferred_amount" do
    let(:expected) { 1.0 }

    it "has the value from the parsed file" do
      expect(subject.transferred_amount).to eq expected
    end
  end

  describe "#transaction_details" do
    let :expected do
      [{
          :messages => ["OMSCHRIJVING"],
          :references => ["NOTPROVIDED"],
          :party => {
              :remote_owner => "NAAM",
              :remote_owner_country => nil,
              :remote_owner_address => nil,
              :remote_account => "NL46ABNA0499998748",
              :remote_bank_bic => "ABNANL2A"
          }
      }]
    end

    it "has the value from the parsed file" do
      expect(subject.transaction_details).to eq expected
    end
  end

  describe "#purpose" do
    let(:expected) { "/TRTP/SEPA OVERBOEKING/IBAN/NL46ABNA0499998748/BIC/" \
                     "ABNANL2A/NAME/NAAM/REMI/OMSCHRIJVING/EREF/NOTPROVIDED" }

    it "has the value from the parsed file" do
      expect(subject.purpose).to eq expected
    end
  end
end
