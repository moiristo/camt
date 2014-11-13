RSpec.describe Camt::File do

  let(:filename) { "camt.xml" }

  subject { Camt::File.parse(::File.expand_path("../sample_files/" << filename, __FILE__)) }

  it "has any messages" do
    expect(subject.messages).to be_any
  end

  it "has any statements" do
    expect(subject.statements).to be_any
  end

  it "has any transactions" do
    expect(subject.transactions).to be_any
  end

  describe "valid?" do
    context "when document has no error" do
      it "returns true" do
        expect(subject.valid?).to be true
      end
    end

    context "when document has an error" do
      let(:filename) { "camt_error.xml" }

      it "returns false" do
        expect(subject.valid?).to be false
      end
    end
  end

  describe "errors" do
    context "when document has no error" do
      it "returns an empty array" do
        expect(subject.errors).to eq []
      end
    end

    context "when document has an error" do
      let(:filename) { "camt_error.xml" }

      it "returns the XML errors" do
        expect(subject.errors.size).to eq 9
      end
    end
  end
end
