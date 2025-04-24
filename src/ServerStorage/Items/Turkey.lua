--!strict

local ServerStorage = game:GetService("ServerStorage");

local Item = require(ServerStorage.Item);
local IItem = require(ServerStorage.Item.types);
local IRound = require(ServerStorage.Round.types);

local Turkey = {
  name = "Turkey";
  description = "TBD";
  image = "";
};

function Turkey.new(round: IRound.IRound): IItem.IItem

  return Item.new({
    name = Turkey.name;
    description = Turkey.description;
    image = Turkey.image;
  }, round);

end;

return Turkey;