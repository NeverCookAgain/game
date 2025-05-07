--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage");

local Contestant = require(ReplicatedStorage.Client.Classes.Contestant);
local IRound = require(script.types);
local IContestant = require(ReplicatedStorage.Client.Classes.Contestant.types);

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

  local function findChefFromID(self: IRound.IRound, chefID: string): IContestant.IContestant?

    for _, chef in self.contestants do

      if chef.id == chefID then

        return chef;

      end;

    end;

    return;

  end;

  local round: IRound.IRound = {
    status = properties.status or "Preparing" :: "Preparing";
    contestants = properties.contestants;
    customers = properties.customers;
    findContestantFromPlayer = findContestantFromPlayer;
    findChefFromID = findChefFromID;
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