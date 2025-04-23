--!strict

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerScriptService = game:GetService("ServerScriptService");
local ServerStorage = game:GetService("ServerStorage");

local Contestant = require(ServerStorage.Contestant);
local Item = require(ServerStorage.Item);
local Round = require(ServerStorage.Round);

local round = Round.new({
  status = "Preparing";
  contestants = {};
  durationSeconds = 2;
});

Round.setSharedRound(round);

ReplicatedStorage.Shared.Functions.GetRound.OnServerInvoke = function()

  return round;

end;

round.RoundChanged:Connect(function()

  if round.status == "Ongoing" then

    ServerScriptService.ToasterScript.Enabled = true;
  
  elseif round.status == "Ended" then
    
    local roundEndSound = Instance.new("Sound");
    roundEndSound.Name = "RoundEndSound";
    roundEndSound.SoundId = "rbxassetid://9113087676";
    roundEndSound.Parent = workspace;
    roundEndSound.Ended:Once(function()
    
      roundEndSound:Destroy();

    end);
    roundEndSound:Play();

  end;

end);

Players.PlayerAdded:Connect(function(player: Player)

  local contestant = Contestant.new({
    player = player;
    inventory = {};
  }, round);

  round:addContestant(contestant);
  player.Character = workspace.CousinRicky;

  task.wait(2);

  contestant:addItemToInventory(Item.new({
    name = "Avocado",
    description = "Test",
    status = "Raw"
  }, round));

end);

round:setStatus("Ongoing");

task.delay(round.durationSeconds, function()

  round:setStatus("Ended");

end);