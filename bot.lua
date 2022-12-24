local discordia = require("discordia")
local client = discordia.Client()
local json = require('json')
local fs = require('fs')
local prefix = "m?"
discordia.extensions() -- load all helpful extensions
client:on("ready", function() -- bot is ready
	print("Logged in as " .. client.user.username)
    client:setGame("breadsticks")
end)

client:on("messageCreate", function(message)
    if message.author.bot then return end 
    local content = message.content
	local args = content:split(" ") -- split all arguments into a table
	if args[1] == prefix.."src_code" then
		message:reply("This bots source code is hosted on github which is found here: https://github.com/Breadsticks-Speedruning-Community/Discord-Bot !")   
    elseif args[1] == prefix.."wr" then
        message:delete()
        local http = require('coro-http')
        if args[2] == "any" then
            local res, body = http.request("GET", "https://www.speedrun.com/api/v1/leaderboards/yd4ke3k6/category/z279vo0d")
            if res.code > 299 then
                print('Failed to fetch speedrun.com: ' .. res.reason)
            else
                print('Successfully fetched speedrun.com´s api!')
                local json = require('json')
                local default = json.decode(body).data.runs[1].run
                local video = tostring(default.videos.links[1].uri)
                local time = tostring(default.times.primary_t)
    
                local name = ""
                local pic = ""
                local usernamelink = default.players[1].uri
                local resd, bodyd = http.request("GET", usernamelink)
                if resd.code > 299 then
                    print("failed")
                else
                    name = tostring(json.decode(bodyd).data.names.international)
                    pic = tostring(json.decode(bodyd).data.assets.image.uri)
                end
                local finalstring = "The current any% world record is a "..SecondsToClock( time).." set by "..name
                message:reply(finalstring)
                client:setGame("Any% wr by "..name)
                message:reply(video)
            end
        elseif args[2] == "room1"then
        
           finalstring, video = getroom(1)
           message:reply(finalstring)
           message:reply(video)
            
        elseif args[2] == "room2"then
        
            finalstring, video = getroom(2)
            message:reply(finalstring)
            message:reply(video)
             
        elseif args[2] == "room3"then
        
            finalstring, video = getroom(3)
            message:reply(finalstring)
            message:reply(video)
             
        else
            message:reply("**YOU HAVE TO INPUT A VALID PARAMETER**")
        end
    elseif args[1] == prefix.."help"then
        message:reply("The commands available are: \n "..prefix.."wr {any, room1, room2, room3} \n "..prefix.."src_code")
    elseif args[1] == prefix.."prefix"then
        local author = message.guild:getMember(message.author.id)
        if author:hasPermission("administrator") then
            -- TO DO
        end
    end

end)


function SecondsToClock(time)
    local seconds = time

    local formated = string.format("%.2i:%.2i:%.2i", -- minutes:seconds:milliseconds
        (seconds / 60) % 60, -- minutes
        seconds % 60, -- seconds
        (seconds - math.floor(seconds)) * 100 -- milliseconds
    )

    return formated
end

function getroom(what_room)
    local http = require('coro-http')
    local res, body = http.request("GET", "https://www.speedrun.com/api/v1/categories/wdm7m6od/records")
    if res.code > 299 then
        print('Failed to fetch speedrun.com: ' .. res.reason)
    else
        print('Successfully fetched speedrun.com´s api!')
        local json = require('json')
        local default = json.decode(body).data[what_room].runs[1].run
        local video = tostring(default.videos.links[1].uri)
        local time = tostring(default.times.primary_t)

        local name = ""
        local pic = ""
        local usernamelink = default.players[1].uri
        local resd, bodyd = http.request("GET", usernamelink)
        if resd.code > 299 then
            print("failed")
        else
            name = tostring(json.decode(bodyd).data.names.international)
            pic = tostring(json.decode(bodyd).data.assets.image.uri)
        end
        local finalstring = "The current room"..what_room.."% world record is a "..SecondsToClock( time).." set by "..name
        return finalstring, video
    end

end





local content = fs.readFileSync('token.json')
local data = json.decode(content)
client:run('Bot '..data.token)