--!strict

local ServerStorage = game:GetService("ServerStorage");

local Item = require(ServerStorage.Item);
local IItem = require(ServerStorage.Item.types);
local IRound = require(ServerStorage.Round.types);

local Beef = {
  name = "Beef";
  description = "TBD";
  image = "";
};

function Beef.new(round: IRound.IRound): IItem.IItem

  return Item.new({
    name = Beef.name;
    description = Beef.description;
    image = Beef.image;
  }, round);

end;

return Beef;