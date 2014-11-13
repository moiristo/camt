RSpec.shared_examples_for "any CAMT.053 file" do

  let :filename do |example|
    example.metadata[:example_group][:parent_example_group][:description]
  end

  let(:file) { Camt::File.parse(::File.expand_path("../../sample_files/" << filename, __FILE__)) }
  let(:statement) { file.statements.first }

  it "has the correct IBAN" do
    expect(statement.iban).to eq expected_iban
  end

  it "has CHF as currency" do
    expect(statement.local_currency).to eq expected_currency
  end

end
