--!strict

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");

local React = require(ReplicatedStorage.Shared.Packages.react);
local ReactRoblox = require(ReplicatedStorage.Shared.Packages["react-roblox"]);
local Round = require(ReplicatedStorage.Client.Round);

local PerformanceEvaluationWindow = require(script.PerformanceEvaluationWindow);

local function checkRoundStatus()

  local round = Round.getFromServerRound();
  if not round then

    return;

  end;

  if round.status == "Ended" then

    local screenGUI = Instance.new("ScreenGui");
    screenGUI.Name = "PerformanceEvaluationWindow";
    screenGUI.ScreenInsets = Enum.ScreenInsets.None;
    screenGUI.Parent = Players.LocalPlayer.PlayerGui;
    screenGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;

    local root = ReactRoblox.createRoot(screenGUI);
    root:render(React.createElement(PerformanceEvaluationWindow, {
      contestants = round.contestants;
    }));

  end;

end;

ReplicatedStorage.Shared.Events.RoundChanged.OnClientEvent:Connect(checkRoundStatus);
task.spawn(checkRoundStatus);