=begin
FLOW OF GAME
1. Initialize deck
2. Deal cards to player and dealer
3. Player turn: hit or stay
  - repeat until bust or "stay"
4. If player bust, dealer wins.
5. Dealer turn: hit or stay
  - repeat until total >= 17
6. If dealer bust, player wins.
7. Compare cards and declare winner.
=end

SUITS = ['H', 'C', 'S', 'D']
CARDS = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
POINT_LIMIT = 21

def prompt(msg)
  puts "=> #{msg}"
end

def initialize_deck
  SUITS.product(CARDS).shuffle
end

def play_again?
  prompt "Would you like to play again? Enter 'y' if yes, 'n' if no."
  answer = gets.chomp.downcase[0]
  if answer == 'y'
    true
  elsif answer == 'n'
    false
  else
    prompt "Incorrect answer. Please enter 'y' or 'n'."
  end
end

def total(cards)
  # cards = [['H', '3'], ['S', 'Q'], ... ]
  values = cards.map { |card| card[1] }

  sum = 0
  values.each do |value|
    if value == "A"
      sum += 11
    elsif value.to_i == 0 # J, Q, K
      sum += 10
    else
      sum += value.to_i
    end
  end

  # correct for Aces
  values.select { |value| value == "A" }.count.times do
    sum -= 10 if sum > 21
  end

  sum
end

def busted?(cards)
  total(cards) > POINT_LIMIT
end

def press_lowercase_to_continue
  prompt "Press any key and hit enter to proceed."
  answer = gets.chomp[0]
  system 'clear'
end

def calculate_winner(plr_hand, dealr_hand)
  if total(plr_hand) > total(dealr_hand)
    "Player"
  elsif total(plr_hand) < total(dealr_hand)
    "Dealer"
  else
    "Tie"
  end
end

def output_winner(plr_hand, dealr_hand)
  if calculate_winner(plr_hand, dealr_hand) == "Player"
    prompt "Player has won."
  elsif calculate_winner(plr_hand, dealr_hand) == "Dealer"
    prompt "The Dealer has won."
  else
    prompt "We have a tie!"
  end
end

def display_final_score(plr_hand, dealr_hand)
  prompt "The final score was:"
  prompt "--> Player: #{total(plr_hand)}, Dealer: #{total(dealr_hand)}."
end

# GAME START
loop do
  system 'clear'
  deck = initialize_deck

  player_cards = []
  dealer_cards = []

  prompt "Welcome to TwentyOne. Think of it like Blackjack without the frills."
  prompt "Let's Start!"

  # Initialize deck
  2.times do
    player_cards << deck.delete(deck.sample)
    dealer_cards << deck.delete(deck.sample)
  end
  # Player Turn
  answer = nil
  loop do
    prompt "Your current hand is #{player_cards}."
    prompt "The dealer's open card is #{dealer_cards[0]}"
    prompt "Please indicate whether you would like to hit or stay."
    prompt "Press 'h' to hit, 's' to stay."
    answer = gets.chomp.downcase[0]
    system 'clear'
    break if answer == 's' || busted?(player_cards)

    if answer == 'h' # commencing 'hit'
      player_cards << deck.delete(deck.sample)
      prompt "You chose to hit!"
    else
      prompt "Please enter either 'h' or 's'"
    end
  end

  if busted?(player_cards)
    prompt "You have busted. Dealer has won."
    display_final_score(player_cards, dealer_cards)
    break unless play_again?
    next
  else
    prompt "You chose to stay!"
  end

  press_lowercase_to_continue
  

  # Dealer Turn
  prompt "Now it is the dealer's turn."

  loop do
    break if total(dealer_cards) >= 17 || busted?(dealer_cards)
    dealer_cards << deck.delete(deck.sample)
    prompt "The dealer chose to 'hit'."
  end

  if busted?(dealer_cards)
    prompt "The dealer has busted. You have won"
    display_final_score(player_cards, dealer_cards)
    break unless play_again?
    next
  else
    prompt "The dealer chose to stay!"
  end

  # Calculating and outputting who wins.

  press_lowercase_to_continue

  calculate_winner(player_cards, dealer_cards)
  output_winner(player_cards, dealer_cards)
  display_final_score(player_cards, dealer_cards)

  break unless play_again?
end
