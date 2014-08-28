require 'rest_client'

namespace :task do
  desc "TODO"
  task process: :environment do
    puts "process"

    p RestClient.get 'https://arpcdev.leankit.com/Kanban/Api/Board/46341228/GetBoardIdentifiers', { user: 'c.jekal@arpc.com', password: 'yagni' }
  end

  desc "TODO"
  task upload: :environment do
    puts "upload"
  end

end
