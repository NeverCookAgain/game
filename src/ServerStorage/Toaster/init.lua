--!strict

local ServerStorage = game:GetService("ServerStorage");

local IItem = require(ServerStorage.Item.types);
local IToaster = require(script.types);
local IRound = require(ServerStorage.Round.types);
local ISandwich = require(ServerStorage.Sandwich.types);

local Toaster = {};

function Toaster.new(properties: IToaster.ToasterProperties, round: IRound.IRound): IToaster.IToaster

  local itemChangedEvent = Instance.new("BindableEvent");
  local toastProcess: thread? = nil;
  local smoke: Smoke? = nil;
  local fire: Fire? = nil;
  local proximityPrompt = script.ProximityPrompt:Clone();
  local humSound: Sound? = nil;

  local function setItem(self: IToaster.IToaster, newItem: (IItem.IItem | ISandwich.ISandwich)?): ()

    if toastProcess then

      task.cancel(toastProcess);
      toastProcess = nil;

    end;

    if smoke then

      smoke:Destroy();
      smoke = nil

    end;

    if fire then

      fire:Destroy();
      fire = nil;

    end;

    if humSound then

      humSound:Destroy();
      humSound = nil;

    end;

    if self.item then

      local primaryPart = self.model.PrimaryPart;
      if not primaryPart then

        error("Add a PrimaryPart to the toaster.");

      end;

      local handle = self.model:FindFirstChild("Handle");
      if not handle or not handle:IsA("Model") or not handle.PrimaryPart then

        error(`Define the toaster's "Handle" model, then set its primary part.`);

      end;

      local force = primaryPart.CFrame:VectorToObjectSpace(primaryPart.Position - handle.PrimaryPart.Position) * 1;

      if self.item.type == "Sandwich" then

        self.item:drop(handle.PrimaryPart.CFrame, Vector3.zero);

      else

        self.item:drop(handle.PrimaryPart.CFrame, force);

      end;

    end;

    self.item = newItem;

    if self.item then

      local newHumSound = Instance.new("Sound");
      newHumSound.SoundId = `rbxassetid://4817657002`;
      newHumSound.Parent = self.model.PrimaryPart;
      newHumSound.Looped = true;
      newHumSound.PlaybackRegionsEnabled = true;
      newHumSound.LoopRegion = NumberRange.new(2, 3);
      newHumSound.Volume = 0.2;
      newHumSound:Play();
      humSound = newHumSound;

      toastProcess = task.spawn(function()
        
        proximityPrompt.ActionText = "raw";
        if self.item.type == "Item" then

          while self.item.status ~= "Burnt" do

            task.wait(1);
            self.item:setStatus(if self.item.status == "Cooked" then "Burnt" else "Cooked");
            if self.item.status == "Cooked" then

              proximityPrompt.ActionText = "Cooked to perfection"

            end;

          end;

        elseif self.item.type == "Sandwich" then

          local uncookedItems = {};
          local highestStatus = "Raw";
          repeat

            uncookedItems = {};

            for _, item in self.item.items do
              
              if (highestStatus == "Raw" and item.status == "Cooked") or (highestStatus == "Cooked" and item.status == "Burnt") then

                highestStatus = item.status;
                proximityPrompt.ActionText = item.status;

              end;

              if item.status ~= "Burnt" then

                table.insert(uncookedItems, item);

              end;

            end;

            if uncookedItems[1] then
              
              task.wait(1)

              for _, uncookedItem in uncookedItems do

                if uncookedItem.status ~= "Burnt" then
      
                  uncookedItem:setStatus(if uncookedItem.status == "Cooked" then "Burnt" else "Cooked");

                end;

              end;

            end;

          until #uncookedItems == 0;

        end;

        proximityPrompt.ActionText = "it's over"

        local newSmoke = Instance.new("Smoke");
        newSmoke.Color = Color3.new(0, 0, 0);
        newSmoke.Parent = self.model.PrimaryPart;
        smoke = newSmoke;

        task.wait(6);
        
        proximityPrompt.ActionText = "bro IT'S DONE"

        local newFire = Instance.new("Fire");
        newFire.Heat = 25;
        newFire.Parent = self.model.PrimaryPart;
        fire = newFire;

      end);

    else

      local sound = Instance.new("Sound");
      sound.SoundId = `rbxassetid://317553816`;
      sound.Parent = self.model;
      sound.PlaybackSpeed = 0.96;
      sound.Volume = 0.4;
      sound:Play();
      
      proximityPrompt.ActionText = "Put 'er in"

    end;

    itemChangedEvent:Fire();

  end;

  local toaster: IToaster.IToaster = {
    item = properties.item;
    model = properties.model;
    setItem = setItem;
    ItemChanged = itemChangedEvent.Event;
  };
  
  proximityPrompt.ActionText = "Put 'er in"
  proximityPrompt.Parent = toaster.model;
  proximityPrompt.Triggered:Connect(function(activatingPlayer: Player)
  
    local contestant = round:findContestantFromPlayer(activatingPlayer);
    if contestant then

      if toaster.item then

        toaster:setItem();

      elseif contestant.selectedItem then

        local item = contestant.selectedItem;
        contestant:removeFromInventory(item);
        toaster:setItem(item);

      end;

    end;

  end);

  return toaster;

end;

return Toaster;