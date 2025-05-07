--!strict

local ServerStorage = game:GetService("ServerStorage");

local Item = require(ServerStorage.Classes.Item);
local IItem = require(ServerStorage.Classes.Item.types);
local IRound = require(ServerStorage.Classes.Round.types);

local Spinach = {
  name = "Spinach";
  description = "TBD";
  image = "rbxassetid://78528226368164";
};

function Spinach.new(round: IRound.IRound): IItem.IItem

  return Item.new({
    name = Spinach.name;
    description = Spinach.description;
    image = Spinach.image;
  }, round);

end;

return Spinach;