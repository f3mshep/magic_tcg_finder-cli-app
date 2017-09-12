require "spec_helper"

describe "Scraper" do

  describe ".new" do
    it "takes in the query of the desired card as an argument and instantiates the object" do
      expect{Scraper.new("Merfolk Looter")}.to_not raise_error
    end
  end

  describe "#query" do
    it "Gets and sets the query attribute" do
      Card.instance_methods.include? :query
      Card.instance_methods.include? :query=
    end 
  end

  describe "#input_parser" do
    it "returns a correctly formatted search URL" do
       card = Scraper.new("Gaea's Cradle")
      (card.input_parser).should include("https://scryfall.com/search?q=gaeas+cradle")
    end
  end

  describe "#scrape_search_page" do
    it " returns an array with a  hash with the card name and URL as keys with their appropriate values" do 
      card = Scraper.new("Merfolk")
      card_array = card.scrape_search_page
      expect(card_array).to be_an_instance_of(Array)
      card_array.should include({name: "Arctic Merfolk", url: 'https://scryfall.com/card/pls/21'})
    end
    
  end

  describe ".scrape_card_page" do
    it "accepts the URL of a card page as a parameter" do
      card = Scraper.new("Merfolk Looter")
      expect{Scraper.scrape_card_page("https://scryfall.com/card/cn2/114")}.to_not raise_error
    end
    it "is a method that scrapes the card page from TCG player and returns a hash with the rules, flavor text, cost,  ect." do
      card = Scraper.new("Merfolk Looter")
      (Scraper.scrape_card_page("https://scryfall.com/card/cn2/114")).should include(rules_text: "{T}: Draw a card, then discard a card.", name: "Merfolk Looter", color: "Blue")
    end
  end

end
