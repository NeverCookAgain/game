--!strict

local ServerStorage = game:GetService("ServerStorage");

local Item = require(ServerStorage.Classes.Item);
local IItem = require(ServerStorage.Classes.Item.types);
local IRound = require(ServerStorage.Classes.Round.types);

local Peppers = {
  name = "Peppers";
  description = "TBD";
  image = "rbxassetid://78110205863275";
};

function Peppers.new(round: IRound.IRound): IItem.IItem

  return Item.new({
    name = Peppers.name;
    description = Peppers.description;
    image = Peppers.image;
  }, round);

end;

return Peppers;