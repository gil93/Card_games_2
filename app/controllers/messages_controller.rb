class MessagesController < ApplicationController
  def new
    @message = Message.new
  end

  def create
    @message = Message.create!(message_params)
    # PrivatePub.publish_to(room_path(@message.room.id), message: @message)
    PrivatePub.publish_to room_path(@message.room), { message: @message, user: @message.user }

      # jQuery('#new_message_text').val '' if @message.user.id == current_user.id
    redirect_to room_path(@message.room)
  end

  private
  def message_params
    params.require(:message).permit(:content, :user_id, :room_id)
  end
end
