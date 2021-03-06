require 'idea_box'

class IdeaBoxApp < Sinatra::Base
  set :method_override, true
  set :root, 'lib/app'

  not_found do
    erb :error
  end

  get '/' do
    erb :index, locals: {ideas: IdeaStore.all.sort}
  end

  post '/' do
    IdeaStore.create(params[:idea])
    redirect '/'
  end

  get '/search' do
    erb :search, locals: {ideas: IdeaStore.search(params[:search])}
  end

  get '/filter' do
    erb :filter, locals: {ideas: IdeaStore.filter_by(params[:filter])}
  end

  get '/:tags/tag' do |tag|
    erb :tags, locals: {ideas: IdeaStore.find_by_tag(tag)}
  end

  delete '/:id' do |id|
    IdeaStore.delete(id.to_i)
    redirect '/'
  end

  put '/:id' do |id|
    IdeaStore.update(id.to_i, params[:idea])
    redirect '/'
  end

  get '/:id/edit' do |id|
    idea = IdeaStore.find(id.to_i)
    erb :edit, locals: {idea: idea}
  end

  post '/:id/like' do |id|
    idea = IdeaStore.find(id.to_i)
    idea.like!
    IdeaStore.update(id.to_i, idea.to_h)
    redirect '/'
  end
end
