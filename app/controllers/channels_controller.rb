class ChannelsController < ApplicationController
  
  before_action :logged_in_user

  def new
    @channel = Channel.new
  end
  
  def create
    @channel = Channel.new(channel_params)
    @channel.users << current_user
    if @channel.save
      redirect_to @channel
    else
      render 'new'
    end
  end
  
  def show
    @channel = Channel.find(params[:id])
    @users = @channel.users
    if !@channel.public && !@users.find_by(:id => current_user.id)
      flash[:danger] = "You dont have the acces to this Channel"
      redirect_to current_user
    end
  end

  private
  
   def add_user_to_channel_params
     params.require(:channel).permit(:title, :public)
   end
   
   def channel_params
     params.require(:channel).permit(:title, :public)
   end
end
