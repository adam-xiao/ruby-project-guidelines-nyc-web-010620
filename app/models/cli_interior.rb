$prompt =  TTY::Prompt.new

class CliInterior


    def self.main_menu
        $prompt.select("What can I do for you Summoner?") do |menu|
            #menu.choice 'DUMMMMMMMMY'
            menu.choice 'Simulate', -> { simulate }
            menu.choice 'Player Info', -> { player_info }
            menu.choice 'Team Info', -> { team_info }
        end
    end

    def self.simulate
        $prompt.select("Which simulation?") do |menu|
            menu.choice "Update player database", -> {
                Player.delete_all
                Player.populator
                puts "#{Player.all.length} Players have been successfully created!"
            }
            menu.choice "Create random teams", -> {
                Team.delete_all
                Team.team_maker
                puts "#{Team.all.length} Teams have been successfully created!"
            }
            menu.choice "Create random matches", -> {
                Match.delete_all
                Match.match_maker
                puts "#{Match.all.length} Matches have been successfully created!"
            }
            menu.choice "Simulate a match", -> { kind_of_match }
            menu.choice "Back to main menu", -> { main_menu }
        end
    end

    def self.kind_of_match
        $prompt.select("What kind of match would you like to simulate?") do |menu|
            menu.choice 'Select', -> { select_teams }
            menu.choice 'Random', -> {  
                Match.match_selector(Team.all.ids.sample, Team.all.ids.sample)
            }
            menu.choice "Back to main menu", -> { main_menu }
        end
    end

    def self.select_teams
        team1 = $prompt.select("Select the first team") do |menu|
            Team.all.map { |team| menu.choice team.id }
        end

        team2 = $prompt.select("Select the second team") do |menu|
            Team.all.map { |team| menu.choice team.id }
        end
        
        Match.match_selector(team1.to_i, team2.to_i)
    end

    def self.player_info
        player = $prompt.ask("Which player are you interested in?")

        # player = $prompt.select("Which player are you interested in?") do |menu|
        #     Player.all.map { |team| menu.choice team.summoner_name }
        # end
        
        $prompt.select("What would you like to know about your player?") do |menu|
            menu.choice "All info", -> { Player.all_info(player) }
            menu.choice "Current team", -> { Team.name_to_team(player) }
            menu.choice "Career Record" , -> { Player.info(player) }
            menu.choice "Most experienced champions", -> { Player.most_experienced(player) }
            menu.choice "Rank (League Points)", -> { puts Player.rank(player) }
            menu.choice "Match History", -> { Player.match_history(player) }
            menu.choice "Positions Played", -> { Player.plays(player) }
            menu.choice "Back to main menu", -> { main_menu }
        end
    end

    def self.team_info
        team = $prompt.select("Select the team") do |menu|
            Team.all.map { |team| menu.choice team.id }
        end

        $prompt.select("What would you like to know about your team?") do |menu|
            menu.choice "Current Members", -> { puts "Team Roster: #{Team.team_given_id(team.to_i)}" }
            menu.choice "Team Winrate", -> { puts Team.team_winrate(team.to_i) }
            menu.choice "Back to main menu", -> { main_menu }
        end
    end
end
