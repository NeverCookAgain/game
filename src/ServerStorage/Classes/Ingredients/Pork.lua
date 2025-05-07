--!strict

local ServerStorage = game:GetService("ServerStorage");

local Item = require(ServerStorage.Classes.Item);
local IItem = require(ServerStorage.Classes.Item.types);
local IRound = require(ServerStorage.Classes.Round.types);

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