--!strict

local ServerStorage = game:GetService("ServerStorage");

local Item = require(ServerStorage.Item);
local IItem = require(ServerStorage.Item.types);
local IRound = require(ServerStorage.Round.types);

local Pork = {
  name = "Pork";
  description = "TBD";
  image = "rbxassetid://86740092543266";
};

function Pork.new(round: IRound.IRound): IItem.IItem

  return Item.new({
    name = Pork.name;
    description = Pork.description;
    image = Pork.image;
  }, round);

end;

return Pork;