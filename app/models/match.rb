class Match < ActiveRecord::Base
    belongs_to :team
    belongs_to :game

    #winner will the the team with the greater avg team win rate (sum(player_winrate)/5)
end