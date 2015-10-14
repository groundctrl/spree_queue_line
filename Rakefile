require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'
require 'spree/testing_support/extension_rake'

RSpec::Core::RakeTask.new

task :default do
  if Dir["spec/dummy"].empty?
    Rake::Task[:test_app].invoke
    Dir.chdir("../../")
  end
  Rake::Task[:spec].invoke
end

desc 'Generates a dummy app for testing'
task :test_app do
  ENV['LIB_NAME'] = 'spree_queue_line'
  Rake::Task['extension:test_app'].invoke

  # Add Active Job configuration for dummy app
  unless File.exist?("config/initializers/active_job.rb")
    File.open("config/initializers/active_job.rb", "w") do |file|
      file.write "Rails.configuration.active_job.queue_adapter = :delayed_job"
    end

    sh "bin/rails", "generate", "delayed_job:active_record"
    sh "bin/rake", "db:migrate"
  end
end
