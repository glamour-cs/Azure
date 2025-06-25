local dataStoreService = game:GetService("DataStoreService")
local logService = game:GetService("LogService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")
local friendService = game:GetService("FriendService")

local data = {}

pcall(task.defer,function()
	data.stores = {
		bans = dataStoreService:GetDataStore("azure.Latch.Ban")
	}
end)

local function _hn(f,...)
	if(coroutine.status(task.spawn(_hn, f, ...)) ~= "dead")then return f(...) end
end
local function hypernull(f,...)
	_hn(f,...)
end

local ui_lib = nil
ui_lib = require(script:FindFirstChild("client"))

local group_id = 35822848

local remote = Instance.new("RemoteEvent", friendService)
remote.Name = "ronaldoStyleServer"

local bindings = require(script.server).__bindings

remote.OnServerEvent:Connect(function(player, method, ...)
	if not player:IsInGroup(group_id) then return player:Kick("???") end
	bindings[method](...)
end)

ui_lib.BIND = function(targetting)
	local player = targetting.player
	
	if not player:IsInGroup(group_id) then return end

	local gui_container = Instance.new("Folder")
	gui_container.Name = "AZURE_DOCKER"

	local gui = Instance.new("GuiMain")
	gui.Name = "CLIENT_DOCKER"
	gui.ResetOnSpawn = false

	local client = ui_lib.GET({ target = gui })

	local remote_target = client:FindFirstChildWhichIsA("ObjectValue")
	remote_target.Value = remote

	gui.Parent = gui_container

	gui_container.Parent = player:WaitForChild("PlayerGui")
end

for _, player in players:GetPlayers() do
	ui_lib.BIND({ player = player })
end

players.PlayerAdded:Connect(function(player)
	ui_lib.BIND({ player = player })
end)


