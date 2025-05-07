--!strict

local ServerStorage = game:GetService("ServerStorage");

local Item = require(ServerStorage.Classes.Item);
local IItem = require(ServerStorage.Classes.Item.types);
local IRound = require(ServerStorage.Classes.Round.types);

local WhiteBread = {
  name = "White Bread";
  description = "TBD";
  image = "rbxassetid://118064158632179";
};

function WhiteBread.new(round: IRound.IRound): IItem.IItem

  return Item.new({
    name = WhiteBread.name;
    description = WhiteBread.description;
    image = WhiteBread.image;
  }, round);

end;

return WhiteBread;