class TopicsController < ApplicationController
  def index
    @topics = Topic.visible_to(current_user).paginate(page: params[:page], per_page: 10)
  end

  def new
    @topic = Topic.new
    authorize! :create, @topic, message: "You need to be an admin to do that."
  end

  def show
    @topic = Topic.find(params[:id])
    authorize! :read, @topic, message: "You need to be signed-in to do that."

    @posts = @topic.posts.paginate(page: params[:page], per_page: 10)
    end

  def edit
    @topic = Topic.find(params[:id])
    authorize! :update, @topic, message: "You need to have created that topic in order to edit it"
  end

  def create
    @topic = Topic.new(params[:topic])
    !authorize! :create, @topic, message: "You need to be a member to create a new topic."
    if @topic.save
    redirect_to @topic, notice: "Topic was saved successfully."
    else
      flash[:error] = "There was an error saving the topic. Please try again."
      render :new
    end
  end

  def update
    @topic = Topic.find(params[:id])
    authorize! :update, @topic, message: "You need to own the topic to edit it."
    if @topic.update_attributes(params[:topic])
      redirect_to @topic, notice: "Topic was updated successfully."
    else
      flash[:error] = "There was an error updating the topic. Please try again."
      render :edit
    end
  end

  def destroy
    @topic = Topic.find(params[:id])
    name = @topic.name
    authorize! :destroy, @topic, message: "You need to own the topic to delete it."
    if @topic.destroy
      flash[:notice] = "\"#{name}\" was deleted successfully."
      redirect_to topics_path
    else
      flash[:error] = "There was an error deleting the topic."
      render :show
    end  
  end
end