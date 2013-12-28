require 'bundler'
Bundler.require(:default)

require_relative 'models/test'

ActiveSupport.on_load(:active_record) do
  ActiveRecord::Base.establish_connection(YAML::load(File.open('config/database.yml')))
  ActiveRecord::Base.logger = Logger.new(STDOUT)
end

def run_test
  puts "Thread #{Thread.current.object_id} reporting for duty."
  loop do
    #ActiveRecord::Base.connection_pool.with_connection do
      ActiveRecord::Base.connection_pool.connections.map(&:verify!)
      Test.all.to_a
      ActiveRecord::Base.clear_active_connections!
    #end
  end
end

t = []
(1..32).each do |i|
  t << Thread.new { run_test }
end

t.each { |thread| thread.join }
