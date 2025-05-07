--!strict

local ServerStorage = game:GetService("ServerStorage");

local Item = require(ServerStorage.Classes.Item);
local IItem = require(ServerStorage.Classes.Item.types);
local IRound = require(ServerStorage.Classes.Round.types);

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