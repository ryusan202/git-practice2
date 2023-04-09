class ChatsController < ApplicationController
 before_action :reject_non_related, only: [:show]

def show
  @user = User.find_by(id: params[:id])
  if @user
    rooms = current_user.user_rooms.pluck(:room_id)
    user_rooms = UserRoom.find_by(user_id: @user.id, room_id: rooms)

    if user_rooms.nil?
      @room = Room.new
      @room.save
      UserRoom.create(user_id: @user.id, room_id: @room.id)
      UserRoom.create(user_id: current_user.id, room_id: @room.id)
    else
      @room = user_rooms.room
    end

  @chats = @room.chats
  @chat = Chat.new(room_id: @room.id)
  end
end
 
  def index
   
    @users = User.all
    @user = User.new # 追加
  end

 def create
  
  @chat = Chat.new(chat_params)
  @chat.user_id = current_user.id
  if @chat.save
respond_to do |format|
  format.html { redirect_to chat_path(@chat.room) }
  format.json { render json: @chat }
    end
  else
  end
 end

 private
 
 def reject_non_related
    user = User.find(params[:id])
    unless current_user.following?(user) && user.following?(current_user)
      redirect_to books_path
    end
 end

 def chat_params
  params.require(:chat).permit(:message, :room_id)
 end

end