# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "magic_tcg_finder/version"

Gem::Specification.new do |spec|
  spec.name          = "magic_tcg_finder"
  spec.version       = MagicTcgFinder::VERSION
  spec.authors       = ["Alexandra Wright"]
  spec.email         = ["superbiscuit@gmail.com"]

  spec.summary       = "Magic: The Gathering card finder"
  spec.description   = " Scrapes data from Scryfall.com to search for and display info about MTG cards"
  spec.homepage      = "https://github.com/f3mshep/magic_tcg_finder-cli-app"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against " \
  #     "public gem pushes."
  # end

  # spec.files         = `git ls-files -z`.split("\x0").reject do |f|
  #   f.match(%r{^(test|spec|features)/})
  # end
  # spec.bindir        = "exe"
  spec.executables   = 'magic_tcg_finder'
  spec.require_paths = ["lib", "config"]
  spec.files = ["config/environment.rb","lib/magic_tcg_finder/command_line_interface.rb", "lib/magic_tcg_finder/card.rb","lib/magic_tcg_finder/scraper.rb" ]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "nokogiri", ">= 0"
  spec.add_development_dependency "pry", ">= 0"
  spec.add_development_dependency "colorize", ">= 0"
end
