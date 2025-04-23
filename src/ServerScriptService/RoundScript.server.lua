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

ReplicatedStorage.Shared.Functions.GetContestant.OnServerInvoke = function(player)

  local contestant = round:findContestantFromPlayer(player);
  return contestant;

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
  
  player.Character = workspace.CousinRicky;

  local contestant = Contestant.new({
    player = player;
    inventory = {};
    inventorySlots = 2;
    model = player.Character;
  }, round);

  contestant.InventoryChanged:Connect(function()
  
    ReplicatedStorage.Shared.Events.ContestantInventoryChanged:FireClient(player);

  end);

  round:addContestant(contestant);

  task.wait(2);

  contestant:addItemToInventory(Item.new({
    name = "Avocado",
    description = "Test",
    status = "Raw"
  }, round));

end);

ReplicatedStorage.Shared.Functions.ActivateItem.OnServerInvoke = function(player, slot)

  local contestant = round:findContestantFromPlayer(player);
  if contestant then

    local item = contestant.inventory[slot];
    if item then

      contestant:removeItemFromInventory(item);
      
      if contestant.model and contestant.model.PrimaryPart then
        
        item:drop(contestant.model.PrimaryPart.CFrame.Position, -contestant.model.PrimaryPart.CFrame.LookVector * 5);

      end;

    end;

  end;

end;

round:setStatus("Ongoing");

task.delay(round.durationSeconds, function()

  round:setStatus("Ended");

end);