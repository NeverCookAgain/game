--!strict

local ServerStorage = game:GetService("ServerStorage");

local Item = require(ServerStorage.Classes.Item);
local IItem = require(ServerStorage.Classes.Item.types);
local IRound = require(ServerStorage.Classes.Round.types);

local Onions = {
  name = "Onions";
  description = "TBD";
  image = "rbxassetid://91758362897629";
};

function Onions.new(round: IRound.IRound): IItem.IItem

  return Item.new({
    name = Onions.name;
    description = Onions.description;
    image = Onions.image;
  }, round);

end;

return Onions;