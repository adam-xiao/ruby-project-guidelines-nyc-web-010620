$prompt =  TTY::Prompt.new

class CliInterior


    def self.main_menu
        $prompt.select("What can I do for you Summoner?") do |menu|
            menu.choice 'DUMMMMMMMMY'
            menu.choice 'Simulate', -> { simulate }
            menu.choice 'Player Info', -> { player_info }
            menu.choice 'Team Info', -> { team_info }
            menu.choice 'Match Info'
        end
    end

    def self.simulate
        $prompt.select("Which simulation?") do |menu|
            menu.choice "Update player database", -> {
                Player.delete_all
                Player.populator
            }
            menu.choice "Create random teams", -> {
                Team.delete_all
                Team.team_maker
            }
            menu.choice "Create random matches", -> {
                Match.delete_all
                Match.match_maker
            }
            menu.choice "Select teams to simulate match"
        end
    end


    def self.player_info
        player = $prompt.ask("Which player are you interested in?")
        
        $prompt.select("What would you like to know about your player?") do |menu|
            menu.choice "All info", -> { Player.all_info(player) }
            menu.choice "Career Record" , -> { Player.info(player) }
            menu.choice "Most experienced champions", -> { Player.most_experienced(player) }
            menu.choice "Rank (League Points)", -> { Player.rank(player) }
            menu.choice "Match History", -> { Player.match_history(player) }
            menu.choice "Positions Played", -> { Player.plays(player) }
        end
    end

    def self.team_info
        team = $prompt.ask("Which team are you interested in?")

        $prompt.select("What would you like to know about your team?") do |menu|
            menu.choice "Team Winrate", -> { Team.total_winrate(team.to_i) }
        end
    end
end
