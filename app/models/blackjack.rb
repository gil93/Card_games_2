class Blackjack

  def self.create_deck(room)
    Card.all.each do |card|
      room.cards << card
    end
  end

  def self.calculate_hand(user)
    total_value = 0
    user.cards
    values = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "jack", "queen", "king", "ace"]
    user.cards.each do |card|
      values.each do |value|
        if card.value == value
          if ["jack", "queen", "king"].include?(card.value)
            total_value += 10
          elsif !["ace"].include?(card.value)
            total_value += card.value.to_i
          elsif ["ace"].include?(card.value)
            if total_value > 10
              total_value += 1
            elsif total_value < 10
              total_value += 11
            end
          end
        end
      end
    end
    user.update_columns(score: total_value)
  end

  def self.draw_card(game, deck, user, n)
    cards = []
    n.times do
      card = deck.sample
      cards << card if !cards.include? card
    end
    cards.each do |c|
      user.cards << c
    end
  end

  def self.game_restart(room)
    room.users.each do |user|
      user.cards.clear
      user.update_columns(score: 0, stay: false, bust: false, win: false, dealer: false)
    end
    room.cards.clear
    User.where(room_id: room.id).each do |player|
      player.update_columns(score: 0, stay: false, bust: false, win: false, dealer: false)
    end
  end

  def self.user_quit(room, user)
    user.update_columns(score: 0, stay: false, bust: false, win: false, dealer: false, room_id: nil)
    user.cards.clear
    room.users.delete(user)
  end

  def self.player_bust?(user)
    user.score > 21
  end

  def self.player_win?(room)
    game_over = 0
    room.users.each do |user|
      if user.bust == true || user.stay == true
        game_over += 1
      end
    end
    if game_over == room.users.length
      winners = []
      room.users.each do |user|
        winners << user if user.score < 22
      end
      if winners.length > 0 && room.users.length > 1
        winner = winners.sort_by {|winner| winner.score }.last
        winner_save = User.find_by_id(winner.id)
        former_wins = winner_save.wins
        former_wins += 1
        winner_save.update_columns(win: true, wins: former_wins)
        room.users.each do |player|
          player.update_columns(win: true) if player == winner
        end
      end
    end
    return nil
  end

  def self.stay
    user.stay = true
  end

end
