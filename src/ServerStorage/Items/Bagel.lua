--!strict

local ServerStorage = game:GetService("ServerStorage");

local Item = require(ServerStorage.Item);
local IItem = require(ServerStorage.Item.types);
local IRound = require(ServerStorage.Round.types);

local Bagel = {
  name = "Bagel";
  description = "TBD";
  image = "rbxassetid://79426228348553";
};

function Bagel.new(round: IRound.IRound): IItem.IItem

  return Item.new({
    name = Bagel.name;
    description = Bagel.description;
    image = Bagel.image;
  }, round);

end;

return Bagel;