class RoomsController < ApplicationController
  before_action require_user: [:index, :new, :create, :show, :destroy]
  def index
    @rooms = Room.all
    @rooms.each do |room|
      room.destroy if room.users.length < 1
    end
  end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_params)

    respond_to do |format|
      if @room.save
        current_user.update_columns(room_id: @room.id)
        Blackjack.create_deck(@room)

        format.html { redirect_to @room, notice: "Game Room created!" }
        format.json { render :show, location: @room }
      else
        format.html { render :new }
      end
    end
  end

  def show

    @room = Room.find(params[:id])

    @deck = @room.cards
    @hands = {}

    @hit = params[:hit]
    @stay = params[:stay]
    @restart = params[:restart]

    @ping = params[:ping]
    @disconnect = params[:disconnect]

    @current_user = current_user
    @room.users.each do |user|
      @current_user = user if current_user.id == user.id
    end

    if @room.users.length > 3
      current_user.update_columns(room_id: nil)
      @room.users.delete(current_user)
      redirect_to rooms_path, notice: "Sorry! Room is full!"
    else
      current_user.update_columns(room_id: @room.id)
    end

    if @ping == "true"

      if @room.users.length > 3
        current_user.update_columns(room_id: nil)
        @room.users.delete(current_user)
        redirect_to rooms_path, notice: "Sorry! Room is full!"
      else
        current_user.update_columns(room_id: @room.id)
      end

      if @disconnect == "true"
        Blackjack.user_quit(@room, current_user)
      else

        if @restart == "true"
          Blackjack.game_restart(@room)
          Blackjack.create_deck(@room)
          @room.users.each do |user|
            if user.cards.length < 2
              Blackjack.draw_card(@room, @deck, user, 2)
            end
          end
        end

        @room.users.each do |user|
          user.update_columns(dealer: false)
        end
        @room.users[-1].update_columns(dealer: true)
        current_user.update_columns(dealer: true) if @room.users[-1] == current_user

        if current_user.cards.length < 2
          Blackjack.draw_card(@room, @deck, current_user, 2)
        end

        if @hit == "true"
          Blackjack.draw_card(@room, @deck, current_user, 1)
        end

        if @stay == "true"
          current_user.update_columns(stay: true)
          @room.users.each do |user|
            user.update_columns(stay: true) if user == current_user
          end
        end

        @room.users.each do |user|
          @hands[user.id] = []
          user.cards.each do |card|
            @hands[user.id] << card
          end
        end

        @room.users.each do |user|
          Blackjack.calculate_hand(user)
          user.update_columns(bust: true) if Blackjack.player_bust?(user)
        end

        Blackjack.player_win?(@room)

        respond_to do |format|
          format.html
          format.js
          format.json {
            render json: {
              user: @current_user
            }
          }
        end
      end
      sleep 1
      PrivatePub.publish_to room_path, { users: @room.users, hands: @hands }
    end

  end

  def destroy
    @room = Room.find(params[:id])
    @room.users.each do |user|
      Blackjack.user_quit(@room, user)
    end
    @room.destroy
    redirect_to root_url
  end

  private
  def room_params
    params.require(:room).permit(:name)
  end
end
