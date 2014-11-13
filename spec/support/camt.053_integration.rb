RSpec.shared_examples_for "any CAMT.053 file" do

  let :filename do |example|
    example.metadata[:example_group][:parent_example_group][:description]
  end

  let(:file) { Camt::File.parse(::File.expand_path("../../sample_files/" << filename, __FILE__)) }
  let(:statement) { file.statements.first }

  it "has the correct Id" do
    expect(statement.id).to eq expected_id
  end

  it "has the correct electronic sequence number" do
    expect(statement.electronic_sequence_number).to eq expected_electronic_sequence_number
  end

  it "has the correct creation time" do
    expect(statement.created_at).to eq Time.parse(expected_creation_time)
  end

  it "has the correct IBAN" do
    expect(statement.iban).to eq expected_iban
  end

  it "has the correct currency" do
    expect(statement.local_currency).to eq expected_currency
  end

  it "has the correct date" do
    expect(statement.date).to eq Date.parse(expected_date)
  end

  it "has the correct start balance" do
    expect(statement.start_balance).to eq expected_start_balance
  end

  it "has the correct end balance" do
    expect(statement.end_balance).to eq expected_end_balance
  end

  it "has the correct number of transactions" do
    expect(statement.transactions.size).to eq expected_transactions.size
  end

  it "has the correct transaction data" do
    expected_transactions.each_with_index do |expected, index|
      transaction = statement.transactions[index]
      expect(transaction.execution_date).to eq Date.parse(expected[:ex_date])
      expect(transaction.effective_date).to eq Date.parse(expected[:eff_date])
      expect(transaction.type).to eq expected[:type]
      expect(transaction.amount).to eq expected[:amount]
      expect(transaction.details).to eq expected[:details]
    end
  end
end
