require 'csv_utility'

RSpec.describe CsvUtility do
  it 'transforms to CSV' do
    to_csv = [{:col1 => 'abc', :col2 => 'def'}, {:col1 => 'ghi', :col2 => 'jkl'}]
    csv = CsvUtility.to_csv(to_csv, :headers => ['Col1', 'Col2']) {|row| [row[:col1], row[:col2]]}
    row1 = csv.split()[1]
    row2 = csv.split()[2]
    expect(row1).to eq('abc,def')
    expect(row2).to eq('ghi,jkl')
  end

  it 'uses the headers provided' do
    csv = CsvUtility.to_csv([], :headers => ['Col1', 'Col2', 'Col3']) {|row| ['', '', ''] }
    headers = csv.split()[0]
    expect(headers).to eq('Col1,Col2,Col3')
  end
end
