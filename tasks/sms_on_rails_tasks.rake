

namespace :sms do
  desc 'Reset the Sms data'
  task :reset => [ :teardown, :setup ]

  desc 'Create Tables and seed them'
  task :setup => [ :create_tables, :seed_tables ]

  desc 'Remove all sms data'
  task :teardown => :drop_tables

  desc 'Create Sms database tables'
  task :create_tables => :environment do
    raise "Task unavailable to this database (no migration support)" unless ActiveRecord::Base.connection.supports_migrations?
    load File.dirname(__FILE__) + '/../db/schema.rb'
  end

  desc 'Seed tables'
  task :seed_tables => :environment do
    puts "Seeding SMS tables..."
    load File.dirname(__FILE__) + '/../db/seed_data.rb'
  end
  
  desc 'Create New Specialized Gateway Template'
  task :create_email_template => :environment do
    raise "Task unavailable to this database (no migration support)" unless ActiveRecord::Base.connection.supports_migrations?

    default_path = 'sms_on_rails/service_providers/email_gateway_support/sms_mailer'
    default_template_name = 'sms_through_gateway.erb'
    dest_path = File.join(ActionMailer::Base.template_root, default_path)
    FileUtils.mkdir_p(dest_path)

    dest = File.join(dest_path, default_template_name)
    unless File.exists?(dest)
      src = File.join(File.dirname(__FILE__), '../lib', default_path, 'sms_through_gateway.erb')
      FileUtils.cp(src, dest)
    end

    config = "\n# Place email gateway templates in the default view directory"
    config << "\n# To configure your sms messages, edit file:"
    config << "\n#  #{dest.gsub(RAILS_ROOT, '')} "

    #relative_root = File.expand_path(ActionMailer::Base.template_root.to_s)
    #relative_root.gsub!(RAILS_ROOT+'/', '/..')
    #config << "File.dirname(__FILE__) + #{relative_root.inspect}\n\n"
    config << "\nSmsOnRails::ServiceProviders::EmailGatewaySupport::SmsMailer.template_root= "
    config << "ActionMailer::Base.template_root\n\n"
    
    File.open(File.join(RAILS_ROOT, 'config/environment.rb'), 'a') {|file| file.puts config }

    puts "environment.rb has been updated to set your new template path."
    puts "Please edit the template in the file:\n #{dest}"
    
  end

end