--!strict

local ServerStorage = game:GetService("ServerStorage");

local IItem = require(ServerStorage.Item.types);
local IToaster = require(script.types);
local IRound = require(ServerStorage.Round.types);

local Toaster = {};

function Toaster.new(properties: IToaster.ToasterProperties, round: IRound.IRound): IToaster.IToaster

  local itemChangedEvent = Instance.new("BindableEvent");
  local toastProcess: thread? = nil;
  local smoke: Smoke? = nil;
  local fire: Fire? = nil;
  local proximityPrompt = script.ProximityPrompt:Clone();

  local function setItem(self: IToaster.IToaster, newItem: IItem.IItem?): ()

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

    if self.item then

      local primaryPart = self.model.PrimaryPart;
      if not primaryPart then

        error("Add a PrimaryPart to the toaster.");

      end;

      local handle = self.model:FindFirstChild("Handle");
      if not handle or not handle:IsA("Model") or not handle.PrimaryPart then

        error(`Define the toaster's "Handle" model, then set its primary part.`);

      end;

      local force = primaryPart.CFrame:VectorToObjectSpace(primaryPart.Position - handle.PrimaryPart.Position) * 1000;
      self.item:drop(handle.PrimaryPart.Position, force);

    end;

    self.item = newItem;

    if self.item then

      toastProcess = task.spawn(function()
      
        while self.item.status ~= "Burnt" do

          task.wait(1);
          self.item:setStatus(if self.item.status == "Cooked" then "Burnt" else "Cooked");
          if self.item.status == "Cooked" then

            proximityPrompt.ActionText = "Cooked to perfection"

          end;

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

      proximityPrompt.ActionText = "raw"

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

      elseif #contestant.inventory > 0 then

        local item = contestant.inventory[#contestant.inventory];
        contestant:removeItemFromInventory(item);
        toaster:setItem(item);

      end;

    end;

  end);

  return toaster;

end;

return Toaster;