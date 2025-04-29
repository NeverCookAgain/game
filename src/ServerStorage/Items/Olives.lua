--!strict

local ServerStorage = game:GetService("ServerStorage");

local Item = require(ServerStorage.Item);
local IItem = require(ServerStorage.Item.types);
local IRound = require(ServerStorage.Round.types);

local Olives = {
  name = "Olives";
  description = "TBD";
  image = "rbxassetid://111332993818484";
};

function Olives.new(round: IRound.IRound): IItem.IItem

  return Item.new({
    name = Olives.name;
    description = Olives.description;
    image = Olives.image;
  }, round);

end;

return Olives;