--!strict

local ServerStorage = game:GetService("ServerStorage");

local Item = require(ServerStorage.Item);
local IItem = require(ServerStorage.Item.types);
local IRound = require(ServerStorage.Round.types);

local Lettuce = {
  name = "Lettuce";
  description = "TBD";
  image = "";
};

function Lettuce.new(round: IRound.IRound): IItem.IItem

  return Item.new({
    name = Lettuce.name;
    description = Lettuce.description;
    image = Lettuce.image;
  }, round);

end;

return Lettuce;