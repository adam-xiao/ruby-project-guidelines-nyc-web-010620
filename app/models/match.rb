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

     def self.results #Returns all results for each match, right now just returns the default as blue team wins.
        #Match.all.map{|match| match["result"] = "#{match["blue_id"]} wins"}
        Match.all.map{|match| match.update(result: "Blue Team Wins!")}
     end

     def self.match_selector(blue_id, red_id)
        blue_roster = Team.team_given_id(blue_id) #Creating all of these variables at the top, so that way when I retrieve data again, I won't have to call API again. Just referencing the data.
        red_roster = blue_team = Team.team_given_id(red_id)
        blue_lp = Team.total_lp(blue_id)
        red_lp = Team.total_lp(red_id)
        blue_team_lineup = Team.assign_champs(blue_id)
        red_team_lineup = Team.assign_champs(red_id)
        puts "________________________________________________________________"
        puts "Blue Team: #{blue_roster}"
        puts "Blue Team LP: #{blue_lp} | Avg Per Member: #{blue_lp/5.00}"
        #puts Team.team_winrate(blue_id)
        puts "----------------"
        puts "Champion Select"
        puts "----------------"
        puts "#{blue_team_lineup[0][0]} has selected #{blue_team_lineup[0][1][0]}, picked in #{blue_team_lineup[0][1][1]}% of their games" 
        puts "#{blue_team_lineup[1][0]} has selected #{blue_team_lineup[1][1][0]}, picked in #{blue_team_lineup[1][1][1]}% of their games"
        puts "#{blue_team_lineup[2][0]} has selected #{blue_team_lineup[2][1][0]}, picked in #{blue_team_lineup[2][1][1]}% of their games"
        puts "#{blue_team_lineup[3][0]} has selected #{blue_team_lineup[3][1][0]}, picked in #{blue_team_lineup[3][1][1]}% of their games"
        puts "#{blue_team_lineup[4][0]} has selected #{blue_team_lineup[4][1][0]}, picked in #{blue_team_lineup[4][1][1]}% of their games"
        puts "_______________________________VS_______________________________"
        puts "Red Team: #{red_roster}"
        puts "Red Team LP: #{red_lp} | Avg Per Member: #{red_lp/5.00}"
        #puts Team.team_winrate(red_id)
        puts "----------------"
        puts "Champion Select"
        puts "----------------"
        puts "#{red_team_lineup[0][0]} has selected #{red_team_lineup[0][1][0]}, picked in #{red_team_lineup[0][1][1]}% of their games" 
        puts "#{red_team_lineup[1][0]} has selected #{red_team_lineup[1][1][0]}, picked in #{red_team_lineup[1][1][1]}% of their games"
        puts "#{red_team_lineup[2][0]} has selected #{red_team_lineup[2][1][0]}, picked in #{red_team_lineup[2][1][1]}% of their games"
        puts "#{red_team_lineup[3][0]} has selected #{red_team_lineup[3][1][0]}, picked in #{red_team_lineup[3][1][1]}% of their games"
        puts "#{red_team_lineup[4][0]} has selected #{red_team_lineup[4][1][0]}, picked in #{red_team_lineup[4][1][1]}% of their games"
        puts "________________________________________________________________"
        
     end

     def self.reset_matches # Returns all matches back to "In Progress"
        Match.all.map{|match| match.update(result: "In Progress")}
    end



end

