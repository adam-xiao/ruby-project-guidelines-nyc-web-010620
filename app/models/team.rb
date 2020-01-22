class Team < ActiveRecord::Base
    has_many :matches
    has_many :tournaments, through: :matches

end