--!strict

local ServerStorage = game:GetService("ServerStorage");
local ReplicatedStorage = game:GetService("ReplicatedStorage");

local Round = require(ServerStorage.Classes.Round);

ReplicatedStorage.Shared.Functions.DiscardItem.OnServerInvoke = function(player: Player)
  
  local round = Round.getFromSharedRound();
  assert(round, "Round not found.");
  
  local contestant = round:findContestantFromPlayer(player);
  assert(contestant, "Contestant not found.");
  
  if contestant.selectedItem then
    
    contestant:removeFromInventory(contestant.selectedItem);
    
  end;
  
end;