class Townhall
  attr_accessor :page, :name_uri_hash, :name_email_uri, :uri

  def initialize(uri)
    @uri = uri
    @page = readPage(uri)
  end

  def readPage(uri)
    #Read the page
    page = Nokogiri::HTML(open(uri))
    return page
  end

  def get_townhall_urls
    #return all uri of townhall by department
    uri_townhall = @page.xpath('//a[@class="lientxt"]/@href')
    name_townhall = @page.xpath('//a[@class="lientxt"]/text()')

    @name_uri_hash = {}
    i = 0

    #create full uri
    uri = @uri.split('/')
    uri = uri[0..-2].join('/')

    uri_townhall.each do |value|
      value = uri + (value.to_s)[1..-1]
      #add to hash the uri
      @name_uri_hash[(name_townhall[i]).to_s] = value
      i += 1
    end
  end

  def loop_each_town
    array = []
    hash = {}
    @name_email_uri = []
    @name_uri_hash.each do |key, value|
      puts 'Traitement de : ' + key
      page = readPage(value)
      email = get_townhall_email(page)
      #add to array the hash of {townhall => email}
      @name_email_uri << {key => email.to_s}
    end
  end

  def get_townhall_email(town_page)
    #return email data from the web page of townhall
    begin
      email = town_page.xpath('//table/tbody/tr[4]/td[2]/text()').first
    rescue => exception
      puts "Erreur lors de la récupération de l'adresse email"
    end
    return email
  end

  def to_s
    @name_email_uri.each do |value|
      value.each do |name, email|
        puts "------------------------------------------------------------"
        puts "- > Maire de la ville de #{name}"
        puts "************************************************************"
        puts "- > Ville : #{name}"
        puts "- > Email : #{email}"
        puts "------------------------------------------------------------"
      end
    end
  end

  def save_as_JSON
    hash = {}
    file = File.open("db/towns.json", "w")
    @name_email_uri.each do |value|
      value.each do |name, email|
        hash[name] = email
      end
    end
    file.write(hash.to_json)
    file.close
  end

  def save_as_csv
    CSV.open("db/towns.csv", "w") do |csv|
      @name_email_uri.each do |value|
        value.each do |name, email|
          csv << [name, email]
        end
      end
    end
  end
end