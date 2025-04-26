--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage");

ReplicatedStorage.Shared.Functions.TeleportToMainMenu.OnServerInvoke = function(player: Player)
  
  local teleportService = game:GetService("TeleportService");
  local startPlaceID = 85139156311421;
  
  teleportService:TeleportAsync(startPlaceID, {player});
  
end