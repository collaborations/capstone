namespace :db do
  namespace :setup do
    # Filters
    desc "Ensures every Institution has a filters object"
    task :filters => :environment do
      Institution.all.each do |i|
        if i.filter.nil?
          i.filter = Filter.create(institution_id: i.id)
          if i.save
            puts "--> OK: Created FILTERS for INSTITUTION: #{i.id} - #{i.name}"
          else
            puts "FAILED: Failed to create missing FILTERS for INSTITUTION: #{i.id} - #{i.name}"
          end
        elsif i.filter.length > 1
          puts "WARNING: More than one FILTERS record for INSTITUTION: #{i.id} - #{i.name}"
        end
      end
    end

    # Hours
    desc "Ensures every Institution has an hours object"
    task :hours => :environment do
      Institution.all.each do |i|
        if i.hours.nil?
          i.hours = Hours.create(institution_id: i.id)
          if i.save
            puts "--> OK: Created HOURS for INSTITUTION: #{i.id} - #{i.name}"
          else
            puts "FAILED: Failed to create missing HOURS for INSTITUTION: #{i.id} - #{i.name}"
          end
        elsif i.hours.instance_of? Hours::ActiveRecord_Relation
          puts "WARNING: More than one HOURS record for INSTITUTION: #{i.id} - #{i.name}"
        end
      end
    end
  end
end