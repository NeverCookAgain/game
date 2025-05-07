--!strict

local IEvent = require(script.types);

local Event = {};

function Event.new(properties: IEvent.EventConstructorProperties): IEvent.IEvent

  local eventStartedEvent = Instance.new("BindableEvent");
  local eventStoppedEvent = Instance.new("BindableEvent"); 
  
  local function start(self: IEvent.IEvent)

    self.status = "Active";

    properties.start(self);
    eventStartedEvent:Fire();

  end;

  local function stop(self: IEvent.IEvent)

    self.status = "Inactive";

    properties.stop(self);
    eventStoppedEvent:Fire();

  end;

  local event: IEvent.IEvent = {
    type = "Event" :: "Event";
    status = "Inactive" :: "Inactive";
    name = properties.name;
    start = start;
    stop = stop;
    EventStarted = eventStartedEvent.Event;
    EventStopped = eventStoppedEvent.Event;
  };

  return event;

end;

return Event;