--!strict

local ServerStorage = game:GetService("ServerStorage");

local Round = {};
local IRound = require(script.types);
local IContestant = require(ServerStorage.Contestant.types);

local sharedRound: IRound.IRound? = nil;

function Round.new(properties: IRound.RoundProperties): IRound.IRound

  local roundChangedEvent = Instance.new("BindableEvent");
  local contestantsChangedEvent = Instance.new("BindableEvent");

  local function setStatus(self: IRound.IRound, newStatus: IRound.RoundStatus): ()

    self.status = newStatus;
    roundChangedEvent:Fire();

  end;

  local function addContestant(self: IRound.IRound, contestant: IContestant.IContestant)

    table.insert(self.contestants, contestant);
    contestantsChangedEvent:Fire();

  end;

  local function findContestantFromPlayer(self: IRound.IRound, targetPlayer: Player): IContestant.IContestant?

    for _, contestant in self.contestants do

      if contestant.player == targetPlayer then

        return contestant;

      end;

    end;

    return;

  end;

  local round: IRound.IRound = {
    status = properties.status;
    contestants = {};
    addContestant = addContestant;
    setStatus = setStatus;
    findContestantFromPlayer = findContestantFromPlayer;
    ContestantsChanged = contestantsChangedEvent.Event;
    RoundChanged = roundChangedEvent.Event;
  };

  return round;

end;

function Round.getFromSharedRound()

  return sharedRound;

end;

function Round.setSharedRound(round: IRound.IRound?): ()

  sharedRound = round;

end;

return Round;