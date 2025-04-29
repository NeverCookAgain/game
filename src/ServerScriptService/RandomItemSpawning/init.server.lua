--!strict

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerScriptService = game:GetService("ServerScriptService");
local ServerStorage = game:GetService("ServerStorage");

local spatulaModel = workspace:WaitForChild("SpatulaModel");
local kitchenSpawn = workspace:WaitForChild("KitchenSpawn");

local hasSpawnedSpatula = false

local Round = require(ServerStorage.Round);
local round

repeat

  round = Round.getFromSharedRound();
  task.wait();

until round;

while round.status ~= "Ongoing" do

  task.wait();
  hasSpawnedSpatula = true

end;

local function getRandomPoint()
  local size = KitchenSpawn.Size
  local position = KitchenSpawn.Position
  
  local randomX = position.X + math.random(-size.X/2, size.X/2)
  local randomY = position.Y + math.random(-size.Y/2, size.Y/2)
  local randomZ = position.Z + math.random(-size.Z/2, size.Z/2)

  return Vector3.new(randomX,, randomY, randomZ)

end

local newSpatula = spatulaModel:Clone()
newSpatula.Position = getRandomPoint()



