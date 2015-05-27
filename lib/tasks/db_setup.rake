namespace :db do
  namespace :setup do
    desc "Ensures every Institution has a filters object"
    task :filters => :environment do
      Institution.all.each do |i|
        if i.filter.nil?
          i.filter = Filter.create(institution_id: i.id)
          i.save
        end
      end
    end
  end
end

