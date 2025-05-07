--!strict

local ServerStorage = game:GetService("ServerStorage");

local IItem = require(script.types);
local IRound = require(ServerStorage.Round.types);

local Item = {};

function Item.new(properties: IItem.ItemProperties, round: IRound.IRound): IItem.IItem

  local statusChangedEvent = Instance.new("BindableEvent");

  local function setStatus(self: IItem.IItem, newStatus: IItem.Status): ()

    self.status = newStatus;
    statusChangedEvent:Fire();

  end;

  local item: IItem.IItem = {
    type = "Item" :: "Item";
    name = properties.name;
    description = properties.description;
    status = properties.status;
    setStatus = setStatus;
    StatusChanged = statusChangedEvent.Event;
  };

  return item;

end;

return Item;