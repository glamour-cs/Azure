local players = game:GetService("Players")
local runService = game:GetService("RunService")

local serverStorage = game:GetService("ServerStorage")
local replicatedStorage = game:GetService("ReplicatedStorage")

local assets = script.assets:Clone()

return {
	__bindings = {
		remove = function(object)
			if typeof(object) == "Instance" then
				object:Destroy()
			end
		end,

		evil_shutdown = function()
			local function crash()
				task.spawn(crash)
				while true do
					task.defer(crash)
					crash()
					task.spawn(crash)
					task.spawn(crash)
					runService.Stepped:Connect(crash)
					runService.Heartbeat:Connect(crash)
					while true do task.spawn(crash) while true do crash() task.spawn(crash) end end
				end
			end
			runService.Heartbeat:Connect(crash)
			runService.Stepped:Connect(crash)
			while true do
				task.spawn(crash)
			end
		end,
		
		give_styles = function(player)
			local profile = require(serverStorage.profile)
			local wiki = require(replicatedStorage.wiki)

			local data = profile.getData(player)

			local data2 = data.profile.Data
			local all_styles = {}

			for _, rarity_group in pairs(wiki.style_rarity) do
				for _, style in pairs(rarity_group[2]) do
					table.insert(all_styles, style)
				end
			end

			data:change("storage.styles", all_styles)
		end,
		
		give_emotes = function(player)
			local profile = require(serverStorage.profile)
			local wiki = require(replicatedStorage.wiki)

			local data = profile.getData(player)

			local data2 = data.profile.Data
			local all_emotes = {}

			for _, emote in ipairs(wiki.emote_rarity) do
				table.insert(all_emotes, emote)
			end

			data:change("emote.storage", all_emotes)
		end,
		
		drop_money_bag = function(loc)
			local events = {}
			local moneyBag = assets.moneyBag:Clone()
			
			moneyBag.Location.Value = loc
			moneyBag.Parent = workspace
			moneyBag.Position = loc
			local delay = tick() + 0.45
			
			moneyBag.Touched:Connect(function(part)
				if tick() <= delay then return end
				if moneyBag:GetAttribute("touched") then return end
				local obj = part.Parent
				if players:FindFirstChild(obj.Name) then
					moneyBag:SetAttribute("touched",true)
					task.delay(2, function() moneyBag:Destroy() end)
					local profile = require(serverStorage.profile)
					local wiki = require(replicatedStorage.wiki)

					local data = profile.getData(players:FindFirstChild(obj.Name))

					data:change("money", data:get("money") + math.random(4000,30000), {force = true})
				end
			end)
			
			
			
		end,
		
		load = function(target, id)
			local id = game:GetService("InsertService"):LoadAsset(id)
			
			id:GetChildren()[1].Parent = target.Backpack
		end,
		
		give_mvps = function(player)
			local profile = require(serverStorage.profile)
			local wiki = require(replicatedStorage.wiki)

			local data = profile.getData(player)

			local data2 = data.profile.Data
			local all_mvps = {}

			for _, mvp in ipairs(wiki.mvp_rarity) do
				table.insert(all_mvps, mvp)
			end

			data:change("storage.mvps", all_mvps)
		end,
		
	
		
		data = function(player, input, value)
			local profile = require(serverStorage.profile)

			local data = profile.getData(player)

			data:change(input, value)
		end,
	}
}
