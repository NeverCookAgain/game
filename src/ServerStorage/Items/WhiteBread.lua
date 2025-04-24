--!strict

local ServerStorage = game:GetService("ServerStorage");

local Item = require(ServerStorage.Item);
local IItem = require(ServerStorage.Item.types);
local IRound = require(ServerStorage.Round.types);

local WhiteBread = {
  name = "White Bread";
  description = "TBD";
  image = "";
};

function WhiteBread.new(round: IRound.IRound): IItem.IItem

  return Item.new({
    name = WhiteBread.name;
    description = WhiteBread.description;
    image = WhiteBread.image;
  }, round);

end;

return WhiteBread;