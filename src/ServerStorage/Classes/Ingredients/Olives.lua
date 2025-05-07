--!strict

local ServerStorage = game:GetService("ServerStorage");

local Item = require(ServerStorage.Classes.Item);
local IItem = require(ServerStorage.Classes.Item.types);
local IRound = require(ServerStorage.Classes.Round.types);

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