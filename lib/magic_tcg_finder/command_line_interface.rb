class CommandLine

	
	def clear_screen
		print %x{clear}
	end

	def start_screen
		clear_screen
		puts "		    _            _____ _              ___      _   _               _             ".colorize(:light_green)
		puts "  /\\/\\   __ _  __ _(_) ___   _  /__   \\ |__   ___    / _ \\__ _| |_| |__   ___ _ __(_)_ __   __ _ ".colorize(:light_green)
		puts " /    \\ / _` |/ _` | |/ __| (_)   / /\\/ '_ \\ / _ \\  / /_\\/ _` | __| '_ \\ / _ \\ '__| | '_ \\ / _` |".colorize(:light_green)
		puts "/ /\\/\\ \\ (_| | (_| | | (__   _   / /  | | | |  __/ / /_\\\\ (_| | |_| | | |  __/ |  | | | | | (_| |".colorize(:light_green)
		puts "\\/    \\/\\__,_|\\__, |_|\\___| (_)  \\/   |_| |_|\\___| \\____/\\__,_|\\__|_| |_|\\___|_|  |_|_| |_|\\__, |".colorize(:light_green)
		puts "              |___/                                                                        |___/ ".colorize(:light_green)
		puts "                    ___              _     ___ _           _                                     ".colorize(:light_green)
		puts "                   / __\\__ _ _ __ __| |   / __(_)_ __   __| | ___ _ __                           ".colorize(:light_green)
		puts "                  / /  / _` | '__/ _` |  / _\\ | | '_ \\ / _` |/ _ \\ '__|                          ".colorize(:light_green)
		puts "                 / /__| (_| | | | (_| | / /   | | | | | (_| |  __/ |                             ".colorize(:light_green)
		puts "                 \\____/\\__,_|_|  \\__,_| \\/    |_|_| |_|\\__,_|\\___|_|                             ".colorize(:light_green)
	  
	  puts ""                             

	  	run
	end

	def get_query
		puts "Please enter the name of a card you want to find"
		gets.strip
	end

	def call_scraper(input)
		new_search = Scraper.new(input)
		new_search.scrape_search_page
	end

	def load_attributes(card)
		card_hash = Scraper.scrape_card_page(card.url)
		card.add_card_attributes(card_hash)
	end

	def create_cards(card_arr)
		Card.create_from_collection(card_arr)
	end

	def list_cards
		clear_screen
		Card.all.each_with_index do |card, index|
			puts "#{index + 1}.#{card.name}" 
		end
	end

	def access_list
		max = Card.all.size
		puts "Please make a selection"
		input = gets.strip.to_i
		if input < 0 || input > max
			puts "Invalid selection"
			card_menu
		end
		input
	end

	def colorize_cost(cost)
		return cost if cost.nil?
		cost = cost.gsub(/\{W\}/) { |match| match.colorize(:light_yellow) }
		cost = cost.gsub(/\{U\}/) { |match| match.colorize(:light_cyan) }
		cost = cost.gsub(/\{B\}/) { |match| match.colorize(:magenta) }
		cost = cost.gsub(/\{R\}/) { |match| match.colorize(:red) }
		cost = cost.gsub(/\{G\}/) { |match| match.colorize(:green) }
		cost = cost.gsub(/\{T\}/) { |match| match.colorize(:light_black) }
		cost = cost.gsub(/\{\d\}/) { |match| match.colorize(:light_black) }
	end

	def load_card(input)
		chosen_card = Card.all[input - 1]
		load_attributes(chosen_card) if chosen_card.rules_text.nil?
		puts "#{chosen_card.name} - #{colorize_cost(chosen_card.cost)}"
		puts ""
		puts "Color Identity: #{chosen_card.color}"
		puts "Type: #{chosen_card.card_type}"
		puts "Rarity: #{chosen_card.rarity}"
		puts ""
		puts "#{colorize_cost(chosen_card.rules_text)}"
		puts "#{chosen_card.flavor_text}"
		puts "#{chosen_card.combat_stats}"
		puts ""
		puts "Appears in the following set(s): #{chosen_card.sets.join(', ')}" 
		puts ""
		puts "Average price: $#{chosen_card.price}" unless chosen_card.price.nil? 
		puts "Purchase at #{chosen_card.purchase_url}"
		puts ""
	end

	def card_menu
		if Card.all.size == 1
			clear_screen
			load_card(1)
			interaction
		else
			list_cards
			input = access_list
			clear_screen
			load_card(input)
			interaction
		end

	end

	def interaction
		puts "Please make a selection"
		puts "1. Return to card list"
		puts "2. New search"
		puts "3. Exit"
		input = gets.strip.downcase
		case input
		when "1"
			card_menu
		when "2"
			clear_screen
			run 
		when "3"
			clear_screen
			exit
		else
			puts "Invalid selection"
			interaction
		end
			
	end

	def try_again
			puts ""
			puts "Please make a selection:"
			puts "1. Search for a new card"
			puts "2. Exit this program"
			input = gets.strip

			case input
			when "1"
				clear_screen
				run
			when "2"
				clear_screen
				exit
			else
				"Please enter a valid selection"
				try_again
			end
	end

	def run
		Card.destroy_all
		query = get_query
		clear_screen
		card_arr = call_scraper(query)
		if card_arr == []
			try_again
		end
		create_cards(card_arr)
		card_menu
		interaction
	end


end
