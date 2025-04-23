--!strict

local ServerStorage = game:GetService("ServerStorage");

local ISandwichStation = require(script.types);
local IRound = require(ServerStorage.Round.types);
local IItem = require(ServerStorage.Item.types);

local SandwichStation = {};

function SandwichStation.new(properties: ISandwichStation.SandwichStationProperties, round: IRound.IRound): ISandwichStation.ISandwichStation

  local sandwichChangedEvent = Instance.new("BindableEvent");
  local sandwichCompletedEvent = Instance.new("BindableEvent");
  
  local sandwichParts: {BasePart} = {};

  local function updateSandwichModel(self: ISandwichStation.ISandwichStation)

    for _, sandwichPart in sandwichParts do

      sandwichPart:Destroy();

    end;

    sandwichParts = {};

    if not self.model.PrimaryPart then

      error(`Sandwich Station {self.model.Name} must have a PrimaryPart.`);

    end;

    local sandwichModel = self.model:FindFirstChild("Sandwich");
    if not sandwichModel then

      error(`Sandwich Station {self.model.Name} must have a "Sandwich" model.`)

    end;

    sandwichModel:SetAttribute("LatestIngredient", nil);

    for index, item in self.sandwich do

      local itemPart = item.templatePart:Clone();
      itemPart.CFrame = CFrame.Angles(0, 0, math.rad(90)) + self.model.PrimaryPart.CFrame.Position + Vector3.new(0, (index - 1) * 0.1, 0);
      itemPart.Anchored = true;
      itemPart.Parent = self.model:FindFirstChild("Sandwich");
      sandwichModel:SetAttribute("LatestIngredient", item.name);
      table.insert(sandwichParts, itemPart);

    end;
    
  end;

  local function pushItem(self: ISandwichStation.ISandwichStation, item: IItem.IItem): ()

    table.insert(self.sandwich, item);
    self:updateSandwichModel();
    sandwichChangedEvent:Fire();

  end;

  local function popItem(self: ISandwichStation.ISandwichStation): IItem.IItem

    -- Remove the item from the sandwich array.
    local item = self.sandwich[#self.sandwich];
    if not item then

      error(`Sandwich Station {self.model.Name} doesn't have an item to pop.`);

    end;

    table.remove(self.sandwich, #self.sandwich);
    self:updateSandwichModel();
    sandwichChangedEvent:Fire();

    -- Allow any player to get the item.
    local primaryPart = self.model.PrimaryPart;
    if not primaryPart then

      error(`Sandwich Station {self.model.Name} must have a PrimaryPart.`);

    end;

    local force = primaryPart.CFrame:VectorToObjectSpace(primaryPart.Position - primaryPart.Position) * 1000;
    item:drop(primaryPart.CFrame.Position, force);

    return item;

  end;

  local function completeSandwich(self: ISandwichStation.ISandwichStation): {IItem.IItem}

    local sandwich = self.sandwich;
    self.sandwich = {};
    self:updateSandwichModel();

    sandwichCompletedEvent:Fire();

    return sandwich;

  end;

  local toaster: ISandwichStation.ISandwichStation = {
    model = properties.model;
    sandwich = {};
    completeSandwich = completeSandwich;
    pushItem = pushItem;
    popItem = popItem;
    updateSandwichModel = updateSandwichModel;
    SandwichChanged = sandwichChangedEvent.Event;
    SandwichCompleted = sandwichCompletedEvent.Event;
  };

  return toaster;

end;

return SandwichStation;