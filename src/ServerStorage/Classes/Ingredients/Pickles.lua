--!strict

local ServerStorage = game:GetService("ServerStorage");

local Item = require(ServerStorage.Classes.Item);
local IItem = require(ServerStorage.Classes.Item.types);
local IRound = require(ServerStorage.Classes.Round.types);

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