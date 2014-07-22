require './idea_store'

class Idea
  attr_reader :title, :description

  def initialize(attributes)
    @title = attributes["title"]
    @description = attributes["description"]
  end

  # def save
  #   database.transaction do |db|
  #     db['ideas'] ||= []
  #     db['ideas'] << {"title" => title, "description" => description}
  #   end
  # end
  #
  # def database
  #   IdeaStore.database
  # end
end
