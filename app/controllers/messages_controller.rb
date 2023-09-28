class MessagesController < ApplicationController
  def create
    @new_message = current_user&.messages&.build(message_params)

    if @new_message&.save
      room = @new_message.room

      @new_message.broadcast_append_to(
        room,
        target: "room-#{room.id}-messages", locals: { user: current_user }
      )
    end
  end

  def like
    @message = Message.find(params[:id])
    like = @message.likes.find_by(user: current_user)

    if like.present?
      like.destroy
    else
      @message.likes.create(user: current_user)
    end

    @message.broadcast_replace_to(
      [current_user, @message.room],
      target: "message-#{@message.id}-likes",
      locals: { user: current_user, message: @message },
      partial: "messages/heart"
    )

    @message.broadcast_replace_to(
      @message.room,
      target: "message-#{@message.id}-likes-count",
      locals: { user: current_user, message: @message },
      partial: "messages/likes_count"
    )
  end

  private

  def message_params
    params.require(:message).permit(:body, :room_id)
  end
end
