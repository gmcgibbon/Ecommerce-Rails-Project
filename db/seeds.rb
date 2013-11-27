# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require "#{Rails.root}/db/scrape/semantics_game_scraper.rb"
require "#{Rails.root}/db/scrape/scrape_parse.rb"

Platform.create(name: "Wii U", manufacturer: "Nintendo", description: "Latest Nintendo Console")
Platform.create(name: "Xbox 360", manufacturer: "Microsoft", description: "Microsoft console released in 2005")
Platform.create(name: "Playstation 3", manufacturer: "Sony", description: "Sony console released in 2005")

add_game "Uncharted 3", "Playstation 3"
add_game "Gears of War 3", "Xbox 360"
add_game "Halo 3: ODST", "Xbox 360"
add_game "Nintendo Land", "Wii U"