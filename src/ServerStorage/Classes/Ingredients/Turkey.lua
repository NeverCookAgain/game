--!strict

local ServerStorage = game:GetService("ServerStorage");

local Item = require(ServerStorage.Classes.Item);
local IItem = require(ServerStorage.Classes.Item.types);
local IRound = require(ServerStorage.Classes.Round.types);

local Turkey = {
  name = "Turkey";
  description = "TBD";
  image = "rbxassetid://112885892454420";
};

function Turkey.new(round: IRound.IRound): IItem.IItem

  return Item.new({
    name = Turkey.name;
    description = Turkey.description;
    image = Turkey.image;
  }, round);

end;

return Turkey;