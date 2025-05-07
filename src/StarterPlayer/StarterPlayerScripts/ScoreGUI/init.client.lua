--!strict

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");

local React = require(ReplicatedStorage.Shared.Packages.react);
local ReactRoblox = require(ReplicatedStorage.Shared.Packages["react-roblox"]);
local Round = require(ReplicatedStorage.Client.Classes.Round);
local ScoreContainer = require(script.ScoreContainer);

local screenGUI = Instance.new("ScreenGui");
screenGUI.Name = "Timer";
screenGUI.ScreenInsets = Enum.ScreenInsets.None;
screenGUI.Parent = Players.LocalPlayer:WaitForChild("PlayerGui");

local root = ReactRoblox.createRoot(screenGUI);

local function updateGUI()

  local round = Round.getFromServerRound();
  if not round then return; end;

  if round.status == "Ended" then

    root:unmount();
    return;

  end;

  local contestant = round:findContestantFromPlayer(Players.LocalPlayer);
  if not contestant then return; end;

  root:render(React.createElement(ScoreContainer, {
    contestantID = contestant.id;
  }));

end;

ReplicatedStorage.Shared.Events.RoundChanged.OnClientEvent:Connect(updateGUI);
task.spawn(updateGUI);