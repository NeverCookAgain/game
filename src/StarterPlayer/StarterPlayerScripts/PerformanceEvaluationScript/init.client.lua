--!strict

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");

local React = require(ReplicatedStorage.Shared.Packages.react);
local ReactRoblox = require(ReplicatedStorage.Shared.Packages["react-roblox"]);
local PerformanceEvaluationWindow = require(script.PerformanceEvaluationWindow);

local function checkRoundStatus()

  local round = ReplicatedStorage.Shared.Functions.GetRound:InvokeServer();
  if round.status == "Ended" then

    local screenGUI = Instance.new("ScreenGui");
    screenGUI.Name = "PerformanceEvaluationWindow";
    screenGUI.ScreenInsets = Enum.ScreenInsets.None;
    screenGUI.Parent = Players.LocalPlayer.PlayerGui;

    local root = ReactRoblox.createRoot(screenGUI);
    root:render(React.createElement(PerformanceEvaluationWindow, {
      contestants = round.contestants;
    }));

  end;

end;

ReplicatedStorage.Shared.Events.RoundChanged.OnClientEvent:Connect(checkRoundStatus);
task.spawn(checkRoundStatus);