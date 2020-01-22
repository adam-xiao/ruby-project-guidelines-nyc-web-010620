class Match < ActiveRecord::Base
    belongs_to :home, class_name: "team"
    belongs_to :away, class_name: "team"

    #winner will the the team with the greater avg team win rate (sum(player_winrate)/5)
    #place two teams against each other until there are no other teams to place
end