--!strict

local ServerStorage = game:GetService("ServerStorage");

local Item = require(ServerStorage.Classes.Item);
local IItem = require(ServerStorage.Classes.Item.types);
local IRound = require(ServerStorage.Classes.Round.types);

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