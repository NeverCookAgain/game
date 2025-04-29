--!strict

local ServerStorage = game:GetService("ServerStorage");

local Item = require(ServerStorage.Item);
local IItem = require(ServerStorage.Item.types);
local IRound = require(ServerStorage.Round.types);

local Pickles = {
  name = "Pickles";
  description = "TBD";
  image = "rbxassetid://110605712267450";
};

function Pickles.new(round: IRound.IRound): IItem.IItem

  return Item.new({
    name = Pickles.name;
    description = Pickles.description;
    image = Pickles.image;
  }, round);

end;

return Pickles;