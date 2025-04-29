--!strict

local ServerStorage = game:GetService("ServerStorage");

local Item = require(ServerStorage.Item);
local IItem = require(ServerStorage.Item.types);
local IRound = require(ServerStorage.Round.types);

local SwissCheese = {
  name = "Swiss Cheese";
  description = "TBD";
  image = "rbxassetid://117328422027715";
};

function SwissCheese.new(round: IRound.IRound): IItem.IItem

  return Item.new({
    name = SwissCheese.name;
    description = SwissCheese.description;
    image = SwissCheese.image;
  }, round);

end;

return SwissCheese;