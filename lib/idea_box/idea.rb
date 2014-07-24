# require 'idea_box'
require 'time'

class Idea
  attr_reader :title, :description, :rank, :id, :tag, :created_at
  include Comparable

  def self.create(attributes)
    attributes['tag'] = format_tags(attributes['tag'])
    new(attributes)
  end

  def self.format_tags(tags)
    tags.to_s.split(',').map(&:strip)
  end

  def initialize(attributes)
    @title = attributes["title"]
    @description = attributes["description"]
    @rank = attributes["rank"] || 0
    @id = attributes["id"]
    @created_at = attributes["created_at"]
    @tag = attributes['tag'] || []
  end

  def to_h
    {
      "title" => title,
      "description" => description,
      "rank" => rank,
      "tag" => tag,
      "created_at" => Time.now.strftime('%a, %r')
    }
  end

  def like!
    @rank += 1
  end

  def <=>(other)
    other.rank <=> rank
  end
end
