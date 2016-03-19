#!/usr/bin/env ruby
# require 'pry-byebug'
require_relative './world'

raw_seed = File.read(ARGV[0])
seed_data = "#{raw_seed}".split("\n").map{ |row| row.split("")}


trap(:INT) do
  puts "\n Game of life ends"
  exit 0
end

World.new(seed_data).evolve
