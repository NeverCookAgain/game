--!strict

local ServerStorage = game:GetService("ServerStorage");

local ISandwichStation = require(script.types);
local IRound = require(ServerStorage.Round.types);
local IItem = require(ServerStorage.Item.types);

local SandwichStation = {};

function SandwichStation.new(properties: ISandwichStation.SandwichStationProperties, round: IRound.IRound): ISandwichStation.ISandwichStation

  local sandwichChangedEvent = Instance.new("BindableEvent");
  local sandwichCompletedEvent = Instance.new("BindableEvent");

  local function pushItem(self: ISandwichStation.ISandwichStation, item: IItem.IItem): ()

    table.insert(self.sandwich, item);
    sandwichChangedEvent:Fire();

  end;

  local function popItem(self: ISandwichStation.ISandwichStation): IItem.IItem

    local item = self.sandwich[#self.sandwich];
    table.remove(self.sandwich, #self.sandwich);

    local primaryPart = self.model.PrimaryPart;
    local force = primaryPart.CFrame:VectorToObjectSpace(primaryPart.Position - primaryPart.Position) * 1000;
    item:drop(primaryPart.CFrame.Position, force);

    sandwichChangedEvent:Fire();

    return item;

  end;

  local function completeSandwich(self: ISandwichStation.ISandwichStation): {IItem.IItem}

    local sandwich = self.sandwich;
    self.sandwich = {};

    sandwichCompletedEvent:Fire();

    return sandwich;

  end;

  local toaster: ISandwichStation.ISandwichStation = {
    model = properties.model;
    sandwich = {};
    pushItem = pushItem;
    popItem = popItem;
    completeSandwich = completeSandwich;
    SandwichChanged = sandwichChangedEvent.Event;
    SandwichCompleted = sandwichCompletedEvent.Event;
  };

  return toaster;

end;

return SandwichStation;