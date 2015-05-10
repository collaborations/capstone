namespace :daniel do
  desc "Terminate Postgres users to enable db:drop"
  task force: :environment do
  	puts "Daniel here, cleaning up your mess..."
  	puts "Now terminating all instances"
  	sh "echo 'SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE datname = current_database() AND pg_stat_activity.pid <> pg_backend_pid();' | rails db"
  	puts ""
  	Rake::Task['daniel:clean'].invoke
  	puts "done :)"
  end

  task clean: :environment do
  	puts "now dropping current database"
  	Rake::Task['db:drop'].invoke
  	puts "now creeating db"
  	Rake::Task['db:create'].invoke
  	puts "now migrating"
  	Rake::Task['db:migrate'].invoke
  	puts "now seeding database"
  	Rake::Task['db:seed'].invoke
  end
end
