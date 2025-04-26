--!strict

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");

local React = require(ReplicatedStorage.Shared.Packages.react);
local ReactRoblox = require(ReplicatedStorage.Shared.Packages["react-roblox"]);
local InventoryContainer = require(script.InventoryContainer);

local screenGUI = Instance.new("ScreenGui");
screenGUI.Name = "Inventory";
screenGUI.ScreenInsets = Enum.ScreenInsets.None;
screenGUI.Parent = Players.LocalPlayer:WaitForChild("PlayerGui");

local root = ReactRoblox.createRoot(screenGUI);
root:render(React.createElement(InventoryContainer, {
  onClose = function()
    root:unmount();
    screenGUI:Destroy();
  end;
}));