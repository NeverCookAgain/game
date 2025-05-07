--!strict

local ServerStorage = game:GetService("ServerStorage");

local ISandwich = require(script.types);
local IRound = require(ServerStorage.Round.types);

local Sandwich = {};

type ISandwich = ISandwich.ISandwich;

function Sandwich.new(properties: ISandwich.SandwichConstructorProperties, round: IRound.IRound): ISandwich

  local statusChangedEvent = Instance.new("BindableEvent");
  local spinProcess: thread? = nil;
  local triggerEvent: RBXScriptConnection;

  local function createModel(self: ISandwich): Model

    local sandwichModel = script.Sandwich:Clone();
    
    for index, item in self.items do
    
      local part = item:createPart();
      part.CFrame = CFrame.Angles(0, 0, math.rad(90)) + sandwichModel.PrimaryPart.CFrame.Position + Vector3.new(0, (index - 1) * 0.1, 0);
      part.Parent = sandwichModel;

      local alignOrientation = part:FindFirstChild("AlignOrientation");
      if alignOrientation then

        alignOrientation:Destroy();

      end;

      local proximityPrompt = part:FindFirstChild("ProximityPrompt");
      if proximityPrompt and proximityPrompt:IsA("ProximityPrompt") then

        proximityPrompt.Enabled = false;

      end;

      local weldConstraint = Instance.new("WeldConstraint");
      weldConstraint.Part0 = part;
      weldConstraint.Part1 = sandwichModel.PrimaryPart;
      weldConstraint.Parent = part;

    end;

    return sandwichModel;

  end;

  local function drop(self: ISandwich, origin: CFrame, direction: Vector3): Model

    local sandwichModel = self:createModel();
    if not sandwichModel.PrimaryPart then

      error("Sandwich model doesn't have a primary part.");

    end;

    local proximityPrompt = sandwichModel.PrimaryPart:FindFirstChild("ProximityPrompt");
    if not proximityPrompt or not proximityPrompt:IsA("ProximityPrompt") then

      error("Proximity prompt not found. Ensure an ItemPart template is in the Item class.");
      
    end;

    proximityPrompt.Enabled = true;
    proximityPrompt.ObjectText = self.name;
    proximityPrompt.ActionText = "Pick it up";

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

        local soundPart = Instance.new("Part");
        soundPart.Transparency = 1;
        soundPart.Anchored = true;
        soundPart.CanCollide = false;
        soundPart.CFrame = sandwichModel.PrimaryPart.CFrame;
        soundPart.Parent = workspace;
        
        local sound = Instance.new("Sound");
        sound.SoundId = "rbxassetid://6324790483";
        sound.Parent = soundPart;
        sound.Volume = 0.6;
        sound.Ended:Once(function()
        
          soundPart:Destroy();
          sound:Destroy();

        end);
        sound:Play();

        sandwichModel:Destroy();
        contestant:addToInventory(self);

      end;
    
    end);

    sandwichModel:PivotTo(origin);
    sandwichModel.Parent = workspace;
    sandwichModel.PrimaryPart:ApplyImpulse(direction);

    return sandwichModel;

  end;

  local item: ISandwich.ISandwich = {
    type = "Sandwich" :: "Sandwich";
    name = properties.name;
    items = properties.items or {};
    createModel = createModel;
    drop = drop;
    StatusChanged = statusChangedEvent.Event;
  };

  return item;

end;

return Sandwich;