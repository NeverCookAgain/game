--!strict

local ServerStorage = game:GetService("ServerStorage");

local Item = require(ServerStorage.Item);
local IItem = require(ServerStorage.Item.types);
local IRound = require(ServerStorage.Round.types);

local Bacon = {
  name = "Bacon";
  description = "TBD";
  image = "";
};

function Bacon.new(round: IRound.IRound): IItem.IItem

  return Item.new({
    name = Bacon.name;
    description = Bacon.description;
    image = Bacon.image;
  }, round);

end;

return Bacon;