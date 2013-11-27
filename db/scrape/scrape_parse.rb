@scraper = GameScraper.new

def add_game title, platform
  begin
    puts "Adding #{title} for #{platform}..."

    params  = {"cat_id"   => 11932, 
             "name"     => title, 
             "platform" => platform}
    game_hash = @scraper.get_game(params)

    # cap remote uri
    uri = game_hash[:box_art]

    # cap remote file
    file = open("#{title.pan}.jpg", 'wb') do |file|
      file << open(uri).read
    end
    # cap local tmp file
    tmp_file = File.open(File.join(Rails.root, "#{title.pan}.jpg"))

    # adjust values
    game_hash[:box_art] = tmp_file
    game_hash[:name] = title
    game_hash[:stock_quantity] = Random.rand(10 .. 65)
    #E10 fix
    if game_hash[:rating].include? "Everyone 10"
      game_hash[:rating] = "Everyone 10+"
    end

    # game obj
    game = Platform.where(name: platform).first.games.build(game_hash)

    if game.save
      puts "Added successfully!"
    else
      puts "Data could not be added to DB, does the game already exist?"
      throw # rejected by DB, invalid
    end
  rescue
    puts "Could not be added. :("
  end
  puts
end