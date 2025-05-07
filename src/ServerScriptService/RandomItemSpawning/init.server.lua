--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerStorage = game:GetService("ServerStorage");

local Round = require(ServerStorage.Classes.Round);
local ActionItem = require(ServerStorage.Classes.ActionItem);

local RandomItemSpawningEvent = ReplicatedStorage.Shared.Events.RandomItemSpawning;

local kitchenSpawnPart = workspace:WaitForChild("KitchenSpawn");

local round = Round.getFromSharedRound() or Round.SharedRoundChanged:Wait();
assert(round, "Round not found!");

local function getRandomPoint()

  local size = kitchenSpawnPart.Size
  local position = kitchenSpawnPart.Position

  local randomX = position.X + math.random(-size.X/2, size.X/2)
  local randomY = position.Y + math.random(-size.Y/2, size.Y/2)
  local randomZ = position.Z + math.random(-size.Z/2, size.Z/2)

  return Vector3.new(randomX, randomY, randomZ)

end

local spawnRateSeconds = 4;

while task.wait(spawnRateSeconds) do

  local actionItem = ActionItem.random(round);
  local dropPosition = CFrame.new(getRandomPoint());
  actionItem:drop(dropPosition);
  RandomItemSpawningEvent:FireAllClients()

end
