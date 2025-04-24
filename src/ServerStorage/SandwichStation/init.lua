--!strict

local ServerStorage = game:GetService("ServerStorage");

local ISandwich = require(ServerStorage.Sandwich.types);
local ISandwichStation = require(script.types);
local IRound = require(ServerStorage.Round.types);
local IItem = require(ServerStorage.Item.types);
local Sandwich = require(ServerStorage.Sandwich);

local SandwichStation = {};

function SandwichStation.new(properties: ISandwichStation.SandwichStationProperties, round: IRound.IRound): ISandwichStation.ISandwichStation

  local sandwichChangedEvent = Instance.new("BindableEvent");
  local sandwichCompletedEvent = Instance.new("BindableEvent");
  
  local sandwichModel: Model? = nil;

  local function updateSandwichModel(self: ISandwichStation.ISandwichStation)

    if not self.model.PrimaryPart then

      error(`Sandwich Station {self.model.Name} must have a PrimaryPart.`);

    end;

    local sandwichLocationPart = self.model:FindFirstChild("SandwichLocation");
    if not sandwichLocationPart then

      error(`Sandwich Station {self.model.Name} must have a "Sandwich" model.`)

    end;

    if sandwichModel then

      sandwichModel:Destroy();
      sandwichModel = nil;

    end;

    if self.sandwich then

      local newSandwichModel = self.sandwich:createModel();
      sandwichModel = newSandwichModel;
      newSandwichModel:SetAttribute("LatestIngredient", nil);
      newSandwichModel:PivotTo(self.model.PrimaryPart.CFrame);
      newSandwichModel.Parent = self.model;

      -- for index, item in self.sandwich.items do

      --   local itemPart = item.templatePart:Clone();
      --   itemPart.CFrame = CFrame.Angles(0, 0, math.rad(90)) + self.model.PrimaryPart.CFrame.Position + Vector3.new(0, (index - 1) * 0.1, 0);
      --   itemPart.Anchored = true;
      --   itemPart.Parent = self.model:FindFirstChild("Sandwich");
      --   sandwichModel:SetAttribute("LatestIngredient", item.name);
      --   table.insert(sandwichParts, itemPart);

      -- end;

    end;
    
  end;

  local function pushItem(self: ISandwichStation.ISandwichStation, item: IItem.IItem | ISandwich.ISandwich): ()

    local sandwich;
    if item.type == "Sandwich" then
      
      sandwich = item;

    else 
      
      sandwich = self.sandwich or Sandwich.new({
        name = "Sandwich";
        description = "Test";
        status = "Raw" :: "Raw"
      }, round);
      
      table.insert(sandwich.items, item);

    end;

    self.sandwich = sandwich;
    self:updateSandwichModel();
    sandwichChangedEvent:Fire();

  end;

  local function popItem(self: ISandwichStation.ISandwichStation): IItem.IItem

    if not self.sandwich then

      error("No sandwich available.");

    end;

    -- Remove the item from the sandwich array.
    local item = self.sandwich.items[#self.sandwich.items];
    if not item then

      error(`Sandwich Station {self.model.Name} doesn't have an item to pop.`);

    end;

    table.remove(self.sandwich.items, #self.sandwich.items);
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

  local function completeSandwich(self: ISandwichStation.ISandwichStation): ISandwich.ISandwich

    local sandwich = self.sandwich;
    if not sandwich then

      error("There's no available sandwich yet.");
      
    end;

    self.sandwich = nil;
    self:updateSandwichModel();

    sandwichCompletedEvent:Fire();

    return sandwich;

  end;

  local toaster: ISandwichStation.ISandwichStation = {
    model = properties.model;
    sandwich = properties.sandwich;
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