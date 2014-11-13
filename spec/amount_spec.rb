RSpec.describe Camt::Amount do

  let(:value) { 1337.23 }
  let(:currency) { "GBP" }
  let(:credit_debit_type) { "CRDT"}

  let :xml_node do
    Nokogiri::XML::Builder.new { |xml|
      xml.root do
        xml.Amt(value, :Ccy => currency)
        xml.CdtDbtInd(credit_debit_type)
      end
    }.doc.at("./root")
  end

  subject { described_class.new(xml_node) }

  describe "#value" do
    context "when amount is positive" do
      it "returns the correct value" do
        expect(subject.value).to eq value
      end
    end

    context "when amount is negative" do
      let(:credit_debit_type) { "DBIT"}

      it "returns the correct value" do
        expect(subject.value).to eq(0 - value)
      end
    end
  end

  describe "#currency" do
    it "returns the currency" do
      expect(subject.currency).to eq currency
    end
  end
end
