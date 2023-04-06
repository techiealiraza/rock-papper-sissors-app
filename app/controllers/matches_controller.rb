class MatchesController < ApplicationController
  before_action :set_match, only: %i[show edit update destroy]
  ROCK = 'rock'
  PAPER = 'paper'
  SCISSOR = 'scissor'
  # GET /matches or /matches.json
  def index
    tournament = Tournament.find(params[:tournament_id])
    @matches = []
    @matches = tournament.matches.page(params[:page])
  end

  def matches_index
    match = Match.find(params[:match_id])
    @players = match.users
  end

  # GET /matches/1 or /matches/1.json
  def show
    @match = Match.find(params[:id])
    @usermatches = @match.users
  end

  # GET /matches/new
  def new
    @match = Match.new
  end

  # GET /matches/1/edit
  def edit; end

  # def generate_matches
  #   tournaments = Tournament.all
  #   matches = []
  #   tournaments.each do |tournament|
  #     tournament.registration_deadline < Time.now.getlocal
  #     tournament = Tournament.find(tournament_id)
  #     registered_users = tournament.users.shuffle

  #     if registered_users.length.even?

  #       registered_users.each_slice(2) do |user1, user2|
  #         match = Match.new(tournament_id: tournament.id)
  #         match.users << user1
  #         match.users << user2
  #         matches << match
  #       end
  #     else
  #     matches << registered_users.take(3)
  #     registered_users.drop(3).each_slice(2) do |user1, user2|
  #       match = Match.new(tournament_id: tournament.id)
  #       match.users << user1
  #       match.users << user2
  #       matches << match
  #     end
  #   end
  #   Match.transaction do
  #     matches.each(&:save!)
  #   end
  # end

  def playmatch
    player1 = players[0]
    player2 = players[1]

    if player1['selection'] == player2['selection']
      puts 'It is a tie'
    elsif (player1['selection'] == ROCK && player2['selection'] == SCISSOR) ||
          (player1['selection'] == SCISSOR && player2['selection'] == PAPER) ||
          (player1['selection'] == PAPER && player2['selection'] == ROCK)
      puts "#{player1['played']} wins!"
    else
      puts "#{player2['played']} wins!"
    end
  end

  # POST /matches or /matches.json
  def create_matches
    tournament_id = params[:tournament_id]
    tournament = Tournament.find(tournament_id)
    matches = []
    registered_users = tournament.users.shuffle
    length = registered_users.length
    redirect_to tournament_path(tournament_id), notice: 'Nobody registed for this Tournament' and return if length.zero?

    if (length % 4).zero? || (length % 8).zero?
      matches = group_by_two(registered_users, tournament)
    elsif (length % 5).zero?
      first_three_players = registered_users[0..2]
      remaining_players = registered_users.drop(3)
      matches_three = group_by_three(first_three_players, tournament)
      matches_two = group_by_two(remaining_players, tournament)
      matches = matches_two + matches_three
    elsif (length % 7).zero?
      matches = group_by_three(registered_users[0..2], tournament) +
                group_by_two(registered_users[3..4], tournament) +
                group_by_two(registered_users[5..6], tournament)
    elsif (length % 6).zero?
      matches = group_by_three(registered_users[0..2], tournament) +
                group_by_three(registered_users[3..5], tournament)
    elsif (length % 3).zero?
      matches = group_by_three(registered_users, tournament)
    elsif (length % 2).zero?
      matches = group_by_two(registered_users, tournament)
    end
    Match.transaction do
      matches.each(&:save!)
    end
    redirect_to tournament_path(tournament_id), notice: 'Matches Generated' and return
  end

  def group_by_two(registered_users, tournament)
    matches = []
    registered_users.each_slice(2) do |user1, user2|
      match_start_time = tournament_start_time + 3.minutes
      match = Match.create(tournament_id: tournament.id, match_time: match_start_time)
      # usermatches = UsersMatch.new(match:, user: user1)
      matches << user_match_obj(match, user1)
      matches << user_match_obj(match, user2)
    end
    matches
  end

  def group_by_three(registered_users, tournament)
    matches = []
    match_start_time = tournament_start_time + 3.minutes
    registered_users.each_slice(3) do |user1, user2, user3|
      match = Match.create(tournament_id: tournament.id, match_time: match_start_time)
      matches << user_match_obj(match, user1)
      matches << user_match_obj(match, user2)
      matches << user_match_obj(match, user3)
    end
    matches
  end

  def user_match_obj(match, user)
    UsersMatch.new(match:, user:)
  end

  # PATCH/PUT /matches/1 or /matches/1.json
  def update
    respond_to do |format|
      if @match.update(match_params)
        format.html { redirect_to match_url(@match), notice: 'Match was successfully updated.' }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /matches/1 or /matches/1.json
  def destroy
    @match.destroy

    respond_to do |format|
      format.html { redirect_to matches_url, notice: 'Match was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_match
    @match = Match.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def match_params
    params.require(:match).permit(:match_winner_id, :winner_score, :match_time, :tournament_id)
  end
end

# end
# else
#   # matches << registered_users.take(3)
#   # registered_users.drop(3).each_slice(2) do |user1, user2|
#   #   match = Match.new(tournament_id: tournament.id)
#   #   match.user << user1
#   #   match.user << user2
#   #   matches << match
#   # end
# end

# ##############
# match_start_time = tournament_start_time + 5.minutes
# registered_users.each_slice(2) do |user1, user2|
#   match_start_time = tournament_start_time + 5.minutes
#   match = Match.create(tournament_id: tournament.id, match_time: match_start_time)
#   usermatches = UsersMatch.new(match:, user: user1)
#   matches << usermatches
#   usermatches = UsersMatch.new(match:, user: user2)
#   matches << usermatches
# end

# def generate_matches
#   tournaments = Tournament.all
#   matches = []
#   tournaments.each do |tournament|
#     tournament.registration_deadline < Time.now.getlocal
#     tournament = Tournament.find(tournament_id)
#     registered_users = tournament.users.shuffle

#     if registered_users.length.even?

#       registered_users.each_slice(2) do |user1, user2|
#         match = Match.new(tournament_id: tournament.id)
#         match.user << user1
#         match.user << user2
#         matches << match
#       end
#     else
#       matches << registered_users.take(3)
#       registered_users.drop(3).each_slice(2) do |user1, user2|
#         match = Match.new(tournament_id: tournament.id)
#         match.user << user1
#         match.user << user2
#         matches << match
#       end
#     end
#   Match.transaction do
#     matches.each(&:save!)
#   end
# end

# tournament = Tournament.find(tournament_id)
# registered_users = tournament.users
# registered_users.combination(2).each do |user1, user2|
#   match = Match.new(tournament:))
# match.users << user1
# match.users << user2
# match.save
# end

# registered_users.each_slice(3) do |trio|
#   match = Match.new(tournament_id: tournament.id)
#   match.users << trio
#   matches << match
# end

# registered_users.each_slice(4) do |quad|
#   match = Match.new(tournament_id: tournament.id)
#   match.users << quad
#   matches << match
# end

#   respond_to do |format|
#     if @match.save
#       format.html { redirect_to match_url(@match), notice: 'Match was successfully created.' }
#     else
#       format.html { render :new, status: :unprocessable_entity }
#     end
#   end
# end
# Define the winning combinations as a hash
# winning_combinations = {
#   'rock' => 'scissors',
#   'paper' => 'rock',
#   'scissors' => 'paper'
# }

# # Determine the number of players and matches per player
# num_players = players.size
# matches_per_player = num_players == 2 ? 1 : num_players - 1

# # Determine the winner(s) of the game
# if num_players == 2
#   # Two-player game
#   if players['player1'] == players['player2']
#     winner = 'draw'
#   elsif winning_combinations[players['player1']] == players['player2']
#     winner = 'player1'
#   else
#     winner = 'player2'
#   end
# else
#   # Three-player game
#   player_wins = Hash.new(0)
#   players.each do |player, selection|
#     players.each do |opponent, opponent_selection|
#       next if player == opponent
#       if winning_combinations[selection] == opponent_selection
#         player_wins[player] += 1
#       end
#     end
#   end
#   if player_wins.empty?
#     winner = 'draw'
#   else
#     max_wins = player_wins.values.max
#     winner = player_wins.select { |player, wins| wins == max_wins }.keys
#   end
# end

# # Return the winner(s)
# return winner
# end

# end
