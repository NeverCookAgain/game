--!strict

local ServerStorage = game:GetService("ServerStorage");

local ISandwich = require(script.types);
local IRound = require(ServerStorage.Round.types);

local Item = {};

type ISandwich = ISandwich.ISandwich;

function Item.new(properties: ISandwich.SandwichConstructorProperties, round: IRound.IRound): ISandwich

  local statusChangedEvent = Instance.new("BindableEvent");
  local spinProcess: thread? = nil;
  local triggerEvent: RBXScriptConnection;

  local function setStatus(self: ISandwich, newStatus: ISandwich.Status): ()

    self.status = newStatus;
    statusChangedEvent:Fire();

  end;

  local function createModel(self: ISandwich): Model

    local sandwichModel = script.Sandwich:Clone();
    
    for index, item in self.items do
    
      local part = item.templatePart:Clone();
      part.CFrame = CFrame.Angles(0, 0, math.rad(90)) + sandwichModel.PrimaryPart.CFrame.Position + Vector3.new(0, (index - 1) * 0.1, 0);
      part.Parent = sandwichModel;

      local alignOrientation = part:FindFirstChild("AlignOrientation");
      if alignOrientation then

        alignOrientation:Destroy();

      end;

      local weldConstraint = Instance.new("WeldConstraint");
      weldConstraint.Part0 = part;
      weldConstraint.Part1 = sandwichModel.PrimaryPart;
      weldConstraint.Parent = part;

    end;

    return sandwichModel;

  end;

  local function drop(self: ISandwich, origin: Vector3, direction: Vector3): Model

    local sandwichModel = self:createModel();
    if not sandwichModel.PrimaryPart then

      error("Sandwich model doesn't have a primary part.");

    end;

    local proximityPrompt = sandwichModel.PrimaryPart:FindFirstChild("ProximityPrompt");
    if not proximityPrompt or not proximityPrompt:IsA("ProximityPrompt") then

      error("Proximity prompt not found. Ensure an ItemPart template is in the Item class.");
      
    end;

    proximityPrompt.ObjectText = self.name;
    proximityPrompt.ActionText = if self.status == "Burnt" then "Congratulations" else "Pick it up"

    if triggerEvent then

      triggerEvent:Disconnect();

    end;

    triggerEvent = proximityPrompt.Triggered:Connect(function(player)

      local contestant = round:findContestantFromPlayer(player);
      if contestant then

        triggerEvent:Disconnect();

        if spinProcess then

          task.cancel(spinProcess);
          spinProcess = nil;

        end;

        contestant:addToInventory(self);

      end;
    
    end);

    sandwichModel:MoveTo(origin);
    sandwichModel.Parent = workspace;
    sandwichModel.PrimaryPart:ApplyImpulse(direction);

    task.wait(0.1);

    spinProcess = task.spawn(function()
    
      while task.wait() do

        local alignOrientation = sandwichModel.PrimaryPart:FindFirstChild("AlignOrientation");
        if not alignOrientation or not alignOrientation:IsA("AlignOrientation") then

          warn("An AlignOrientation should be in every dropped item.")
          break;

        end;

        alignOrientation.CFrame = sandwichModel.PrimaryPart.CFrame * CFrame.Angles(0, math.rad(1), 0)

      end;

    end);

    return sandwichModel;

  end;

  local item: ISandwich.ISandwich = {
    type = "Sandwich" :: "Sandwich";
    name = properties.name;
    items = properties.items or {};
    description = properties.description;
    status = properties.status;
    createModel = createModel;
    setStatus = setStatus;
    drop = drop;
    StatusChanged = statusChangedEvent.Event;
  };

  return item;

end;

return Item;