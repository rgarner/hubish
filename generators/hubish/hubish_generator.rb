class HubishGenerator < Rails::Generator::NamedBase
  attr_reader :repo
  
  def initialize(runtime_args, runtime_options = {})
    super
    raise ArgumentError, "repo name expected as only argument" if name.nil?
    @repo = name
  end
  
  def manifest
    record do |m|
      m.template('github.rb', 'lib/tasks/github.rake')
    end    
  end  
end
