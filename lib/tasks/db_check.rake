LB = "=" * 80

namespace :db do
  desc "Run all database checks"
  task :check do
    Rake::Task["db:check:contacts"].invoke
    Rake::Task["db:check:hours"].invoke
    Rake::Task["db:check:locations"].invoke
  end

  namespace :check do
    # VARIABLE SETUP
    task :setup_variables do
      INSTITUTION_JUSTIFY = Institution.all.length.to_s.split('').length
    end

    # Contact
    desc "Checks status of institution contact records"
    task :contacts => [:environment, :setup_variables] do
      puts ["\n\n", LB, "Checking Contacts", LB].join("\n")
      c_total = Contact.all.length
      CONTACT_JUSTIFY = c_total.to_s.split('').length

      i_total = 0
      Institution.all.each do |i|
        if i.contact.nil?
          puts "FAILED: No CONTACT records for INSTITUTION: #{i.id} - #{i.name}"
        elsif i.contact.instance_of? Contact
          i_total += 1
          puts "--> OK: 1 CONTACT record  for INSTITUTION: #{i.id.to_s.rjust(INSTITUTION_JUSTIFY)} - #{i.name}"
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
      puts "\n\n"
    end

    # Hours
    desc "Checks status of institution hours records"
    task :hours => [:environment, :setup_variables] do
      puts ["\n\n", LB, "Checking Hours", LB].join("\n")
      h_total = Hours.all.length
      HOURS_JUSTIFY = h_total.to_s.split('').length

      i_total = 0
      Institution.all.each do |i|
        if i.hours.nil?
          puts "FAILED: No HOURS records for INSTITUTION: #{i.id} - #{i.name}"
        elsif i.hours.instance_of? Hours
          i_total += 1
          puts "--> OK: 1 HOURS record  for INSTITUTION: #{i.id.to_s.rjust(INSTITUTION_JUSTIFY)} - #{i.name}"
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
      puts "\n\n"
    end

    # Locations
    desc "Checks status of locations records"
    task :locations => [:environment, :setup_variables] do
      puts ["\n\n", LB, "Checking Locations", LB].join("\n")
      l_total = Location.all.length
      LOCATION_JUSTIFY = l_total.to_s.split('').length

      i_total = 0
      Institution.all.each do |i|
        if i.locations.nil?
          puts "FAILED: No LOCATION records for INSTITUTION: #{i.id} - #{i.name}"
        else
          count = i.locations.length
          i_total += count
          puts "--> OK: #{count.to_s.rjust(LOCATION_JUSTIFY)} LOCATION #{'record'.pluralize(count).ljust(7)} for INSTITUTION: #{i.id.to_s.rjust(INSTITUTION_JUSTIFY)} - #{i.name}"
        end
      end
      puts "\n"
      puts "INSTITUTIONS make up #{i_total} LOCATION #{'record'.pluralize(i_total)}"
      puts "In total there are #{l_total} LOCATION #{'record'.pluralize(l_total)}"
      puts "\n\n"
    end
  end
end
