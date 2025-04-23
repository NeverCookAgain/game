--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerStorage = game:GetService("ServerStorage");

local Round = require(ServerStorage.Round);
local Toaster = require(ServerStorage.Toaster);

local round = Round.getFromSharedRound()

while not round and task.wait() do

  round = Round.getFromSharedRound();

end;

if round then

  local toaster = Toaster.new({
    model = workspace:FindFirstChild("Toaster");
  });

  local proximityPrompt = script.ProximityPrompt:Clone();
  proximityPrompt.Parent = toaster.model;

  ReplicatedStorage.Shared.Functions.ActivateToaster.OnServerInvoke = function(activatingPlayer)

    for _, contestant in round.contestants do

      if contestant.player == activatingPlayer then

        if toaster.item then

          toaster:setItem();

        elseif #contestant.inventory > 0 then

          local item = contestant.inventory[#contestant.inventory];
          contestant:removeItemFromInventory(item);
          toaster:setItem(item);

        end;

        break;

      end;

    end;

  end;

  round.RoundChanged:Connect(function()
    
    if round.status == "Ended" then

    end;

  end)

end;