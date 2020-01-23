#require_relative '../../config/environment'

class Team < ActiveRecord::Base
    has_many :red_id, foreign_key: :match_id, class_name: "Match"
    has_many :blue_id, through: :red_id

    has_many :blue_id, foreign_key: :match_id, class_name: "Match"
    has_many :red_id, through: :blue_id

    has_many :players

    def self.team_maker
        summ_names = Player.all.map{|player| player.summoner_name}
        teams = []

        ((summ_names.length / 10).floor).times {|ten_players|
            2.times{
            new_team = summ_names.sample(5)
            teams << new_team
            summ_names - new_team
            }
        }

        teams.each{|team|
            Team.create(:Player1 => team[0], :Player2 => team[1], :Player3 => team[2], :Player4 => team[3], :Player5 => team[4])
        }

    pp teams
    puts teams.length 
    end

    def self.team_given_id(input) #Given team_id(int), return team members
        team_roster = []
        team_column = Team.all.find{|team| team["id"] == input}
        (1..5).each{|enum| team_roster << team_column["Player#{enum}"]}
        return team_roster
    end

    def self.total_lp(input) #Given team_id(int), return their total LP
        total = 0
        roster = Team.team_given_id(input) #Finds team, given ID
        roster.each{|member| total += Player.league_points(member)} #Sums up all their individual LP
        return total
    end

    def self.total_winrate(input) #Given team_id(int), return their Win/Loss & Winrate
        total_wins, total_losses = 0, 0
        roster = Team.team_given_id(input)
        member_wins = []
        member_losses = []
        roster.each{|member| member_wins << Player.winrate(member)[0]} #Gets wins from each member on team
        roster.each{|member| member_losses << Player.winrate(member)[1]} #Gets losses from each member on team
        winrate = ((member_wins.sum.to_f)/(member_wins.sum + member_losses.sum) * 100).round(2) #Calculates winrate
        return [member_wins.sum, member_losses.sum, winrate, member_wins, member_losses] #
    end

    def self.team_winrate(input) #Given team_id(int), return their Win/Loss & Winrate
        total_wins, total_losses = 0, 0
        roster = Team.team_given_id(input)
        roster.each{|member| total_wins += Player.winrate(member)[0]} #Gets wins from each member on team
        roster.each{|member| total_losses += Player.winrate(member)[1]} #Gets losses from each member on team
        winrate = ((total_wins.to_f)/(total_wins + total_losses) * 100).round(2) #Calculates winrate
        return "Team - Wins: #{total_wins}, Losses: #{total_losses}, Overall Winrate: #{winrate}%"
    end

    def self.mains(input) #Given team_id(int), returns each players top 3 most played champions
        result = []
        roster = Team.team_given_id(input)
        roster.each{|member| result << Player.player_most_experienced(member)}
        return result 
    end

    def self.assign_champs(input) #Given team_id(int), assigns all of the players a champ.a
        #champ_list = Team.mains(input) #Gets a list of all players and their respective mains
        data = Team.mains(input)
        roster = [] #Gets username
        total_mastery = [] #Contains an array of integers, denoting their total mastery count of their top 5 champions summed.
        assigned_champ = []
        data.each{|subarray| 
            mastery_count = 0
            champ_map = [] #Keeps track of what number maps to what champ
            roster << subarray[0] 
            (1..5).each{ |counter|
                mastery_count += subarray[counter][2] #Loops through array to get their mastery
                champ_map << subarray[counter][2]
            }
            champion = nil
            rng = rand(0..mastery_count)
            iterator = 0
            chance = nil
            while champion == nil
                if champ_map[iterator] >= rng
                    chance = ((subarray[iterator][2].to_f/(mastery_count))*100).round(2)
                    champion = subarray[iterator][1]
                end
                rng -= champ_map[iterator]
                iterator += 1
            end
            if champion.length == 1
                champion = ["Senna","Aphelios","Sett","Qiyana","Yummi","Sylas","Neeko","Pyke","Kaisa","Zoe"].sample #API doesn't support their 10 most recent charcaters
                chance = rand(1..13.00).round(2) #Generate some random value of their games if it's one of the 10 most recent charcaters inbetween 1-13
            end
            assigned_champ << [champion, chance]
            total_mastery << mastery_count
        }
        return roster.zip(assigned_champ) # Output https://gyazo.com/9ee337b6284052fc36f383fb2f5507b4
    end
end