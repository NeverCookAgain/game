--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.Shared.Packages.react)
local ReactRoblox = require(ReplicatedStorage.Shared.Packages["react-roblox"])
local RandomItemMessage = require(script.RandomItemMessage);

local RandomItemSpawning = ReplicatedStorage.Shared.Events.RandomItemSpawning

if not RandomItemSpawning then
	warn("RandomItemSpawning RemoteEvent not found!")
	return
end

local screenGUI = Instance.new("ScreenGui")
screenGUI.Name = "RandomItemMsgScreen"
screenGUI.ResetOnSpawn = false
screenGUI.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

local root = ReactRoblox.createRoot(screenGUI)

RandomItemSpawning.OnClientEvent:Connect(function()

  root:render(React.createElement(RandomItemMessage, {
    onClose = function()
      root:unmount();
    end
  }));

end);