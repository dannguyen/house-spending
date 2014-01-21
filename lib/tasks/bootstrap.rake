require 'csv'
namespace :bootstrap do
  namespace :expenditures do
    desc "download the CSV files from Sunlight's site"
    task :download => :environment do
      url = 'http://sunlightfoundation.com/tools/expenditures/'
      db_dir = Rails.root.join 'db/data-hold/house-spending/'
      db_dir.mkpath

      Nokogiri::HTML(open(url)).css('.span12.content ul li a:contains("Detail")').each do |a|
        href = a['href']
        fname = db_dir.join(File.basename(href)).to_s
        puts "\nDownloading \t#{href} \n\tto:\n\t #{fname}"

        open(fname, 'wb'){|f| f.write(open(href).read) }
      end
    end

    desc 'loads into existing expenditures database'
    task :load => :environment do |t, args|

      CSV::Converters[:mytime] = lambda{|s|
        if s =~ /\d{2}\/\d{2}\/\d{2}/ 
          Chronic.parse(s)
        else
          s
        end      
      }

      csvs = Dir.glob Rails.root.join 'db/data-hold/house-spending/*.csv'
      csvs.each do |csv_name|
        puts "Reading #{csv_name}"
        arr = []

        CSV.open(csv_name, headers: true, converters: [:mytime], header_converters: ->(h){h.parameterize.underscore}  ).each_with_index do |row, idx|
          arr << Expenditure.new(row.to_hash)
          if idx % 1000 == 0
            puts "\t #{idx} rows loaded"
            Expenditure.import arr
            arr = []
          end          
        end
        # load last rows
        Expenditure.import arr
      end
    end
  end


  namespace :members do
  # saves new members from the datahold
    task :load => :environment do
      Member.delete_all

      list = YAML.load(open SunlightMemberImport::CURRENT_CONGRESS_DATA_HOLD + '-current.yaml')
      list += YAML.load(open SunlightMemberImport::CURRENT_CONGRESS_DATA_HOLD + '-historical.yaml')
      list.each do |o|
        member = Member.build_from_sunlight_object(o)
        puts member.full_name
        # do a first save
        member.save
        member.sync_and_save        
      end

      # delete unneeded members
      Member.senators.destroy_all
      Member.where('term_end_date < ?', Time.new(2009)).destroy_all
    end


  end
end