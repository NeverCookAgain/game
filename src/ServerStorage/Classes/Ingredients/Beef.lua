--!strict

local ServerStorage = game:GetService("ServerStorage");

local Item = require(ServerStorage.Classes.Item);
local IItem = require(ServerStorage.Classes.Item.types);
local IRound = require(ServerStorage.Classes.Round.types);

local Beef = {
  name = "Beef";
  description = "TBD";
  image = "rbxassetid://110348306333661";
};

function Beef.new(round: IRound.IRound): IItem.IItem

  return Item.new({
    name = Beef.name;
    description = Beef.description;
    image = Beef.image;
  }, round);

end;

return Beef;