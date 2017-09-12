class Scraper

  SEARCH_URL = "https://scryfall.com/search?q="
  SITE_URL = "https://scryfall.com"

  attr_accessor :query

  def initialize(query)
  	@query = query
  end

  def scrape_search_page(url = nil)
  	url =  self.input_parser if url.nil?
    begin 
  	 card_index = Nokogiri::HTML(open(url))
    rescue
      puts "No cards found"
      return []
    end

  	cards = card_index.css('a.card-grid-item')
  	if cards.empty?
  		[{name: 'placeholder', url: url}]
  	else
  		card_collection = []
  		cards.each do |card|
  			card_hash = {}
  			card_hash[:name] = card.css('img.card').attr('alt').text.gsub(/\s\(...\)/, "")
  			card_hash[:url] = SITE_URL + card['href']
  			card_collection << card_hash
  		end
      if card_index.css("a.button-primary.js-paginate-forward").any?
        #looks for more pages
        new_url = SITE_URL + card_index.css("a.button-primary.js-paginate-forward").attr('href').text
        card_collection << scrape_search_page(new_url)
        #Recurses if it finds more pages
        card_collection.flatten
      else
        card_collection
      end
  	end

  end

  def input_parser
  	input = self.query.downcase.split.collect{|string|string.scan(/[a-z]/)}
  	input = input.collect {|arr|arr.join("")}.join('+')
  	SEARCH_URL + input
  end

  def self.color_finder(cost)
    colors = {'{W}' =>'White'.colorize(:light_yellow),'{U}' => 'Blue'.colorize(:light_cyan),'{B}' => 'Black'.colorize(:magenta),'{R}' => 'Red'.colorize(:red),'{G}' => 'Green'.colorize(:green)}
    matches = 0
    color_identity = "Colorless".colorize(:light_black)
    #Not all cards have a casting cost
    return color_identity if cost.nil?

    colors.each do |symbol, value|
      if cost.include?(symbol)
        matches += 1
        color_identity = value
      end
    end


    if matches > 1
      "Multicolor".colorize(:yellow)
    else
      color_identity
    end
  end


  def self.scrape_card_page(profile_url)
    card_hash = {}
    card_profile = Nokogiri::HTML(open(profile_url))
    title_text = card_profile.css('h1.card-text-title').text.strip.gsub(/\n/, '||').split("||")
    card_hash[:name] = title_text.first
    #Not all cards have a casting cost, such as a land... .gsub on nil makes ruby sad.
    card_hash[:cost] = title_text[1].gsub(/\s/,"") unless title_text[1] == nil
    card_hash[:rarity] = card_profile.css('span.prints-current-set-details').text.strip.split(', ')[1]
    card_hash[:sets] = card_profile.css('tbody tr').collect {|element|element.css('td').text.strip[/^.*(?=(\n))/]}.delete_if{|element|element.nil?}
    card_hash[:price] = card_profile.css('span.price.currency-usd').text.split('$')[1]
    card_hash[:color] = self.color_finder(card_hash[:cost])
    card_hash[:purchase_url] = card_profile.css('#stores > ul > li:nth-child(1) > a').attr('href').text
    card_hash[:card_type] = card_profile.css('p.card-text-type-line').text.strip
    card_hash[:combat_stats] = card_profile.css('div.card-text-stats').text.strip
    card_hash[:rules_text] = card_profile.css('div.card-text-oracle').text.strip
    card_hash[:flavor_text] = card_profile.css('div.card-text-flavor').text.strip
    card_hash.delete_if {|key, value| value == "" || value == nil}
    card_hash
  end

end

