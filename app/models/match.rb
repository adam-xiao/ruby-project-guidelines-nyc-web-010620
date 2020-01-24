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
        puts "_______________________________________"
        puts "Loading Simulation May Take Up To 20s..."
        puts "_______________________________________"
        blue_roster = Team.team_given_id(blue_id) #Creating all of these variables at the top, so that way when I retrieve data again, I won't have to call API again. Just referencing the data.
        red_roster = blue_team = Team.team_given_id(red_id)
        blue_lp = Team.total_lp(blue_id)
        red_lp = Team.total_lp(red_id)
        blue_team_lineup = Team.assign_champs(blue_id)
        red_team_lineup = Team.assign_champs(red_id)
        red_weight = 10000 # Used in winrate calculations
        blue_weight = 10000
        puts "________________________________________________________________"
        puts "Team ID: ##{blue_id}"
        puts "Blue Team: #{blue_roster}"
        puts "Blue Team LP: #{blue_lp[5]} | Avg Per Member: #{blue_lp[5]/5.00}"
        #Puts api fetch here to spread out requests and make data given to user fluid.
        blue_winrate = Team.total_winrate(blue_id)
        puts "Team Wins: #{blue_winrate[0]}, Losses: #{blue_winrate[1]}, Overall Winrate: #{blue_winrate[2]}%"
        puts "----------------"
        puts "Champion Select"
        puts "----------------"
        puts "#{blue_team_lineup[0][0]} has selected #{blue_team_lineup[0][1][0]}, picked in #{blue_team_lineup[0][1][1]}% of their games" 
        puts "#{blue_team_lineup[1][0]} has selected #{blue_team_lineup[1][1][0]}, picked in #{blue_team_lineup[1][1][1]}% of their games"
        puts "#{blue_team_lineup[2][0]} has selected #{blue_team_lineup[2][1][0]}, picked in #{blue_team_lineup[2][1][1]}% of their games"
        puts "#{blue_team_lineup[3][0]} has selected #{blue_team_lineup[3][1][0]}, picked in #{blue_team_lineup[3][1][1]}% of their games"
        puts "#{blue_team_lineup[4][0]} has selected #{blue_team_lineup[4][1][0]}, picked in #{blue_team_lineup[4][1][1]}% of their games"
        puts "_______________________________VS_______________________________"
        puts "Team ID: ##{red_id}"
        puts "Red Team: #{red_roster}" #[1LP,2LP,3LP,4LP,5LP,total]
        puts "Red Team LP: #{red_lp[5]} | Avg Per Member: #{red_lp[5]/5.00}"
         #Puts api fetch here to spread out requests and make data given to user fluid.
        red_winrate = Team.total_winrate(red_id) #[total_wins, total_losses, winrate]
        puts "Team Wins: #{red_winrate[0]}, Losses: #{red_winrate[1]}, Overall Winrate: #{red_winrate[2]}%"
        puts "----------------"
        puts "Champion Select"
        puts "----------------"
        puts "#{red_team_lineup[0][0]} has selected #{red_team_lineup[0][1][0]}, picked in #{red_team_lineup[0][1][1]}% of their games" 
        puts "#{red_team_lineup[1][0]} has selected #{red_team_lineup[1][1][0]}, picked in #{red_team_lineup[1][1][1]}% of their games"
        puts "#{red_team_lineup[2][0]} has selected #{red_team_lineup[2][1][0]}, picked in #{red_team_lineup[2][1][1]}% of their games"
        puts "#{red_team_lineup[3][0]} has selected #{red_team_lineup[3][1][0]}, picked in #{red_team_lineup[3][1][1]}% of their games"
        puts "#{red_team_lineup[4][0]} has selected #{red_team_lineup[4][1][0]}, picked in #{red_team_lineup[4][1][1]}% of their games"
        puts "________________________________________________________________"
        puts "****************Running game simulation****************"
        puts "All winrates are expressed as the chance blue team wins."
        puts "________________________________________________________________"
        puts "Initial Winrate: 50.00%"

        blue_weight += (blue_winrate[2] - red_winrate[2])*200#[total_wins, total_losses, winrate]

        if blue_winrate[2] > red_winrate[2]
            puts "Winrate: #{(blue_weight/(red_weight + blue_weight)*100).round(2)}% - Adjusted for: Blue team has a higher winrate (#{blue_winrate[2]}%) than Red (#{red_winrate[2]}%)"
        else
            puts "Winrate: #{(blue_weight/(red_weight + blue_weight)*100).round(2)}% - Adjusted for: Red team has a higher winrate (#{red_winrate[2]}%) than Blue (#{blue_winrate[2]}%)"
        end

        sleep 1.5

        blue_weight += (blue_lp[5] - red_lp[5])*1.5

        if blue_lp[5] > red_lp[5]
            puts "Winrate: #{(blue_weight/(red_weight + blue_weight)*100).round(2)}% - Adjusted for: Blue team has higher aggregrate LP (#{blue_lp[5]} Points) than Red (#{red_lp[5]} Points)" 
        else
            puts "Winrate: #{(blue_weight/(red_weight + blue_weight)*100).round(2)}% - Adjusted for: Red team has higher aggregrate LP (#{red_lp[5]} Points) than Blue (#{blue_lp[5]} Points)" 
        end

        sleep 1.5

        blue_team_lineup.each{|enum|
            if 7 > enum[1][1].to_i
                sleep 1
                blue_weight -= (1000 - (enum[1][1]*100))
                puts "Winrate: #{(blue_weight/(red_weight + blue_weight)*100).round(2)}% - Adjusted for: #{enum[0]} (blue) seems inexperienced with #{enum[1][0]}, only playing them in #{enum[1][1]}% of their games."
            elsif enum[1][1].to_i > 30
                sleep 1
                blue_weight +=(((enum[1][1]*100)-15)/5)
                puts "Winrate: #{(blue_weight/(red_weight + blue_weight)*100).round(2)}% - Adjusted for: #{enum[0]} (blue) seems to frequently play #{enum[1][0]}, picking them in #{enum[1][1]}% of their games."
            end 
        }

        red_team_lineup.each{|enum|
        if 7 > enum[1][1].to_i
            sleep 1
            red_weight -= (1000 - (enum[1][1]*100))
            puts "Winrate: #{(blue_weight/(red_weight + blue_weight)*100).round(2)}% - Adjusted for: #{enum[0]} (red) seems inexperienced with #{enum[1][0]}, only playing them in #{enum[1][1]}% of their games."
        elsif enum[1][1].to_i > 20
            sleep 1
            red_weight += (((enum[1][1]*100)-15)/5)
            puts "Winrate: #{(blue_weight/(red_weight + blue_weight)*100).round(2)}% - Adjusted for: #{enum[0]} (red) seems to frequently play #{enum[1][0]}, picking them in #{enum[1][1]}% of their games."
        end 
        }


        (0..4).each{|count| #[member_wins.sum, member_losses.sum, winrate, member_wins, member_losses] #{(#blue_winrate[1]/(blue_winrate[0] + blue_winrate[1]))*100}
            if ((blue_winrate[3][count].to_f)/(blue_winrate[3][count] + blue_winrate[4][count])*100) > 56.5 #Checks if player winrate is above 56.5%
                sleep 1
              blue_weight += (((blue_winrate[3][count].to_f)/(blue_winrate[3][count] + blue_winrate[4][count])*100)-50)*100
              puts  "Winrate: #{(blue_weight/(red_weight + blue_weight)*100).round(2)}% - Adjusted for: #{blue_roster[count]} (blue) seems to have an abnormally high winrate #{((blue_winrate[3][count].to_f)/(blue_winrate[3][count] + blue_winrate[4][count])*100).round(2)}%"
            end
            if ((red_winrate[3][count].to_f)/(red_winrate[3][count] + red_winrate[4][count])*100) > 56.5 # Checks if winrate is above 56.5%
                sleep 1
               red_weight += (((red_winrate[3][count].to_f)/(red_winrate[3][count] + red_winrate[4][count])*100)-50)*100
               puts  "Winrate: #{(blue_weight/(red_weight + blue_weight)*100).round(2)}% - Adjusted for: #{red_roster[count]} (red) seems to have an abnormally high winrate #{((red_winrate[3][count].to_f)/(red_winrate[3][count] + red_winrate[4][count])*100).round(2)}%"
            end
            if ((blue_winrate[3][count].to_f)/(blue_winrate[3][count] + blue_winrate[4][count])*100) < blue_winrate[2] - 3 #Checks if player winrate is below avg by 3%
                sleep 1
                blue_weight += (((blue_winrate[3][count].to_f)/(blue_winrate[3][count] + blue_winrate[4][count])*100)-blue_winrate[2])*175
                puts  "Winrate: #{(blue_weight/(red_weight + blue_weight)*100).round(2)}% - Adjusted for: #{blue_roster[count]} (blue) seems to have an a subpar winrate #{((blue_winrate[3][count].to_f)/(blue_winrate[3][count] + blue_winrate[4][count])*100).round(2)}% - Comparative to the team (#{blue_winrate[2]}%)"
              end
            if ((red_winrate[3][count].to_f)/(red_winrate[3][count] + red_winrate[4][count])*100) < red_winrate[2] - 3 # Checks if winrate is below avg by 3%
                sleep 1
                red_weight += (((red_winrate[3][count].to_f)/(red_winrate[3][count] + red_winrate[4][count])*100)-red_winrate[2])*175
                puts  "Winrate: #{(blue_weight/(red_weight + blue_weight)*100).round(2)}% - Adjusted for: #{red_roster[count]} (red) seems to have a subpar winrate #{((red_winrate[3][count].to_f)/(red_winrate[3][count] + red_winrate[4][count])*100).round(2)}% - Comparative to the team (#{red_winrate[2]}%)"
            end
        }

        (0..4).each{|count| #[1LP,2LP,3LP,4LP,5LP,total]
            if blue_lp[count] > (red_lp[5]/5)+125#Checks to see if lp is above standard deviation (blue)
                sleep 1
                blue_weight += (blue_lp[count] - (red_lp[5]/5)-70)*2.75
                puts "Winrate: #{(blue_weight/(red_weight + blue_weight)*100).round(2)}% - Adjusted for: #{blue_roster[count]} (blue) seems to have a higher than rank (#{blue_lp[count]} LP) - Comparative to the blue team average (#{red_lp[5]/5} LP)"
            end

            if red_lp[count] > (blue_lp[5]/5)+125#Checks to see if lp is above standard deviation (red)
                sleep 1
                red_weight += (red_lp[count] - (blue_lp[5]/5)-70)*2.75
                puts "Winrate: #{(blue_weight/(red_weight + blue_weight)*100).round(2)}% - Adjusted for: #{red_roster[count]} (red) seems to have a higher rank (#{red_lp[count]} LP) - Comparative to the blue team average (#{blue_lp[5]/5} LP)"
            end

            if blue_lp[count] < (red_lp[5]/5)-125#Checks to see if lp is below standard deviation (blue)
                sleep 1
                blue_weight += (blue_lp[count] - (red_lp[5]/5)+25)*1.75
                puts "Winrate: #{(blue_weight/(red_weight + blue_weight)*100).round(2)}% - Adjusted for: #{blue_roster[count]} (blue) seems to have a lower than rank (#{blue_lp[count]} LP) - Comparative to the blue team average (#{red_lp[5]/5} LP)"
            end

            if red_lp[count] < (blue_lp[5]/5)-125#Checks to see if lp is below standard deviation (red)
                sleep 1
                red_weight += (red_lp[count] - (blue_lp[5]/5)+25)*1.75
                puts "Winrate: #{(blue_weight/(red_weight + blue_weight)*100).round(2)}% - Adjusted for: #{red_roster[count]} (red) seems to have a lower than rank (#{red_lp[count]} LP) - Comparative to the blue team average (#{blue_lp[5]/5} LP)"
            end
    
        }



        puts "___________________________________________"
        puts "Final Analysis: "
        puts "Blue team has a #{(blue_weight/(red_weight + blue_weight)*100).round(2)}% chance of winning"
        puts "Red team has a #{100 - (blue_weight/(red_weight + blue_weight)*100).round(2)}% chance of winning"
        puts "___________________________________________"

       return
        
     end

     def self.reset_matches # Returns all matches back to "In Progress"
        Match.all.map{|match| match.update(result: "In Progress")}
    end

end

