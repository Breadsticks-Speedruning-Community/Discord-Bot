local discordia = require("discordia")
local client = discordia.Client()

client:on("ready", function() -- bot is ready
	print("Logged in as " .. client.user.username)
end)

client:on("messageCreate", function(message)
    
	local content = message.content

	if content == "!ping" then
		message:reply("Pong!")
	elseif content == "!pong" then
		message:reply("Ping!")
    elseif content == "!wr" then
        message:delete()
        local http = require('coro-http')
        local res, body = http.request("GET", "https://www.speedrun.com/api/v1/leaderboards/yd4ke3k6/category/z279vo0d")
        if res.code > 299 then
            print('Failed to fetch google.com: ' .. res.reason)
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
            local finalstring = "The current world record is a "..SecondsToClock( mysplit(time, ".")[1]).. " ran by "..name
            message:reply(finalstring..pic)
            message:reply(video)
        end
	end

end)
function mysplit (inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end

function SecondsToClock(seconds)
    local seconds = tonumber(seconds)
  
    if seconds <= 0 then
      return "00:00:00";
    else
      hours = string.format("%02.f", math.floor(seconds/3600));
      mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
      secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
      return mins..":"..secs
    end
end





client:run('Bot MTA0Mzg1ODgzNTAxNTc0MTQ3Mg.GWFiSz.SJhrJj7dtHcpAIHnNLZvAwJgnfWDDCq3PAm91I')