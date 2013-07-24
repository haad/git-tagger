#!/usr/bin/env ruby

require 'rubygems'

class Gitter
  attr_reader :parent_tag
  attr_reader :psha1

  def initialize
    @all_tags
    @parent_tag
    @psha1
  end

  def sort_tags(dest_commit)
    @all_tags = `git tag`.split("\n").select{|t| t =~ /\A(\d+)\.(\d+)\.(\d+)\Z/}
    @all_tags <<  dest_commit
    @all_tags.sort! do |a,b|
      # 1.5.2 < 1.5.11 !!!
      a1 = a.sub('.', '*1000+').sub('.', '*100+').sub('.', '*10+')
      b1 = b.sub('.', '*1000+').sub('.', '*100+').sub('.', '*10+')
      eval(a1) <=> eval(b1)
    end
  end

  def get_parent_sha(dest_commit)
    if @all_tags.last == dest_commit
      @parent_tag = "HEAD"
      @psha1 = "HEAD"
    else
      @parent_tag = @all_tags[@all_tags.index(dest_commit)-1]
      @psha1 = `git rev-list -n1 #{@parent_tag}`
    end
  end
end

dest_directory='.git'
dest_commit = ENV['INN_Version_select'] unless ENV['INN_Version_select'].nil?

dest_commit = ARGV[1] unless ARGV[1].nil?
dest_directory = ARGV[0] unless ARGV[0].nil?

#
# Setting GIT_DIR to make git comamnds work
ENV['GIT_DIR'] = dest_directory

g = Gitter.new
g.sort_tags(dest_commit)
g.get_parent_sha(dest_commit)

puts "Destination Git repository #{dest_directory}"
puts "Destination Tag #{dest_commit}"
puts "List of existing tags "+`git tag -l`
puts "-------------------------"

puts "Parent commit tag is "+g.parent_tag
puts "Parent SHA1 is #{g.psha1}"

puts "git tag #{dest_commit} #{g.psha1}"
