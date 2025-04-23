--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage");

local Round = {};
local IRound = require(script.types);

function Round.new(properties: IRound.RoundProperties): IRound.IRound

  local roundChangedEvent = Instance.new("BindableEvent");

  local function setStatus(self: IRound.IRound, newStatus: IRound.RoundStatus): ()

    self.status = newStatus;
    ReplicatedStorage.Shared.Events.RoundChanged:FireAllClients(self);
    roundChangedEvent:Fire();

  end;

  local round: IRound.IRound = {
    status = properties.status;
    durationSeconds = properties.durationSeconds;
    contestants = {};
    setStatus = setStatus;
    RoundChanged = roundChangedEvent.Event;
  };

  return round;

end;

return Round;