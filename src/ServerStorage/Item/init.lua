--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage");

local Item = {};
local types = require(script.types);

function Item.new(properties: types.ItemProperties): types.Item

  local statusChangedEvent = Instance.new("BindableEvent");

  local function setStatus(self: types.Item, newStatus: types.Status): ()

    self.status = newStatus;
    ReplicatedStorage.Shared.Events.RoundChanged:FireAllClients(self);
    statusChangedEvent:Fire();

  end;

  local round: types.Item = {
    name = properties.name;
    description = properties.description;
    status = properties.status;
    setStatus = setStatus;
    StatusChanged = statusChangedEvent.Event;
  };

  return round;

end;

return Item;