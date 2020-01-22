class Team < ActiveRecord::Base
    has_many :games
    has_many :teams, through: :matches

    def self.team_maker
        Team.create

    end
    #create teams
    #dont reuse players
    #discard remaining players so that we end up with an even number of teams with the most players used

end