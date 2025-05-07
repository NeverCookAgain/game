--!strict

local ServerStorage = game:GetService("ServerStorage");

local Item = require(ServerStorage.Classes.Item);
local IItem = require(ServerStorage.Classes.Item.types);
local IRound = require(ServerStorage.Classes.Round.types);

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