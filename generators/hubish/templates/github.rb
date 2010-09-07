require 'github_exporter'

namespace :github do
  desc "Export github issues (pass credentials through rake parameters or GITHUB_LOGIN=, GITHUB_TOKEN=)"
  task :export, :login, :token, :needs => :environment do |t, args|
    exporter = GitHub::Exporter.new('<%= repo %>', args.login || ENV['GITHUB_LOGIN'], args.token || ENV['GITHUB_TOKEN'])
    exporter.export!
    puts exporter.issues
  end
end