class MessagesForChannelController < ApplicationController
    before_action :logged_in_user

  def show
    
    channel_id = params[:id]
    @channel = Channel.find(channel_id)
    @channels_for_user = current_user.channels
    @users_for_channel = @channel.users
    if user_has_access_to_channel(@channel, @channels_for_user)
      mock_channel_id = "c#" + channel_id
      @messages = Message.where(:reciever_id => mock_channel_id)
    else
      flash[:danger] = "You don't have access to the private channel"
      redirect_to current_user
    end
  end
  
  def create
    
    channel_id = params[:reciever_id]
    @channel = Channel.find(channel_id)
    @channels_for_user = current_user.channels
    if user_has_access_to_channel(@channel, @channels_for_user)
      mock_channel_id = "c#" + channel_id
      message = Message.new
      message.reciever_id = mock_channel_id
      message.sender_id = params[:sender_id]
      message.content = params[:message][:content]
      message.save
    else
      flash[:danger] = "You don't have access to the private channel"
      redirect_to current_user
    end

    
    redirect_to messages_for_channel_path(:id => channel_id)
  end
  
  private
    def user_has_access_to_channel(channel, channels_for_user)
      if channel.public || channels_for_user.find_by(:id => channel.id)
        return 1
      else
        return 0
      end
    end
end
