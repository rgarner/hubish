require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require "github_exporter"

describe GitHub::Exporter do
  TOKEN = '2eb23873fab2eb'
  LOGIN = 'colin'
  
  describe "Required credentials" do
    it "needs a login" do
      lambda {GitHub::Exporter.new('reponame', nil, TOKEN)}.should raise_error ArgumentError
    end
    
    it "needs a token" do
      lambda {GitHub::Exporter.new('reponame', LOGIN, nil)}.should raise_error ArgumentError
    end     
    
    it "needs both login and token" do
      GitHub::Exporter.new('reponame', LOGIN, TOKEN)
    end 
  end
end
