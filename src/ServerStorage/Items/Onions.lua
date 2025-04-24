--!strict

local ServerStorage = game:GetService("ServerStorage");

local Item = require(ServerStorage.Item);
local IItem = require(ServerStorage.Item.types);
local IRound = require(ServerStorage.Round.types);

local Onions = {
  name = "Onions";
  description = "TBD";
  image = "";
};

function Onions.new(round: IRound.IRound): IItem.IItem

  return Item.new({
    name = Onions.name;
    description = Onions.description;
    image = Onions.image;
  }, round);

end;

return Onions;