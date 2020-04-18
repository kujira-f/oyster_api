class Tasks::Batch
  URIMain = 'http://api.gnavi.co.jp/RestSearchAPI/20150630/?'
  URIKey = 'keyid=xxxxxxxxxxxxxxxxxxxxxxxx'
  URICountForward = '&hit_per_page='
  URICount = '1'
  URIFormat = '&format=json'
  URIFreeword = '&freeword=%E7%89%A1%E8%A0%A3'
  URIOyster = URIMain + URIKey + URICountForward + URICount + URIFormat + URIFreeword
  def self.execute
    require 'net/http'
    require 'uri'
    require 'json'
    require 'date'
    db = SQLite3::Database.new("db/development.sqlite3")
    db.transaction do
      sql = "insert into restaurants(name,category,latitude,longitude,url,image_url,areaname,prefname,created_at,updated_at) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
      uri = URI.parse(URIOyster)
      json = Net::HTTP.get(uri)
      result = JSON.parse(json)
      
      
      total_hit_count = result['total_hit_count'].to_i
      p total_hit_count
      rest = result['rest']
      puts rest[0]
      for num in 0..URICount.to_i - 1 do
        name = rest[num]['name']
        category = rest[num]['category']
        latitude = rest[num]['latitude']
        longitude = rest[num]['longitude']
        url = rest[num]['url']
        image_url = rest[num]['image_url']['shop_image1']
        areaname = rest[num]['code']['areaname']
        prefname = rest[num]['code']['prefname']
        db.execute(sql, name, category, latitude, longitude, url, image_url, areaname, prefname,DateTime.now.to_s, DateTime.now.to_s)
      end
    end
    db.close
  end
end
