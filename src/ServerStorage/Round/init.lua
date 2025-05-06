--!strict

local ServerStorage = game:GetService("ServerStorage");

local IRound = require(script.types);
local IContestant = require(ServerStorage.Contestant.types);
local ICustomer = require(ServerStorage.Customer.types);
local IEvent = require(ServerStorage.Event.types);

local sharedRound: IRound.IRound? = nil;
local sharedRoundChangedBindableEvent: BindableEvent = Instance.new("BindableEvent");
local sharedRoundChangedEvent: RBXScriptSignal<IRound.IRound?> = sharedRoundChangedBindableEvent.Event

local Round = {
  SharedRoundChanged = sharedRoundChangedEvent;
};

function Round.new(properties: IRound.RoundConstructorProperties): IRound.IRound

  local roundChangedEvent = Instance.new("BindableEvent");
  local contestantsChangedEvent = Instance.new("BindableEvent");
  local eventsChangedEvent = Instance.new("BindableEvent");

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

  local function addEvent(self: IRound.IRound, event: IEvent.IEvent): ()

    table.insert(self.events, event);
    eventsChangedEvent:Fire(self.events);

  end;

  local function removeEvent(self: IRound.IRound, event: IEvent.IEvent): ()

    for index = #self.events, 1, -1 do

      if self.events[index] == event then

        table.remove(self.events, index);
        eventsChangedEvent:Fire(self.events);
        break;

      end;

    end;


  end;

  local function findCustomerFromID(self: IRound.IRound, customerID: string): ICustomer.ICustomer?

    for _, customer in self.customers do

      if customer.id == customerID then

        return customer;

      end;

    end;

    return;

  end;

  local round: IRound.IRound = {
    status = properties.status or "Preparing" :: "Preparing";
    contestants = properties.contestants or {};
    customers = properties.customers or {};
    events = properties.events or {};
    addEvent = addEvent;
    addContestant = addContestant;
    findContestantFromPlayer = findContestantFromPlayer;
    findCustomerFromID = findCustomerFromID;
    removeEvent = removeEvent;
    setStatus = setStatus;
    ContestantsChanged = contestantsChangedEvent.Event;
    RoundChanged = roundChangedEvent.Event;
    EventsChanged = eventsChangedEvent.Event;
  };

  return round;

end;

function Round.getFromSharedRound()

  return sharedRound;

end;

function Round.setSharedRound(round: IRound.IRound?): ()

  sharedRound = round;
  sharedRoundChangedBindableEvent:Fire(round);

end;

return Round;