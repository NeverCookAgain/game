--!strict

local ServerStorage = game:GetService("ServerStorage");

local Item = require(ServerStorage.Classes.Item);
local IItem = require(ServerStorage.Classes.Item.types);
local IRound = require(ServerStorage.Classes.Round.types);

local Chicken = {
  name = "Chicken";
  description = "TBD";
  image = "rbxassetid://74811567255547";
};

function Chicken.new(round: IRound.IRound): IItem.IItem

  return Item.new({
    name = Chicken.name;
    description = Chicken.description;
    image = Chicken.image;
  }, round);

end;

return Chicken;