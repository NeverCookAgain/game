--!strict

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerScriptService = game:GetService("ServerScriptService");
local ServerStorage = game:GetService("ServerStorage");

local Contestant = require(ServerStorage.Contestant);
local Item = require(ServerStorage.Item);
local IItem = require(ServerStorage.Item.types);
local Round = require(ServerStorage.Round);

local round = Round.new({
  status = "Preparing";
  contestants = {};
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
    ServerScriptService.SandwichStationScript.Enabled = true;
  
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

  ReplicatedStorage.Shared.Events.RoundChanged:FireAllClients(round);

end);

local function addPlayerAsContestant(player: Player)

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

  while task.wait() do

    if #contestant.inventory < 2 then

      contestant:addToInventory(Item.new({
        name = "Avocado",
        description = "Test",
        image = "rbxassetid://72701864119182",
        status = "Raw" :: IItem.Status
      }, round));

    end;

  end;
  

end;

Players.PlayerAdded:Connect(function(player: Player)
  
  addPlayerAsContestant(player)

end);

for _, player in Players:GetPlayers() do

  coroutine.wrap(addPlayerAsContestant)(player);

end;

ReplicatedStorage.Shared.Functions.ActivateItem.OnServerInvoke = function(player, slot)

  local contestant = round:findContestantFromPlayer(player);
  if contestant then

    local item = contestant.inventory[slot];
    if item then

      contestant:removeFromInventory(item);
      
      if contestant.model and contestant.model.PrimaryPart then
        
        if item.type == "Item" then

          item:drop(contestant.model.PrimaryPart.CFrame.Position, -contestant.model.PrimaryPart.CFrame.LookVector * 5);

        elseif item.type == "Sandwich" then

          item:drop(contestant.model.PrimaryPart.CFrame.Position, -contestant.model.PrimaryPart.CFrame.LookVector * 5);

        end;

      end;

    end;

  end;

end;

local startTimeMilliseconds = DateTime.now().UnixTimestampMillis;
local completionTimeMilliseconds = startTimeMilliseconds + (90 * 1000);
round.startTimeMilliseconds = startTimeMilliseconds;
round.completionTimeMilliseconds = completionTimeMilliseconds;
round:setStatus("Ongoing");

task.delay((completionTimeMilliseconds - startTimeMilliseconds) / 1000, function()

  round:setStatus("Ended");

end);