--!strict

local ServerStorage = game:GetService("ServerStorage");

local IItem = require(ServerStorage.Item.types);
local IToaster = require(script.types);

local Toaster = {};

function Toaster.new(properties: IToaster.ToasterProperties): IToaster.IToaster

  local itemChangedEvent = Instance.new("BindableEvent");
  local toastProcess: thread? = nil;

  local function setItem(self: IToaster.IToaster, newItem: IItem.IItem?): ()

    if toastProcess then

      task.cancel(toastProcess);

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

          task.wait(3);
          self.item:setStatus(if self.item.status == "Cooked" then "Burnt" else "Cooked");

        end;

      end);

    end;

    itemChangedEvent:Fire();

  end;

  local toaster: IToaster.IToaster = {
    item = properties.item;
    model = properties.model;
    setItem = setItem;
    ItemChanged = itemChangedEvent.Event;
  };

  return toaster;

end;

return Toaster;