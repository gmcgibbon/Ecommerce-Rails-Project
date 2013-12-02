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
add_game "Batman: Arkham Asylum", "Xbox 360"
add_game "Uncharted 2: Among Thieves", "Playstation 3"
add_game "Grand Theft Auto V", "Playstation 3"
add_game "Tomb Raider", "Xbox 360"
add_game "BioShock Infinite", "Playstation 3"
add_game "Batman Arkham Origins", "Playstation 3"
add_game "Splinter Cell: Blacklist", "Playstation 3"
add_game "Borderlands 2", "Xbox 360"
add_game "The Walking Dead", "Xbox 360"
add_game "Dark Souls", "Xbox 360"
add_game "Gears of War: Judgment", "Xbox 360"
add_game "Batman: Arkham City", "Xbox 360"
add_game "Final Fantasy XIII", "Playstation 3"

Province.create(:name => "Manitoba")
Province.create(:name => "Nova Scotia")
Province.create(:name => "British Columbia")
Province.create(:name => "Ontario")
Province.create(:name => "Quebec")
Province.create(:name => "Alberta")
Province.create(:name => "Newfoundland")
Province.create(:name => "Saskatchewan")
Province.create(:name => "New Brunswick")
Province.create(:name => "Prince Edward Island")

PaymentMethod.create(:name => "Credit Card")
PaymentMethod.create(:name => "PayPal")
PaymentMethod.create(:name => "Bitcoin")
PaymentMethod.create(:name => "Cheque")
PaymentMethod.create(:name => "Purchase Order")

Page.create(:title => "About Us", :content => "<p>Content</p>")
Page.create(:title => "Contact", :content => "<p>Content</p>")