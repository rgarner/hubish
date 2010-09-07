require 'github_exporter'

namespace :github do
  desc "Export github issues"
  task :export, :login, :token, :needs => :environment do |t, args|
    exporter = GitHub::Exporter.new('your_project_here', args.login || ENV['GITHUB_LOGIN'], args.token || ENV['GITHUB_TOKEN'])
    exporter.export!
    puts exporter.issues
  end
end