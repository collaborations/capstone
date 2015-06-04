namespace :db do
  namespace :setup do
    # Contact
    desc "Ensures every Institution has an contact object"
    task :contacts => :environment do
      Institution.all.each do |i|
        if i.contact.nil?
          i.contact = Contact.create(institution_id: i.id)
          if i.save
            puts "--> OK: Created CONTACT for INSTITUTION: #{i.id} - #{i.name}"
          else
            puts "FAILED: Failed to create missing CONTACT for INSTITUTION: #{i.id} - #{i.name}"
          end
        elsif i.contact.instance_of? Contact::ActiveRecord_Relation
          puts "WARNING: More than one CONTACT record for INSTITUTION: #{i.id} - #{i.name}"
        end
      end
    end

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
        else
          puts "--> OK: Filter exists for INSTITUTION: #{i.id} - #{i.name}"
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

    # InstitutionDetail
    desc "Ensures every Institution has a InstitutionDetail object"
    task :institution_detail => :environment do
      Institution.all.each do |i|
        if i.institution_detail.nil?
          i.institution_detail = InstitutionDetail.create(institution_id: i.id)
          if i.save
            puts "--> OK: Created INSTITUTION_DETAIL for INSTITUTION: #{i.id} - #{i.name}"
          else
            puts "FAILED: Failed to create missing INSTITUTION_DETAIL for INSTITUTION: #{i.id} - #{i.name}"
          end
        elsif i.contact.instance_of? InstitutionDetail::ActiveRecord_Relation
          puts "WARNING: More than one INSTITUTION_DETAIL record for INSTITUTION: #{i.id} - #{i.name}"
        end
      end
    end
  end
end
