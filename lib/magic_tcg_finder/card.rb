class Card

  attr_accessor :name, :rarity, :sets, :price, :rules_text, :flavor_text, :color, :cost, :purchase_url, :card_type, :combat_stats, :url

  @@all = []

  def initialize(attributes)
    attributes.each {|attribute, value| self.send(("#{attribute}="), value)}
    @@all << self
  end

  def self.all
    @@all
  end

  def self.destroy_all
    self.all.clear
  end

  def self.create_from_collection(card_arr)
    card_arr.each do |card|
      new_card = Card.new(card)
    end
  end

  def add_card_attributes(attribute_hash)
    attribute_hash.each {|attribute, value| self.send(("#{attribute}="), value)}
  end

end

