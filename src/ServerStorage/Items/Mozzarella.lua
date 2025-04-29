--!strict

local ServerStorage = game:GetService("ServerStorage");

local Item = require(ServerStorage.Item);
local IItem = require(ServerStorage.Item.types);
local IRound = require(ServerStorage.Round.types);

local Mozzarella = {
  name = "Mozzarella";
  description = "TBD";
  image = "rbxassetid://102197708436798";
};

function Mozzarella.new(round: IRound.IRound): IItem.IItem

  return Item.new({
    name = Mozzarella.name;
    description = Mozzarella.description;
    image = Mozzarella.image;
  }, round);

end;

return Mozzarella;