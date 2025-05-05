--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage");

local Contestant = require(ReplicatedStorage.Client.Contestant);
local IRound = require(script.types);
local IContestant = require(ReplicatedStorage.Client.Contestant.types);

local Round = {};

function Round.new(properties: IRound.RoundConstructorProperties): IRound.IRound

  local roundChangedEvent = Instance.new("BindableEvent");
  local contestantsChangedEvent = Instance.new("BindableEvent");
  local eventsChangedEvent = Instance.new("BindableEvent");

  local function findContestantFromPlayer(self: IRound.IRound, targetPlayer: Player): IContestant.IContestant?

    for _, contestant in self.contestants do

      if contestant.player == targetPlayer then

        return contestant;

      end;

    end;

    return;

  end;

  local round: IRound.IRound = {
    status = properties.status or "Preparing" :: "Preparing";
    contestants = properties.contestants;
    customers = properties.customers;
    findContestantFromPlayer = findContestantFromPlayer;
    ContestantsChanged = contestantsChangedEvent.Event;
    RoundChanged = roundChangedEvent.Event;
    EventsChanged = eventsChangedEvent.Event;
  };

  return round;

end;

function Round.getFromServerRound(): IRound.IRound?

  local roundData = ReplicatedStorage.Shared.Functions.GetRound:InvokeServer();

  if not roundData then

    return;

  end;

  local contestantData = roundData.contestants;
  roundData.contestants = {};
  local round = Round.new(roundData);

  for index, contestant in contestantData do

    roundData.contestants[index] = Contestant.new(contestant, round);

  end;

  round.contestants = roundData.contestants;

  return round;

end;

return Round;