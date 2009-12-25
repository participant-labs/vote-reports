namespace :db do
  namespace :sanity_check do
    desc "Check politicians"
    task :politicians => :environment do
      invalid_politicians = Politician.all.reject(&:valid?)
      invalid_politicians.each do |politician|
        puts "#{politician.id} #{politician.full_name} is invalid:"
        politician.errors.full_messages.each do |message|
          puts " * #{message}"
        end
      end
      puts "#{invalid_politicians.size} Invalid Politicians"
    end

    desc "Check bills"
    task :bills => :environment do
      invalid_bills = Bill.all.reject(&:valid?)
      invalid_bills.each do |bill|
        puts "#{bill.id} #{bill.title} is invalid:"
        bill.errors.full_messages.each do |message|
          puts " * #{message}"
        end
      end
      puts "#{invalid_bills.size} Invalid Bills"
    end
  end
end
