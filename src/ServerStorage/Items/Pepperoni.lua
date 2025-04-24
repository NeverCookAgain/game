--!strict

local ServerStorage = game:GetService("ServerStorage");

local Item = require(ServerStorage.Item);
local IItem = require(ServerStorage.Item.types);
local IRound = require(ServerStorage.Round.types);

local Pepperoni = {
  name = "Pepperoni";
  description = "TBD";
  image = "";
};

function Pepperoni.new(round: IRound.IRound): IItem.IItem

  return Item.new({
    name = Pepperoni.name;
    description = Pepperoni.description;
    image = Pepperoni.image;
  }, round);

end;

return Pepperoni;