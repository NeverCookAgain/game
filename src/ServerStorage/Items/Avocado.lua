--!strict

local ServerStorage = game:GetService("ServerStorage");

local Item = require(ServerStorage.Item);
local IItem = require(ServerStorage.Item.types);
local IRound = require(ServerStorage.Round.types);

local Avocado = {
  name = "Avocado";
  description = "TBD";
  image = "rbxassetid://72701864119182";
};

function Avocado.new(round: IRound.IRound): IItem.IItem

  return Item.new({
    name = Avocado.name;
    description = Avocado.description;
    image = Avocado.image;
  }, round);

end;

return Avocado;