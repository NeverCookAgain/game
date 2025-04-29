--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.Shared.Packages.react)
local ReactRoblox = require(ReplicatedStorage.Shared.Packages["react-roblox"])

local FridgeContainer = require(script.FridgeContainer)



local fridges = workspace.Restaurant:WaitForChild("Fridges")
local proximityPromptTemplate = script:WaitForChild("ProximityPrompt")
local events: {RBXScriptConnection} = {}

local screenGUI = Instance.new("ScreenGui")
screenGUI.Name = "FridgeScreen"
screenGUI.ResetOnSpawn = false
screenGUI.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
screenGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGUI.ScreenInsets = Enum.ScreenInsets.None;
local root = ReactRoblox.createRoot(screenGUI);

local function setupProximityPrompts()
	
	for _, conn in events do
		conn:Disconnect()
	end
	table.clear(events)

	for _, fridge in fridges:GetChildren() do

    local fridgePart = fridge.PrimaryPart;

		if fridgePart:IsA("BasePart") then
			for _, child in fridgePart:GetChildren() do
				if child:IsA("ProximityPrompt") then
					child:Destroy()
				end
			end

			local prompt = proximityPromptTemplate:Clone()
			prompt.Parent = fridgePart
			prompt.ActionText = "Open Fridge"
			prompt.KeyboardKeyCode = Enum.KeyCode.E
			prompt.UIOffset = Vector2.new(0, 100)
			prompt.Triggered:Connect(function()
			
				root:render(React.createElement(FridgeContainer, {
          startOpen = true;
					onClose = function()

						root:unmount();

					end;
        }))

			end);

			table.insert(events, connection)
		end
	end
end

setupProximityPrompts()
