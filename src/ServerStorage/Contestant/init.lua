--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage");

local Contestant = {};
local types = require(script.types);

function Contestant.new(properties: types.ContestantProperties): types.Contestant

  local roundChangedEvent = Instance.new("BindableEvent");

  local function setStatus(self: types.Round, newStatus: types.RoundStatus): ()

    self.status = newStatus;
    ReplicatedStorage.Shared.Events.RoundChanged:FireAllClients(self);
    roundChangedEvent:Fire();

  end;

  local contestant: types.Contestant = {
    player = properties.player;
    model = properties.model;
  };

  return contestant;

end;

return Round;