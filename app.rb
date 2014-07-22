require './idea'

class IdeaBoxApp < Sinatra::Base
  get '/' do
    erb :index
  end

  post '/' do
    #create an idea
    idea = Idea.new
    #store the idea
    idea.save
    #return to index and show ideas
    "Creating an IDEA!"
  end

  not_found do
    erb :error
  end
end
