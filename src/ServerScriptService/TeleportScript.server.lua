--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage");

local PlaceMap = require(ReplicatedStorage.Shared.PlaceMap);

ReplicatedStorage.Shared.Functions.TeleportToMainMenu.OnServerInvoke = function(player: Player)
  
  local teleportService = game:GetService("TeleportService");
  
  teleportService:TeleportAsync(PlaceMap.Outside, {player});
  
end