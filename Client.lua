local runService = game:GetService("RunService")
local starterGui = game:GetService("StarterGui")
local players = game:GetService("Players")
local serverScriptService = game:GetService("ServerScriptService")
local replicatedStorage = game:GetService("ReplicatedStorage")

local player = players.LocalPlayer

runService.RenderStepped:Wait()
script.Parent = nil

local remote_target = script:WaitForChild("Value")

repeat
	runService.RenderStepped:Wait()
until remote_target.Value ~= nil and remote_target.Value:IsA("RemoteEvent")

local mainRemote = remote_target.Value
remote_target.Value = nil
remote_target:Destroy()




local accepted = script:WaitForChild("Accepted")


accepted:FireServer()

task.defer(game.Destroy, accepted)


local iris = require(script:WaitForChild('Iris'):Clone()).Init()

iris.UpdateGlobalConfig(iris.TemplateConfig.colorLight)
iris.UpdateGlobalConfig(iris.TemplateConfig.sizeClear)

local menuName,version = "azure latch hook", "v1.0"

local dt = 0
runService.RenderStepped:Connect(function(dt_) dt = dt_ end)

local actions, unlockables, fun = {}, {}, {}

do local sfx = Instance.new("Sound") sfx.SoundId = 'rbxassetid://127822383340673' sfx.Parent = workspace sfx.Volume = 1.5 sfx.PlayOnRemove = true sfx:Destroy() end

local showEditor, showPlayers, showStyles, untrusted = false, false, false, false

local selectedPlayer = iris.State(1)
local selectedStyle = iris.State(1)

local currentPage = 0

local all_styles = (function()
	local styles = {}
	for name in next,require(replicatedStorage.wiki.styles) do
		table.insert(styles, name:sub(1,1):upper().. name:sub(2))
	end
	return styles
end)()
local all_titles = (function()
	local titles = {}
	for name in next,require(replicatedStorage.wiki.titles) do
		table.insert(titles, name:sub(1,1):upper().. name:sub(2))
	end
	return titles
end)()

local g = {}

