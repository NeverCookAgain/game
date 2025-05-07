--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage");

local React = require(ReplicatedStorage.Shared.Packages.react);
local Round = require(ReplicatedStorage.Client.Classes.Round);
local Fonts = require(ReplicatedStorage.Client.Fonts);

local IContestant = require(ReplicatedStorage.Client.Classes.Contestant.types);

type IContestant = IContestant.IContestant;

type Properties = {
  contestantID: string;
}

local function ScoreContainer(properties: Properties)

  local score, setScore = React.useState(0);

  React.useEffect(function()
  
    local function updateScore()

      local round = Round.getFromServerRound();
      if not round then return; end;

      local contestant: IContestant? = round:findChefFromID(properties.contestantID);
      if not contestant then return; end;

      local correct, total = contestant:getOrderAccuracy();
      setScore(correct);

    end;

    task.spawn(updateScore);

    ReplicatedStorage.Shared.Events.ContestantInventoryChanged.OnClientEvent:Connect(updateScore);
    ReplicatedStorage.Shared.Events.RoundChanged.OnClientEvent:Connect(updateScore);
    ReplicatedStorage.Shared.Events.SandwichStationChanged.OnClientEvent:Connect(updateScore);
    ReplicatedStorage.Shared.Events.CustomerAssignmentChanged.OnClientEvent:Connect(updateScore);

  end, {properties.contestantID});

  return React.createElement("TextLabel", {
    AnchorPoint = Vector2.new(0, 1);
    Position = UDim2.new(0, 15, 1, -60);
    BackgroundTransparency = 1;
    Text = `Score: {score}`;
    TextColor3 = Color3.fromRGB(255, 255, 255);
    TextSize = 24;
    FontFace = Fonts.Regular;
    TextXAlignment = Enum.TextXAlignment.Left;
  })

end;

return ScoreContainer;