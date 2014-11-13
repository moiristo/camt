RSpec.describe Camt::Statement do

  let(:filename) { "camt.xml" }
  let(:file) { Camt::File.parse(::File.expand_path("../sample_files/" << filename, __FILE__)) }
  let(:doc) { file.doc.tap { |doc| doc.remove_namespaces! } }
  let(:node) { doc.xpath('//BkToCstmrStmt/Stmt').first }
  let(:country_code) { "NL" }

  subject { described_class.new(node, country_code) }

  describe "#id" do
    let(:expected) { "0574908765.2013-04-02" }

    it "has the value from the parsed file" do
      expect(subject.id).to eq expected
    end
  end

  describe "#electronic_sequence_number" do
    let(:expected) { "0070" }

    it "has the value from the parsed file" do
      expect(subject.electronic_sequence_number).to eq expected
    end
  end

  describe "#created_at" do
    let(:expected) { Time.parse("2013-04-12T10:55:08.66+02:00") }

    it "has the value from the parsed file" do
      expect(subject.created_at).to eq expected
    end
  end

  describe "#local_account" do
    let(:expected) { "NL77ABNA0574908765" }

    it "has the value from the parsed file" do
      expect(subject.local_account).to eq expected
    end
  end

  describe "#local_currency" do
    let(:expected) { "EUR" }

    it "has the value from the parsed file" do
      expect(subject.local_currency).to eq expected
    end
  end

  describe "#date" do
    let(:expected) { Date.parse("2013-04-02") }

    it "has the value from the parsed file" do
      expect(subject.date).to eq expected
    end
  end

  describe "#start_balance" do
    let(:expected) { 1000.01 }

    it "has the value from the parsed file" do
      expect(subject.start_balance).to eq expected
    end
  end

  describe "#end_balance" do
    let(:expected) { 100.01 }

    it "has the value from the parsed file" do
      expect(subject.end_balance).to eq expected
    end
  end

  describe "#transactions" do
    let(:expected) { Array.new }

    xit "has the value from the parsed file" do
      expect(subject.transactions).to eq expected
    end
  end
end
