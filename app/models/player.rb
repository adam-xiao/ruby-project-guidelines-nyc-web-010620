#require_relative '../../config/environment'
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
    def self.get_id(input) #Given a summoner name, get their encrypted summoner ID
        cleanse = input.gsub(" ","") #Makes all the spaces in the input, not spaces.
        url = "https://na1.api.riotgames.com/lol/summoner/v4/summoners/by-name/#{cleanse}?api_key=#{ENV["API_KEY"]}"
        data = JSON.parse(RestClient.get(url)) 
        return data["id"]
    end

    def self.get_accountid(input)
        cleanse = input.gsub(" ","") #Makes all the spaces in the input, not spaces.
        url = "https://na1.api.riotgames.com/lol/summoner/v4/summoners/by-name/#{cleanse}?api_key=#{ENV["API_KEY"]}"
        data = JSON.parse(RestClient.get(url))
        return data["accountId"] #Gets account id
    end

    def self.populator #Populates the list of summoners
        url = "https://na1.api.riotgames.com/lol/league/v4/grandmasterleagues/by-queue/RANKED_SOLO_5x5?api_key=#{ENV["API_KEY"]}"
        data = JSON.parse(RestClient.get(url))
        data["entries"].each{|enum|
        Player.create(:summoner_name => enum["summonerName"], :summoner_id => enum["summonerId"])
        }
    end

    def self.info(input) #Gets Career Wins & Losses, gets winrate also
        id = Player.get_id(input)
        url = "https://na1.api.riotgames.com/lol/league/v4/entries/by-summoner/#{id}?api_key=#{ENV["API_KEY"]}"
        data = JSON.parse(RestClient.get(url))
        puts "Season Wins: #{data[0]["wins"]}, Losses: #{data[0]["losses"]}, Winrate: #{(((data[0]["wins"].to_f)/(data[0]["wins"] + data[0]["losses"])) *100).round(2)}%" 
    end


    def self.winrate(input) #Gets Career Wins & Losses (used in teams)
        id = Player.get_id(input)
        url = "https://na1.api.riotgames.com/lol/league/v4/entries/by-summoner/#{id}?api_key=#{ENV["API_KEY"]}"
        data = JSON.parse(RestClient.get(url))
        return [data[0]["wins"], data[0]["losses"]]
    end

    def self.most_experienced(input)
        id = Player.get_id(input)
        url = "https://na1.api.riotgames.com/lol/champion-mastery/v4/champion-masteries/by-summoner/#{id}?api_key=#{ENV["API_KEY"]}"
        data = JSON.parse(RestClient.get(url)) 
        champIDs = data.map{|element| element["championId"]}.take(5) #Takes top 5 most played champions, gets them in champ ID form
        champMast = data.map{|element| element["championPoints"]}.take(5) #Takes top 5 most played champions, get their champion mastery points

        champlist = "http://ddragon.leagueoflegends.com/cdn/6.24.1/data/en_US/champion.json" #Translates champion ID's to champion names
        champs = JSON.parse(RestClient.get(champlist))
        allChamps = Hash.new() #Makes a hash used to map their champ ID's to actual champions
        champs["data"].each{|champ| 
            allChamps[champ[1]["key"].to_i] = champ[1]["id"]
        }

        most_played = champIDs.map{|enum| allChamps[enum]} #Outputs champion names
        
        puts "Most Played"
        puts "-----------"
        (0..4).each{|counter| #Example Output "1. Jax | Mastery Points: 2473461"
            puts "#{counter + 1}. #{most_played[counter]} | Mastery Points: #{champMast[counter]}"
        } 
    end

    def self.player_most_experienced(input) # Used in teams to find top 3 most played. (Used in teams)
        id = Player.get_id(input)
        url = "https://na1.api.riotgames.com/lol/champion-mastery/v4/champion-masteries/by-summoner/#{id}?api_key=#{ENV["API_KEY"]}"
        data = JSON.parse(RestClient.get(url)) 
        champIDs = data.map{|element| element["championId"]}.take(5) #Takes top 5 most played champions, gets them in champ ID form
        champMast = data.map{|element| element["championPoints"]}.take(5) #Takes top 5 most played champions, get their champion mastery points

        champlist = "http://ddragon.leagueoflegends.com/cdn/6.24.1/data/en_US/champion.json" #Translates champion ID's to champion names
        champs = JSON.parse(RestClient.get(champlist))
        allChamps = Hash.new() #Makes a hash used to map their champ ID's to actual champions
        champs["data"].each{|champ| 
            allChamps[champ[1]["key"].to_i] = champ[1]["id"]
        }

        most_played = champIDs.map{|enum| allChamps[enum]} #Outputs champion names
        
        results = [input]
        (0..4).each{|counter| #Example Output "[1, Jax, 2473461]"
            results << [counter + 1, most_played[counter], champMast[counter]]
        } 
        return results #Example Output https://gyazo.com/6ce8ac8a8eb2550967380737adc8353f
    end



    def self.rank(input) #Given user, return their rank and league points
        id = Player.get_id(input)
        url = "https://na1.api.riotgames.com/lol/league/v4/entries/by-summoner/#{id}?api_key=#{ENV["API_KEY"]}"
        data = JSON.parse(RestClient.get(url)) 
        return "#{data[0]["tier"].titleize} #{data[0]["rank"]} | LP: #{data[0]["leaguePoints"]}"
    end

    def self.league_points(input) #Given user, return their league points (Used in teams)
        id = Player.get_id(input)
        url = "https://na1.api.riotgames.com/lol/league/v4/entries/by-summoner/#{id}?api_key=#{ENV["API_KEY"]}"
        data = JSON.parse(RestClient.get(url)) 
        return data[0]["leaguePoints"]
    end

    def self.level(input) #Gets level
        id = Player.get_id(input)
        url = "https://na1.api.riotgames.com/lol/summoner/v4/summoners/#{id}?api_key=#{ENV["API_KEY"]}"
        data = JSON.parse(RestClient.get(url))
        return data["summonerLevel"]
    end

    def self.match_history(input) #Outputs last 10 matches, and average barons, dragons, inhibs killed
        acc_id = Player.get_accountid(input)

        match_ids = []
        record = []

        plays = "https://na1.api.riotgames.com/lol/match/v4/matchlists/by-account/#{acc_id}?api_key=#{ENV["API_KEY"]}"
        plays_data = JSON.parse(RestClient.get(plays))
        plays_data["matches"].take(10).each{|game| match_ids << game["gameId"]} #takes 10 most recent matches and shoves them into match_ids
        
        dragons = 0
        towers = 0
        inhibs = 0
        barons = 0

        match_ids.each{|match| #Use this sparingly, it calls the API 10 times in one statement
            matches = "https://na1.api.riotgames.com/lol/match/v4/matches/#{match}?api_key=#{ENV["API_KEY"]}"
            match_data = JSON.parse(RestClient.get(matches))

            barons += match_data["teams"][0]["baronKills"]
            inhibs += match_data["teams"][0]["inhibitorKills"]
            dragons += match_data["teams"][0]["dragonKills"]
            towers += match_data["teams"][0]["towerKills"]


            if match_data["teams"][0]["win"] == "Fail"
                record << "L"
            elsif match_data["teams"][0]["win"] == "Win"
                record << "W"
            else
                record << match_data["teams"][0]["win"]
            end
        }

        puts "--------------------------------"
        puts "10 Most Recent Games: Wins: #{record.count("W")}, Losses: #{record.count("L")}"
        puts "#{record}"
        puts "Average Barons Killed: #{barons/10.00}"
        puts "Average Dragons Killed: #{dragons/10.00}"
        puts "Average Inhibitors Taken: #{inhibs/10.00}"
        puts "Average Towers Taken: #{towers/10.00}"
        puts "--------------------------------"


    end

    def self.all_info(input) #outputs several variables
        puts "-----------"
        puts "Data for: #{input}"
        Player.info(input)
        puts "Rank: #{Player.rank(input)}"
        puts "Level: #{Player.level(input)}"
        puts "-----------" 
        Player.plays(input)
        puts "-----------" 
        Player.most_experienced(input)
        Player.match_history(input)
    end

    def self.plays(input)
        acc_id = Player.get_accountid(input) #Gets account id

        lanes = Hash.new(0)
        
        plays = "https://na1.api.riotgames.com/lol/match/v4/matchlists/by-account/#{acc_id}?api_key=#{ENV["API_KEY"]}"
        plays_data = JSON.parse(RestClient.get(plays))

        plays_data["matches"].each{|game| lanes[game["lane"]] += 1}
        most_played = lanes.sort_by{|k, v| v}.reverse #.take(1).flatten
        puts "Lane Distribution"
        puts "------------------"
        puts "Mains: #{most_played[0][0].to_s.titleize}"
        most_played.each{|enum|
            if enum[0].to_s == "NONE" #Checks to see if lane is undefined
                puts "Remake - #{enum[1].to_s}% Chance" #Changes lane to offmeta if undefined
            else
                puts "#{enum[0].to_s.titleize} - #{enum[1].to_s}% Chance"
            end
        }
    end

end