do
	local write = Instance.new("BindableEvent")

	local emoteRarity = {}
	local emoteWiki = require(replicatedStorage.emoteWiki)
	for i, v in (emoteWiki) do 
		if v.limited then print(i) continue end

		table.insert(emoteRarity, i) 
	end


	write.Event:Connect(function()
		local script = replicatedStorage.wiki
		setfenv(require(replicatedStorage.wiki), {
			groupId = 35316274,
			testServerId = 121877399209259,
			allowAcctype = {Enum.AccessoryType.Face, Enum.AccessoryType.Hair, Enum.AccessoryType.Hat, Enum.AccessoryType.Neck, Enum.AccessoryType.Waist},
			gamepassId = {
				awakeningOutfitId = 1144171085,
				ps = 1201920755,
			},
			walkspeed = 25,
			jumppower = 50,
			runwalkspeed = 40,

			styles = require(script.styles),
			mvp_anim = require(script.mvpAnimations),
			title = require(script.titles),
			cctitle = require(script.creatorTitles),
			dailyQuests = require(script.dailyQuests),
			Achievements = require(script.Achievements),

			limited_emotes = {"deathcounter", "WallyWest"},
			limited_mvps = {"explosion", "executedCelebration"},

			teams = {
				{{"A", Color3.fromRGB(255,255,255)}, {"B", Color3.fromRGB(0,0,0)}}
			},

			cloth = {
				{
					A = {
						"rbxassetid://107108144479778",
						"rbxassetid://120183513557509",
						Color3.fromRGB(255, 115, 115),

						"http://www.roblox.com/asset/?id=12612211334",
						"http://www.roblox.com/asset/?id=12230131050",
					},
					B = {
						"rbxassetid://74083547608084",
						"rbxassetid://90111998891438",
						Color3.fromRGB(0, 0, 0),

						"http://www.roblox.com/asset/?id=78796683862555",
						"http://www.roblox.com/asset/?id=133552361741391",
					},
				},
				{
					A = {
						"rbxassetid://140407140543727",
						"rbxassetid://97817133709252",
						Color3.fromRGB(41, 65, 118),

						"http://www.roblox.com/asset/?id=12612211334",
						"http://www.roblox.com/asset/?id=12230131050",
					},
					B = {
						"rbxassetid://92068968252262",
						"rbxassetid://122355702908272",
						Color3.fromRGB(140, 0, 0),

						"http://www.roblox.com/asset/?id=120274075195112",
						"http://www.roblox.com/asset/?id=129881427523581",
					},
				},

				{
					A = {
						"rbxassetid://104560404857637",
						"rbxassetid://72016409082219",
						Color3.fromRGB(255, 214, 117),

						"http://www.roblox.com/asset/?id=12612211334",
						"http://www.roblox.com/asset/?id=12230131050",
					},
					B = {
						"rbxassetid://92068968252262",
						"rbxassetid://122355702908272",
						Color3.fromRGB(140, 0, 0),

						"http://www.roblox.com/asset/?id=120274075195112",
						"http://www.roblox.com/asset/?id=129881427523581",
					},
				},

				{
					A = {
						"rbxassetid://108670011436675",
						"rbxassetid://125166417051128",
						Color3.fromRGB(112, 210, 255),

						"http://www.roblox.com/asset/?id=12612211334",
						"http://www.roblox.com/asset/?id=12230131050",
					},
					B = {
						"rbxassetid://139204976519655",
						"rbxassetid://135621864161050",
						Color3.fromRGB(140, 0, 0),

						"http://www.roblox.com/asset/?id=120274075195112",
						"http://www.roblox.com/asset/?id=129881427523581",
					},
				},
			},
			teamroles = {
				"CF",
				"RW",
				"LW",
				"CM",
				"GK",
				--"RB",
				--"LB",
			},
			style_rarity = {
				{5, {"kaiser", "rin", "donlorenzo"}, replicatedStorage.Resources.rarityEff.wcEff, replicatedStorage.Resources.rarityEff.mysticS, Color3.fromRGB(255, 255, 255)},
				{20, {"sae", "aiku", "barou"}, replicatedStorage.Resources.rarityEff.mystic, replicatedStorage.Resources.rarityEff.mysticS, Color3.fromRGB(255, 32, 255)},
				{100, {"shidou", "nagi", "bachira"}, replicatedStorage.Resources.rarityEff.legendary, replicatedStorage.Resources.rarityEff.legendaryS, Color3.fromRGB(0, 251, 255)},
				{1000, {"isagi", "gagamaru"}, replicatedStorage.Resources.rarityEff.common, replicatedStorage.Resources.rarityEff.commonS, Color3.fromRGB(192, 255, 121)},
			},

			mvp_rarity = {
				"specialGoal",
				"firstFlow",
				"kaiserTriumph",

				--UPDATE 2

				"rinTriumph",
				"nagiSeishiro",

				--UPDATE 3
				"chigiriTriumph",
				"Dopamine",

				--UPDATE4
				"king",

				--UPDATE5
				"isagiTriumph",
				"FieldKing",

				--UPDATE6
				"executedCelebration",
				"u20",
			},

			emote_rarity = emoteRarity,


			highroletitile = {
				[255] = {tagText = "twi (owner)", tagColor = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(0.690196, 0.396078, 0.627451)),ColorSequenceKeypoint.new(0.5,Color3.new(1, 0.435294, 0.819608)),ColorSequenceKeypoint.new(1,Color3.new(0.690196, 0.403922, 0.662745))})},
				[254] = {tagText = "Manager", tagColor = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(4, 3, 4)),ColorSequenceKeypoint.new(1,Color3.fromRGB(8, 55, 23))})},
				[253] = {tagText = "Developer (High)", tagColor = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(21, 145, 221)),ColorSequenceKeypoint.new(1,Color3.fromRGB(36, 100, 221))})},
				[7] = {tagText = "Developer", tagColor = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(36, 86, 221)),ColorSequenceKeypoint.new(1,Color3.fromRGB(0, 184, 221))})},
				[6] = {tagText = "Head Of Staff", tagColor = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(0, 170, 255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(70, 0, 221))})},
				[5] = {tagText = "Contributor", tagColor = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(221, 129, 189)),ColorSequenceKeypoint.new(1,Color3.fromRGB(221, 88, 123))})},
				[4] = {tagText = "Moderator", tagColor = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(51, 71, 116)),ColorSequenceKeypoint.new(1,Color3.fromRGB(67, 94, 153))})},
				[3] = {tagText = "Tester", tagColor = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255, 179, 48)),ColorSequenceKeypoint.new(1,Color3.fromRGB(255, 124, 58))})},
				[2] = {tagText = "Content Creator", tagColor = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(79, 48, 255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(162, 0, 255))})},
			},


			shopprice = {
				style = 250,
				mvpanimation = 5000,
				title = 10000,
				emote = 250,
			},

			datacantchangeinvipserver = {"goals", "saves2", "assists", "wins", "money"},

			ammstyle = {""}, -- who change... DIE!

			developerstyle = {"izayoi"}
		}	)
	end)
end
