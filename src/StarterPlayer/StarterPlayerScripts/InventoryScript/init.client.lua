--!strict

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");

local Round = require(ReplicatedStorage.Client.Classes.Round);
local React = require(ReplicatedStorage.Shared.Packages.react);
local ReactRoblox = require(ReplicatedStorage.Shared.Packages["react-roblox"]);
local InventoryContainer = require(script.InventoryContainer);
local ActionItemContainer = require(script.ActionItemContainer);

local screenGUI = Instance.new("ScreenGui");
screenGUI.Name = "Inventory";
screenGUI.ScreenInsets = Enum.ScreenInsets.None;
screenGUI.Parent = Players.LocalPlayer:WaitForChild("PlayerGui");

local actionItemGUI = screenGUI:Clone();
actionItemGUI.Name = "ActionItemInventory";
actionItemGUI.Parent = screenGUI.Parent;

local actionItemContainerRoot = ReactRoblox.createRoot(actionItemGUI);
local inventoryContainerRoot = ReactRoblox.createRoot(screenGUI);

local function checkRound()

  local round = Round.getFromServerRound();
  if not round or round.status == "Ended" then

    actionItemContainerRoot:unmount();
    inventoryContainerRoot:unmount();
    screenGUI:Destroy();

  else

    actionItemContainerRoot:render(React.createElement(ActionItemContainer));
    inventoryContainerRoot:render(React.createElement(InventoryContainer));

  end;

end;

ReplicatedStorage.Shared.Events.RoundChanged.OnClientEvent:Connect(checkRound);
checkRound();