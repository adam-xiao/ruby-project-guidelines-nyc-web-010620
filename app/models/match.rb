class Match < ActiveRecord::Base
    belongs_to :blue, class_name: "Team"
    belongs_to :red, class_name: "Team"

    #winner will the the team with the greater avg team win rate (sum(player_winrate)/5)
    #place two teams against each other until there are no other teams to place
    #Match.match_maker
     def self.match_maker
        #puts Team.all
        #binding.pry
         (Team.all.length / 2).times{
             two_teams = Team.all.sample(2)
             Match.create(:blue_id => two_teams[0]["id"], :red_id => two_teams[1]["id"], :result => "In Progress")
             Team.all - two_teams
         }
     end

     



end

