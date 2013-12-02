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

Province.create(:name => "Manitoba", :gst => 0.05, :pst => 0.08)
Province.create(:name => "Nova Scotia", :hst => 0.15)
Province.create(:name => "British Columbia", :gst => 0.05, :pst => 0.07)
Province.create(:name => "Ontario", :gst => 0.05, :pst => 0.08)
Province.create(:name => "Quebec", :gst => 0.05, :pst => 0.0975)
Province.create(:name => "Alberta", :gst => 0.05)
Province.create(:name => "Newfoundland", :hst => 0.13)
Province.create(:name => "Saskatchewan", :gst => 0.05, :pst => 0.05)
Province.create(:name => "New Brunswick", :hst => 0.13)
Province.create(:name => "Prince Edward Island", :gst => 0.05, :pst => 0.09)

PaymentMethod.create(:name => "Credit Card")
PaymentMethod.create(:name => "PayPal")
PaymentMethod.create(:name => "Bitcoin")
PaymentMethod.create(:name => "Cheque")
PaymentMethod.create(:name => "Purchase Order")

Page.create(:title => "About Us", :content => "<p>Content</p>")
Page.create(:title => "Contact", :content => "<p>Content</p>")