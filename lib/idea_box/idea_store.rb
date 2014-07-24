require 'yaml/store'
require './lib/idea_box'

class IdeaStore
  def self.all
    ideas = []
    raw_ideas.each_with_index do |data, i|
      ideas << Idea.new(data.merge("id" => i))
    end
    ideas
  end

  def self.tags
    tags = all.collect(&:tag)
    tags.flatten.uniq!.sort
  end

  def self.search(phrase)
    formatted_phrase = phrase.downcase
    all.find_all do |idea|
      idea.description.match(formatted_phrase) || idea.title.match(formatted_phrase) ||
      idea.tag.join(",").match(formatted_phrase)
    end
    # binding.pry
  end

  def self.all_by_tags
    ideas = {}
    tags.each { |tag| ideas[tag] = find_by_tag(tag) }.flatten
    ideas
  end

  def self.find_by_tag(tag)
    all.find_all { |idea| idea.tag.include?(tag) }.flatten
  end

  def self.raw_ideas
    database.transaction do |db|
      db['ideas'] || []
    end
  end

  def self.find_raw_ideas(id)
    database.transaction do
      database['ideas'].at(id)
    end
  end


  def self.delete(position)
    database.transaction do
      database['ideas'].delete_at(position)
    end
  end

  def self.delete_all
    database.transaction do
      database['ideas'] = []
    end
  end

  def self.find(id)
    raw_idea = find_raw_ideas(id)
    Idea.new(raw_idea.merge("id" => id))
  end

  def self.update(id, data)
    database.transaction do
      database['ideas'][id] = database['ideas'][id].merge(data)
    end
  end

  def self.database
    return @database if @database
    @database = YAML::Store.new("db/ideabox")
    @database.transaction do
      @database['ideas'] ||= []
    end
    @database
  end

  def self.create(attributes)
    idea = Idea.create(attributes)
    database.transaction do
      database['ideas'] << idea.to_h
    end
  end
end
