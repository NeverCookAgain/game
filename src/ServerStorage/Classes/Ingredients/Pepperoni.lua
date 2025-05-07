--!strict

local ServerStorage = game:GetService("ServerStorage");

local Item = require(ServerStorage.Classes.Item);
local IItem = require(ServerStorage.Classes.Item.types);
local IRound = require(ServerStorage.Classes.Round.types);

local Pepperoni = {
  name = "Pepperoni";
  description = "TBD";
  image = "rbxassetid://103801243347139";
};

function Pepperoni.new(round: IRound.IRound): IItem.IItem

  return Item.new({
    name = Pepperoni.name;
    description = Pepperoni.description;
    image = Pepperoni.image;
  }, round);

end;

return Pepperoni;