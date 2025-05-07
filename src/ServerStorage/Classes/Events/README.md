# Events
## Creating an event
All events should extend the [Event](/src/ServerStorage/Event/init.lua) class and return a new event when `ExtendedEvent.new()` is called.  

## Example
Be sure to rename `ExtendedEvent` to something more descriptive. Whatever you name it, make sure it is the same as the file name.

```lua
--!strict

local ServerStorage = game:GetService("ServerStorage");

local Event = require(ServerStorage.Classes.Event);
local IEvent = require(ServerStorage.Classes.Event.types);
local IRound = require(ServerStorage.Classes.Round.types);

local ExtendedEvent = {
  name = "EVENT_NAME";
};

function ExtendedEvent.new(round: IRound.IRound): IEvent.IEvent

  local function start(self: IEvent.IEvent): ()

    -- TODO: Write what happens when this event starts.
    -- For example, do items spawn? Does the lighting go dark?
    -- Blank canvas, baby.

  end;

  local function stop(self: IEvent.IEvent): ()

    -- TODO: Write what happens when this event ends.
    -- Clean up your mess here.

  end;

  return Event.new({
    name = ExtendedEvent.name;
    start = start;
    stop = stop;
  });

end;

return ExtendedEvent;
```