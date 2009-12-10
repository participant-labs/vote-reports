namespace :db do
  namespace :sanity_check do
    desc "Check politicians"
    task :politicians => :environment do
      Politician.all.reject(&:valid?).each do |politician|
        puts "#{politician.id} #{politician.full_name} is invalid:", politician.errors.full_messages
      end
    end
  end
end
