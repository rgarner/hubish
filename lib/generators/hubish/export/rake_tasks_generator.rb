class RakeTasksGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.template('github.rb', 'lib/tasks/github.rake')
    end    
  end  
end
