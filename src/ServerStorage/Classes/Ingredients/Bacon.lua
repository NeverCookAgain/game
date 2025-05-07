--!strict

local ServerStorage = game:GetService("ServerStorage");

local Item = require(ServerStorage.Classes.Item);
local IItem = require(ServerStorage.Classes.Item.types);
local IRound = require(ServerStorage.Classes.Round.types);

local Bacon = {
  name = "Bacon";
  description = "TBD";
  image = "rbxassetid://119291517667506";
};

function Bacon.new(round: IRound.IRound): IItem.IItem

  return Item.new({
    name = Bacon.name;
    description = Bacon.description;
    image = Bacon.image;
  }, round);

end;

return Bacon;