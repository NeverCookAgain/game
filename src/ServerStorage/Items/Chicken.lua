--!strict

local ServerStorage = game:GetService("ServerStorage");

local Item = require(ServerStorage.Item);
local IItem = require(ServerStorage.Item.types);
local IRound = require(ServerStorage.Round.types);

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