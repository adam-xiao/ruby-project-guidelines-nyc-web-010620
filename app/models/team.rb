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
    #create teams
    #dont reuse players
    #discard remaining players so that we end up with an even number of teams with the most players used

end