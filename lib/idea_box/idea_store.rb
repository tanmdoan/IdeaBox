require 'yaml/store'
require 'idea_box'

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
    found = all.find_all { |idea| idea.description.match(phrase) || idea.title.match(phrase) }
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
