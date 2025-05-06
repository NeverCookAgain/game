--!strict

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");

local React = require(ReplicatedStorage.Shared.Packages.react);
local ReactRoblox = require(ReplicatedStorage.Shared.Packages["react-roblox"]);
local OrderProgressSection = require(script.OrderProgressSection);

local screenGUI = Instance.new("ScreenGui");
screenGUI.Name = "OrderProgress";
screenGUI.ScreenInsets = Enum.ScreenInsets.None;
screenGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;

local root = ReactRoblox.createRoot(screenGUI);

ReplicatedStorage.Shared.Events.CustomerAssignmentChanged.OnClientEvent:Connect(function(contestant)
  
  if contestant.player ~= Players.LocalPlayer then

    return;

  end;

  screenGUI.Parent = Players.LocalPlayer.PlayerGui;

  local customer = (
    if contestant.assignedCustomerID then 
      ReplicatedStorage.Shared.Functions.GetCustomer:InvokeServer(contestant.assignedCustomerID) 
    else nil
  );

  if customer then

    root:render(React.createElement(OrderProgressSection, {
      customer = customer;
    }));

  else

    root:unmount();

  end;

end);

