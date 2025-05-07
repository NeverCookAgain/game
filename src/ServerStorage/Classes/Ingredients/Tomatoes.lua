--!strict

local ServerStorage = game:GetService("ServerStorage");

local Item = require(ServerStorage.Classes.Item);
local IItem = require(ServerStorage.Classes.Item.types);
local IRound = require(ServerStorage.Classes.Round.types);

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