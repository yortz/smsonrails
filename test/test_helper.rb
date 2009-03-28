require 'rubygems'
require 'active_support'
require 'active_support/test_case'
require 'active_record'
require 'test/unit'

dir = File.dirname(__FILE__)
require dir +'/prepare_test'
require dir +'/../init'
require dir + '/../db/schema.rb'




begin
  if File.exists?(sdir = File.join(dir, '/../../static_record_cache') )
    require File.join(sdir, 'init.rb')
  else
    require 'acts_as_static_record'
  end
  unless ActiveRecord::Base.respond_to?(:acts_as_static_record)
    raise "Need to install static_record_cache"
  end
rescue Exception => exc
  raise "Please install dependency static_record_cache"
end

require 'sms_on_rails/all_models'

load File.dirname(__FILE__) + '/../db/seed_data.rb'

