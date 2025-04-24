--!strict

local ServerStorage = game:GetService("ServerStorage");

local Item = require(ServerStorage.Item);
local IItem = require(ServerStorage.Item.types);
local IRound = require(ServerStorage.Round.types);

local Spinach = {
  name = "Spinach";
  description = "TBD";
  image = "";
};

function Spinach.new(round: IRound.IRound): IItem.IItem

  return Item.new({
    name = Spinach.name;
    description = Spinach.description;
    image = Spinach.image;
  }, round);

end;

return Spinach;