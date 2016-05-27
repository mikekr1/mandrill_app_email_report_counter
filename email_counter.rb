require 'csv'

class MandrillAppEmailReportCounter
  def initialize(file)
    @file = file
  end

  def count
    emails = Hash.new(0)

    ::CSV.foreach(@file, headers: true) do |row|
      count += 1
      emails[row['Email Address']] += 1
    end

    File.open('lib/duplicate_emails.csv', 'wb') do |file|
      emails.each do |email, count|
        file.puts email if count > 1
      end
    end

    File.open('lib/duplicate_emails_with_count.csv', 'wb') do |file|
      emails.each do |email, count|
        file.puts "#{count}, #{email}" if count > 1
      end
    end
  end
end

MandrillAppEmailReportCounter.new('lib/activity.csv').count
