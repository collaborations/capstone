LB = "=" * 80

namespace :db do
  desc "Run all database checks"
  task :check do
    Rake::Task["db:check:contacts"].invoke
    Rake::Task["db:check:hours"].invoke
    Rake::Task["db:check:institution_details"].invoke
    Rake::Task["db:check:locations"].invoke
  end

  namespace :check do
    # VARIABLE SETUP
    task :setup_variables do
      INSTITUTION_JUSTIFY = Institution.all.length.to_s.split('').length
    end

    # Contact
    desc "Checks status of Contact records"
    task :contacts => [:environment, :setup_variables] do
      puts ["\n\n", LB, "Checking Contacts", LB].join("\n")
      c_total = Contact.all.length
      CONTACT_JUSTIFY = c_total.to_s.split('').length

      institutions = Institution.all.pluck(:id)
      contacts = Contact.all.pluck(:id)

      i_total = 0
      Institution.all.each do |i|
        if i.contact.nil?
          puts "FAILED: No CONTACT records for INSTITUTION: #{i.id} - #{i.name}"
        elsif i.contact.instance_of? Contact
          i_total += 1
          puts "--> OK: 1 CONTACT record  for INSTITUTION: #{i.id.to_s.rjust(INSTITUTION_JUSTIFY)} - #{i.name}"
          institutions.delete(i.id)
          contacts.delete(i.institution_detail.id)
        elsif i.contact.instance_of? Contact::ActiveRecord_Relation
          puts "WARNING: More than one CONTACT record for INSTITUTION: #{i.id} - #{i.name}"
        end
      end

      puts "\n"
      puts "In total there #{(c_total == 1) ? 'is' : 'are' } #{c_total} CONTACT #{'record'.pluralize(c_total)}"

      # Check to see that the number of Institution and Contact records match (ONE-ONE relationship).
      if i_total != c_total
        puts "\n\n"
        puts "WARNING: Number of INSTITUTIONS records (#{i_total}) and CONTACT records (#{c_total}) differ."
      end

      if not institutions.empty?
        puts "The following Institutions do not have Contact objects: " + institutions.to_s
      end

      if not contacts.empty?
        puts "The following Contacts do not have Institution objects: " + contacts.to_s
      end
      puts "\n\n"
    end

    # Hours
    desc "Checks status of Hours records"
    task :hours => [:environment, :setup_variables] do
      puts ["\n\n", LB, "Checking Hours", LB].join("\n")
      h_total = Hours.all.length
      HOURS_JUSTIFY = h_total.to_s.split('').length

      institutions = Institution.all.pluck(:id)
      hours = Hours.all.pluck(:id)

      i_total = 0
      Institution.all.each do |i|
        if i.hours.nil?
          puts "FAILED: No HOURS records for INSTITUTION: #{i.id} - #{i.name}"
        elsif i.hours.instance_of? Hours
          i_total += 1
          puts "--> OK: 1 HOURS record  for INSTITUTION: #{i.id.to_s.rjust(INSTITUTION_JUSTIFY)} - #{i.name}"
          institutions.delete(i.id)
          hours.delete(i.institution_detail.id)
        elsif i.hours.instance_of? Hours::ActiveRecord_Relation
          puts "WARNING: More than one HOURS record for INSTITUTION: #{i.id} - #{i.name}"
        end
      end

      puts "\n"
      puts "In total there #{(h_total == 1) ? 'is' : 'are' } #{h_total} HOURS #{'record'.pluralize(h_total)}"

      # Check to see that the number of Institution and Hours records match (ONE-ONE relationship).
      if i_total != h_total
        puts "\n\n"
        puts "WARNING: Number of INSTITUTIONS records (#{i_total}) and HOURS records (#{h_total}) differ."
      end

      if not institutions.empty?
        puts "The following Institutions do not have Hours objects: " + institutions.to_s
      end

      if not hours.empty?
        puts "The following Hours do not have Institution objects: " + hours.to_s
      end
      puts "\n\n"
    end

    # Institution Details
    desc "Checks status of InstitutionDetail records"
    task :institution_details => [:environment, :setup_variables] do
      puts ["\n\n", LB, "Checking Institution Details", LB].join("\n")
      id_total = InstitutionDetail.all.length
      ID_JUSTIFY = id_total.to_s.split('').length

      institutions = Institution.all.pluck(:id)
      institution_details = InstitutionDetail.all.pluck(:id)

      i_total = 0
      Institution.all.each do |i|
        if i.institution_detail.nil?
          puts "FAILED: No INSTITUTION_DETAIL records for INSTITUTION: #{i.id} - #{i.name}"
        elsif i.institution_detail.instance_of? InstitutionDetail
          i_total += 1
          puts "--> OK: 1 INSTITUTION_DETAIL record  for INSTITUTION: #{i.id.to_s.rjust(INSTITUTION_JUSTIFY)} - #{i.name}"
          institutions.delete(i.id)
          institution_details.delete(i.institution_detail.id)
        elsif i.institution_detail.instance_of? InstitutionDetail::ActiveRecord_Relation
          puts "WARNING: More than one INSTITUTION_DETAIL record for INSTITUTION: #{i.id} - #{i.name}"
        end
      end

      puts "\n"
      puts "In total there #{(id_total == 1) ? 'is' : 'are' } #{id_total} INSTITUTION_DETAIL #{'record'.pluralize(id_total)}"

      # Check to see that the number of Institution and InstitutionDetail records match (ONE-ONE relationship).
      if i_total != id_total
        puts "\n\n"
        puts "WARNING: Number of INSTITUTIONS records (#{i_total}) and INSTITUTION_DETAIL records (#{id_total}) differ."
      end

      if not institutions.empty?
        puts "The following Institutions do not have InstitutionDetail objects: " + institutions.to_s
      end

      if not institution_details.empty?
        puts "The following InstitutionDetails do not have Institution objects: " + institution_details.to_s
      end
      puts "\n\n"
    end

    # Locations
    desc "Checks status of Location records"
    task :locations => [:environment, :setup_variables] do
      puts ["\n\n", LB, "Checking Locations", LB].join("\n")
      l_total = Location.all.length
      LOCATION_JUSTIFY = l_total.to_s.split('').length

      institutions = Institution.all.pluck(:id)
      locations = Location.all.pluck(:id)

      i_total = 0
      Institution.all.each do |i|
        if i.locations.nil?
          puts "FAILED: No LOCATION records for INSTITUTION: #{i.id} - #{i.name}"
        else
          count = i.locations.length
          i_total += count
          puts "--> OK: #{count.to_s.rjust(LOCATION_JUSTIFY)} LOCATION #{'record'.pluralize(count).ljust(7)} for INSTITUTION: #{i.id.to_s.rjust(INSTITUTION_JUSTIFY)} - #{i.name}"
          i.locations.each do |l|
            locations.delete(l)
          end
          institutions.delete(i.id)
        end
      end
      puts "\n"
      puts "INSTITUTIONS make up #{i_total} LOCATION #{'record'.pluralize(i_total)}"
      puts "In total there are #{l_total} LOCATION #{'record'.pluralize(l_total)}"

      if not institutions.empty?
        puts "The following Institutions do not have Location objects: " + institutions.to_s
      end

      if not locations.empty?
        puts "The following Locations do not have Institution objects: " + locations.to_s
      end
      puts "\n\n"
    end
  end
end
