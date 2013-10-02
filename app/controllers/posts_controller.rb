class PostsController < ApplicationController
  def index
    @posts = Post.all #returns an array of Post objects
  end

  def show
    @post = Post.find(params[:id]) #params hash variable that is populated with given argument
  end

  def new
  end

  def edit
  end
end
