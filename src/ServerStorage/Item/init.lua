--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage");

local Item = {};
local IItem = require(script.types);

function Item.new(properties: IItem.ItemProperties): IItem.IItem

  local statusChangedEvent = Instance.new("BindableEvent");

  local function setStatus(self: IItem.IItem, newStatus: IItem.Status): ()

    self.status = newStatus;
    ReplicatedStorage.Shared.Events.RoundChanged:FireAllClients(self);
    statusChangedEvent:Fire();

  end;

  local round: IItem.IItem = {
    name = properties.name;
    description = properties.description;
    status = properties.status;
    setStatus = setStatus;
    StatusChanged = statusChangedEvent.Event;
  };

  return round;

end;

return Item;
