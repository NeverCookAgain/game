--!strict

local ServerStorage = game:GetService("ServerStorage");

local Item = require(ServerStorage.Item);
local IItem = require(ServerStorage.Item.types);
local IRound = require(ServerStorage.Round.types);

local Egg = {
  name = "Egg";
  description = "TBD";
  image = "rbxassetid://83397177132986";
};

function Egg.new(round: IRound.IRound): IItem.IItem

  return Item.new({
    name = Egg.name;
    description = Egg.description;
    image = Egg.image;
  }, round);

end;

return Egg;