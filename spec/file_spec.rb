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

    context "when document isn't even XML" do
      let(:filename) { "../spec_helper.rb" }

      it "returns the XML errors" do
        expect(subject.errors.size).to eq 1
      end
    end
  end

  describe "configuration" do
    context "when a default country code is set" do
      it "uses the default country code" do
        expect(subject.country_code).to eq "XY"
      end

      it "does not raise an error" do
        expect { subject }.not_to raise_error
      end
    end

    context "when no default country code is set" do
      around do |example|
        current_country_code = nil

        Camt.configure do |config|
          current_country_code = config.default_country_code
          config.default_country_code = nil
        end

        example.run

        Camt.configure do |config|
          config.default_country_code = current_country_code
        end
      end

      it "raises an ArgumentError" do
        expect { subject }.to raise_error(ArgumentError)
      end
    end
  end
end
