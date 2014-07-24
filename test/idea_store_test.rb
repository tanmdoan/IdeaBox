gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/idea_box/idea'
require './lib/idea_box/idea_store'



class IdeaStoreTest < Minitest::Test
  # def teardown
  #   IdeaStore.delete_all
  # end

  def test_idea_exist
    idea = Idea.new({
      'id'           => 1,
      'title'        => "colors",
      'description'  => "bright ones",
      'tags'         => ["yellow", "green", "blue"]
      })

      assert_kind_of Idea, idea
  end

  def test_can_find_all_tags
    idea = Idea.new({
      'id'           => 1,
      'title'        => "colors",
      'description'  => "bright ones",
      'tags'         => ["yellow", "green", "blue"]
      })

    idea2 = Idea.new({
      'id'           => 2,
      'title'        => "animals",
      'description'  => "pets",
      'tags'         => ["dog", "cat", "sheep"]
      })

    all_tags = IdeaStore.tags
    assert_equal 6, all_tags.count
  end

end