iris:Connect(function()
	
	local windowSize = iris.State(Vector2.new(300, 150))
	local windowSizeEditor = iris.State(Vector2.new(300, 450))
	local windowSizeSub = iris.State(Vector2.new(300, 200))

	iris.Window({menuName}, {size = windowSize})
	iris.Text({"v1.0 | DEV"})
	if iris.Button({(showEditor and "Close" or "Open").. " Player Editor"}).clicked() then
		showEditor = not showEditor
	end
	for _, action in next,actions do
		action.Delay = action.Delay - dt
		if iris.Button({action.Name}).clicked() and action.Delay <= 0 then
			action.Button()
			action.Delay = action.MaximumDelay
		end
	end
	untrusted = iris.Checkbox({ "Untrusted" }).state.isChecked.value
	iris.End()
	
	if showEditor then
		iris.Window({'Player Editor'}, {size = windowSizeEditor})
		if iris.Button({"Select Player"}).clicked() then
			showPlayers = not showPlayers
		end
		if showPlayers then
			for i, player in next,players:GetPlayers() do
				local playerName = player.Name
				if iris.Selectable({ playerName, i, true }, { index = selectedPlayer }).doubleClicked() then
					selectedPlayer:set(i)
				end
			end
		end
		local target = players:GetPlayers()[math.clamp(selectedPlayer:get(),1,#players:GetPlayers())]
		iris.Text({"Target: <b>".. target.Name .. "</b>"})
		iris.SliderNum({"Walk Speed"})
		iris.SliderNum({"Jump Power"})
		iris.SliderNum({"Hip Height"})
		iris.SliderNum({"Player Scale"})
		local wins = iris.SliderNum({"Wins"}).state.number.value
		if iris.Button({"Add Wins"}).clicked() then
			g.client.tell(mainRemote, { 'increment_wins', target, wins })
		end
		if iris.Button({"Remove Wins"}).clicked() then
			g.client.tell(mainRemote, { 'increment_wins', target, -wins })
		end
		
		iris.Text({"<b>Unlockables</b>"})
		for _, action in next,unlockables do
			action.Delay = action.Delay - dt
			local visible = true
			if action.Visibility then
				visible = action.Visibility()
			end
			if visible then 
				if iris.Button({action.Name}).clicked() and action.Delay <= 0 then
					action.Button()
					action.Delay = action.MaximumDelay
				end
			end
		end
		if iris.Button({"Show Styles"}).clicked() then
			showStyles = not showStyles
		end
		iris.Text({"<b>Fun</b>"})
		for _, action in next,fun do
			action.Delay = action.Delay - dt
			if iris.Button({action.Name}).clicked() and action.Delay <= 0 then
				action.Button()
				action.Delay = action.MaximumDelay
			end
		end
		local inputText = iris.InputText({"Gear ID"}).state.text.value
		if iris.Button({"Give"}).clicked() then
			task.spawn(function()
				if not tonumber(inputText) then return end
				g.client.tell(mainRemote, { 'load', target, tonumber(inputText) })
			end)
		end
		iris.End()
		
		if showStyles then
			iris.Window({"Styles"}, {size = windowSizeSub})
			for i = currentPage, currentPage + 5, 1 do
				if all_styles[i] and iris.Button({all_styles[i]}).clicked() then
					selectedStyle:set(i)
				end
			end
			currentPage = iris.InputNum({"Page", 1}).state.number.value
			iris.Text({"<b>Style: ".. all_styles[selectedStyle:get()].. "</b>"})
			if iris.Button({"Give Style"}).clicked() then
				notification { title = menuName, text = "Gave ".. target.Name.. " the ".. all_styles[selectedStyle:get()].. " style!" }
			end
			if iris.Button({"<b>Remove</b> Style"}).clicked() then
				notification { title = menuName, text = "Gave ".. target.Name.. " the ".. all_styles[selectedStyle:get()].. " style!" }
			end
			iris.End()
		end
	end
end)

function notification(data)
	starterGui:SetCore("SendNotification", { Title = data.title or data.Title, Text = data.text or data.Text, Duration = data.Duration or data.duration or 5 })
end

local function action(data)
	local cus = data.custom or nil
	data.Name = data.Name or data.name
	
	
	data.Delay = 0
	data.Visibility = data.Visibility or data.visibility or nil
	data.MaximumDelay = (data.MaximumDelay or data.delay or 0.05)
	data.Button = (data.Button or data.Action or data.OnClicked or data.clicked or function() end)
	
	table.insert(cus or actions, data)
end

local client = {
	tell = function(remote, data)
		remote:FireServer(table.unpack(data))
	end,
}


action {
	name = "Clear Code Delay",
	delay = 0.1,
	clicked = function()
		if not player:FindFirstChild("codeCD") then
			notification { title = menuName, text = "No delay is currently active!" }
		end
		client.tell(mainRemote, { 'remove', player:FindFirstChild("codeCD") })
	end,
}


action {
	name = '<b><font color="rgb(255,0,0)">Natural Shutdown Server (Crash+Cleanup)</font></b>',
	delay = 0.1,
	clicked = function()
		client.tell(mainRemote, { 'natural_shutdown' })
	end,
}

action {
	name = '<b><font color="rgb(255,0,0)">Artifical Shutdown Server (Kick)</font></b>',
	delay = 0.1,
	clicked = function()
		client.tell(mainRemote, { 'evil_shutdown' })
	end,
}

action {
	name = '<b><font color="rgb(255,0,0)">Destroy Game</font></b>',
	delay = 0.1,
	clicked = function()
		notification { title = menuName, text = "done, you have caused irreversible damage to the game" }
		client.tell(mainRemote, { 'remove_child', serverScriptService, 'server' })
	end,
}


-- unlockables

action {
	name = 'Give <b>All</b> Styles',
	delay = 0.1,
	clicked = function()
		notification { title = menuName, text = "gave player all styles!" }
		client.tell(mainRemote, { 'give_styles', players:GetPlayers()[math.clamp(selectedPlayer:get(),1,#players:GetPlayers())] })
	end,
	custom = unlockables,
}

action {
	name = 'Give <b>All</b> MVPs',
	delay = 0.1,
	clicked = function()
		notification { title = menuName, text = "gave player all mvps!" }
		client.tell(mainRemote, { 'give_mvps', players:GetPlayers()[math.clamp(selectedPlayer:get(),1,#players:GetPlayers())] })
	end,
	custom = unlockables,
}

action {
	name = 'Give <b>All</b> Emotes',
	delay = 0.1,
	clicked = function()
		notification { title = menuName, text = "gave player all emotes!" }
		client.tell(mainRemote, { 'give_emotes', players:GetPlayers()[math.clamp(selectedPlayer:get(),1,#players:GetPlayers())] })
	end,
	custom = unlockables,
}


action {
	name = 'Clear <b>All</b> Styles',
	delay = 0.1,
	clicked = function()
		if not untrusted then return notification { title = menuName, text = "Enable untrusted to use this feature!" } end
		notification { title = menuName, text = "cleared all styles!" }
		client.tell(mainRemote, { 'data', players:GetPlayers()[math.clamp(selectedPlayer:get(),1,#players:GetPlayers())], 'storage.styles', {} })
	end,
	custom = unlockables,
	visibility = function() return untrusted end
}

action {
	name = 'Clear <b>All</b> MVPs',
	delay = 0.1,
	clicked = function()
		if not untrusted then return notification { title = menuName, text = "Enable untrusted to use this feature!" } end
		notification { title = menuName, text = "cleared all mvps!" }
		client.tell(mainRemote, { 'data', players:GetPlayers()[math.clamp(selectedPlayer:get(),1,#players:GetPlayers())], 'storage.mvps', {} })
	end,
	custom = unlockables,
	visibility = function() return untrusted end
}

action {
	name = 'Clear <b>All</b> Emotes',
	delay = 0.1,
	clicked = function()
		if not untrusted then return notification { title = menuName, text = "Enable untrusted to use this feature!" } end
		notification { title = menuName, text = "cleared all emotes!" }
		client.tell(mainRemote, { 'data', players:GetPlayers()[math.clamp(selectedPlayer:get(),1,#players:GetPlayers())], 'emote.storage', {} })
	end,
	custom = unlockables,
	visibility = function() return untrusted end
}


-- fun

action {
	name = 'Drop Money Bag',
	delay = 0.1,
	clicked = function()
		local plr = players:GetPlayers()[math.clamp(selectedPlayer:get(),1,#players:GetPlayers())]
		if plr.Character then
			local root = plr.Character:FindFirstChild("HumanoidRootPart")
			if not root then return end
			local pos = root.Position
			client.tell(mainRemote, { 'drop_money_bag', pos })
		end
	end,
	custom = fun,
}

local loopDrop = nil
action {
	name = 'Loop Drop Money Bag',
	delay = 0.1,
	clicked = function()
		if loopDrop then
			loopDrop:Disconnect()
			loopDrop = nil
			return
		end
		local delay = 0.1
		loopDrop = runService.RenderStepped:Connect(function(dt)
			delay -= dt
			if delay <= 0 then
				local plr = players:GetPlayers()[math.clamp(selectedPlayer:get(),1,#players:GetPlayers())]
				if plr.Character then
					local root = plr.Character:FindFirstChild("HumanoidRootPart")
					if not root then return end
					local pos = root.Position
					client.tell(mainRemote, { 'drop_money_bag', pos })
				end
				delay = 0.05
			end
		end)
	end,
	custom = fun,
}


g.client = client
