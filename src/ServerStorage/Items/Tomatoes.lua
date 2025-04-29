--!strict

local ServerStorage = game:GetService("ServerStorage");

local Item = require(ServerStorage.Item);
local IItem = require(ServerStorage.Item.types);
local IRound = require(ServerStorage.Round.types);

local Tomatoes = {
  name = "Tomatoes";
  description = "TBD";
  image = "rbxassetid://88812451859977";
};

function Tomatoes.new(round: IRound.IRound): IItem.IItem

  return Item.new({
    name = Tomatoes.name;
    description = Tomatoes.description;
    image = Tomatoes.image;
  }, round);

end;

return Tomatoes;