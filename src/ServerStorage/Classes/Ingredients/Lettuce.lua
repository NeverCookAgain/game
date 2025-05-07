--!strict

local ServerStorage = game:GetService("ServerStorage");

local Item = require(ServerStorage.Classes.Item);
local IItem = require(ServerStorage.Classes.Item.types);
local IRound = require(ServerStorage.Classes.Round.types);

local Lettuce = {
  name = "Lettuce";
  description = "TBD";
  image = "rbxassetid://116432356075981";
};

function Lettuce.new(round: IRound.IRound): IItem.IItem

  return Item.new({
    name = Lettuce.name;
    description = Lettuce.description;
    image = Lettuce.image;
  }, round);

end;

return Lettuce;