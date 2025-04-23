--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage");

local Round = {};
local types = require(script.types);

function Round.new(properties: types.RoundProperties): types.Round

  local roundChangedEvent = Instance.new("BindableEvent");

  local function setStatus(self: types.Round, newStatus: types.RoundStatus): ()

    self.status = newStatus;
    ReplicatedStorage.Shared.Events.RoundChanged:FireAllClients(self);
    roundChangedEvent:Fire();

  end;

  local round: types.Round = {
    status = properties.status;
    durationSeconds = properties.durationSeconds;
    contestants = {};
    setStatus = setStatus;
    RoundChanged = roundChangedEvent.Event;
  };

  return round;

end;

return Round;