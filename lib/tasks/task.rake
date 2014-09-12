
namespace :task do
  desc "TODO"
  task process: :environment do
    puts "process"

  end

  desc "TODO"
  task upload: :environment do
    puts "upload"
  end

end
