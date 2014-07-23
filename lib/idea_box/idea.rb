require 'idea_box'

class Idea
  attr_reader :title, :description, :rank, :id, :tag
  include Comparable

  def initialize(attributes)
    @title = attributes["title"]
    @description = attributes["description"]
    @rank = attributes["rank"] || 0
    @id = attributes["id"]
    @tag = format_tag(attributes["tag"])
  end

  def format_tag(tags)
    tags.to_s.split(/\s*,\s*/)
  end

  def save
    IdeaStore.create(to_h)
  end


  def to_h
    {
      "title" => title,
      "description" => description,
      "rank" => rank,
      "tag" => tag
    }
  end

  def like!
    @rank += 1
  end

  def <=>(other)
    other.rank <=> rank
  end
end
