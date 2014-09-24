require 'csv'

class CsvUtility
  def self.to_csv(to_csv, opts, &block)
    options = {}.merge(opts)

    csv = CSV.generate do |csv|
      csv << options[:headers]
      to_csv.each do |row|
        csv << yield(row) if block_given?
      end
    end
    csv
  end
end
