class Team < ActiveRecord::Base
    has_many :away_games, foreign_key: :match_id, class_name: "match"
    has_many :home_games, through: :away_games

    has_many :home_games, foreign_key :match_id, class_name: "match"
    has_many :away_games, through: :home_games


    def self.team_maker
        Team.create

    end
    #create teams
    #dont reuse players
    #discard remaining players so that we end up with an even number of teams with the most players used

end