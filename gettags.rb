#!/usr/bin/env ruby

require 'rubygems'

dest_directory='.git'

dest_commit = ENV['INN_Version_select'] unless ENV['INN_Version_select'].nil?

dest_commit = ARGV[1] unless ARGV[1].nil?
dest_directory = ARGV[0] unless ARGV[0].nil?

#
# Setting GIT_DIR to make git comamnds work
ENV['GIT_DIR'] = dest_directory

puts "Destination Git repository #{dest_directory}"
puts "Destination Tag #{dest_commit}"

puts "List of existing tags "+`git tag -l`
