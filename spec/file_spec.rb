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
end
