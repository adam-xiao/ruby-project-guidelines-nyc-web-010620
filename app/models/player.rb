require_relative '../../config/environment'
require_relative '../../bin/run.rb'
require 'pp'

class Player < ActiveRecord::Base
    belongs_to :team
    #attr_accessor :summoner_id, :summoner_name
    #def player(input)
        #URL = "https://na1.api.riotgames.com/lol/summoner/v4/summoners/by-name/#{input}?api_key=#{api_key}"
        #data = JSON.parse(RestClient.get(URL))
        #@summoner_id = data["id"] #encrypted summoner name
        #@summoner_name = data["name"] # public summoner name
        #@accountId = data["accountId"] #encrypted account ID
        #@puuid = data["puuid"] #encrypted PUUID
    #end


    def self.populator
        url = "https://na1.api.riotgames.com/lol/league/v4/grandmasterleagues/by-queue/RANKED_SOLO_5x5?api_key=#{ENV["API_KEY"]}"
        data = JSON.parse(RestClient.get(url))
        data["entries"].each{|enum|
        Player.create(:summoner_name => enum["summonerName"], :summoner_id => enum["summonerId"])
    
        }
    end

    def self.info(input)
        index = Player.all.find{|player| player.summoner_name == input}.summoner_id
        url = "https://na1.api.riotgames.com/lol/league/v4/entries/by-summoner/#{index}?api_key=#{ENV["API_KEY"]}"
        data = JSON.parse(RestClient.get(url))
        puts "Career Wins: #{data[0]["wins"]}, Losses: #{data[0]["losses"]}, Winrate: #{((data[0]["losses"].to_f)/data[0]["wins"] * 100).round(2)}%"
    end
end

# Player.info("Kenv1")