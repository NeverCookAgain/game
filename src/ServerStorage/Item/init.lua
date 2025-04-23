--!strict

local ServerStorage = game:GetService("ServerStorage");

local IItem = require(script.types);
local IRound = require(ServerStorage.Round.types);

local Item = {};

function Item.new(properties: IItem.ItemProperties, round: IRound.IRound): IItem.IItem

  local statusChangedEvent = Instance.new("BindableEvent");
  local spinProcess: thread? = nil;

  local function setStatus(self: IItem.IItem, newStatus: IItem.Status): ()

    self.status = newStatus;
    statusChangedEvent:Fire();

  end;

  local function drop(self: IItem.IItem, origin: Vector3, direction: Vector3)

    if not self.part then

      self.part = script.ItemPart:Clone();

    end;

    if self.part then

      local proximityPrompt = self.part:FindFirstChild("ProximityPrompt");
      if not proximityPrompt or not proximityPrompt:IsA("ProximityPrompt") then

        error("Proximity prompt not found. Ensure an ItemPart template is in the Item class.");
        
      end;

      proximityPrompt.Triggered:Connect(function(player)

        local contestant = round:findContestantFromPlayer(player);
        if contestant then

          if spinProcess then

            task.cancel(spinProcess);
            spinProcess = nil;

          end;

          self.part:Destroy();
          contestant:addItemToInventory(self);

        end;
      
      end);

      self.part.Position = origin;
      self.part.Parent = workspace;
      self.part:ApplyImpulse(direction);

      task.wait(0.1);

      spinProcess = task.spawn(function()
      
        while task.wait() do

          local alignOrientation = self.part:FindFirstChild("AlignOrientation");
          if not alignOrientation or not alignOrientation:IsA("AlignOrientation") then

            warn("An AlignOrientation should be in every dropped item.")
            break;

          end;

          alignOrientation.CFrame = self.part.CFrame * CFrame.Angles(0, math.rad(1), 0)

        end;

      end);

    end;

  end;

  local item: IItem.IItem = {
    name = properties.name;
    description = properties.description;
    status = properties.status;
    setStatus = setStatus;
    drop = drop;
    StatusChanged = statusChangedEvent.Event;
  };

  return item;

end;

return Item;