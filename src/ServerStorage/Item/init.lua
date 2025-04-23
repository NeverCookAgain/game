--!strict

local ServerStorage = game:GetService("ServerStorage");

local IItem = require(script.types);
local IRound = require(ServerStorage.Round.types);

local Item = {};

function Item.new(properties: IItem.ItemConstructorProperties, round: IRound.IRound): IItem.IItem

  local statusChangedEvent = Instance.new("BindableEvent");
  local spinProcess: thread? = nil;
  local triggerEvent: RBXScriptConnection;

  local function setStatus(self: IItem.IItem, newStatus: IItem.Status): ()

    self.status = newStatus;
    statusChangedEvent:Fire();

  end;

  local function drop(self: IItem.IItem, origin: Vector3, direction: Vector3): BasePart

    local part = self.part or self.templatePart:Clone();
    self.part = part;

    local function setGUIEffect(instance: Instance?)
      
      if instance and instance:IsA("SurfaceGui") then

        local ingredientImageLabel = instance:FindFirstChild("IngredientImageLabel");
        if ingredientImageLabel and ingredientImageLabel:IsA("ImageLabel") then

          ingredientImageLabel.ImageColor3 = if self.status == "Burnt" then Color3.fromRGB(20, 20, 20) elseif self.status == "Cooked" then Color3.fromRGB(230, 208, 114) else Color3.new(1, 1, 1);

        end;

      end;

    end;

    local backGUI = part:FindFirstChild("BackGUI");
    local frontGUI = part:FindFirstChild("FrontGUI");
    setGUIEffect(backGUI);
    setGUIEffect(frontGUI);

    local proximityPrompt = part:FindFirstChild("ProximityPrompt");
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

        part:Destroy();
        self.part = nil;
        contestant:addItemToInventory(self);

      end;
    
    end);

    part.Position = origin;
    part.Parent = workspace;
    part:SetNetworkOwner();
    part:ApplyImpulse(direction);

    task.wait(0.1);

    spinProcess = task.spawn(function()
    
      while task.wait() do

        local alignOrientation = part:FindFirstChild("AlignOrientation");
        if not alignOrientation or not alignOrientation:IsA("AlignOrientation") then

          warn("An AlignOrientation should be in every dropped item.")
          break;

        end;

        alignOrientation.CFrame = part.CFrame * CFrame.Angles(0, math.rad(1), 0)

      end;

    end);

    return part;

  end;

  local templatePart = properties.templatePart or script.Part;
  local function updateImages(surfaceGUI: SurfaceGui?)

    if not surfaceGUI then

      error("SurfaceGUI required.");

    end;

    local itemImageLabel = surfaceGUI:FindFirstChild("ItemImageLabel");
    if not itemImageLabel or not itemImageLabel:IsA("ImageLabel") then

      error(`{surfaceGUI.Name} needs an "ItemImageLabel".`);

    end;

    itemImageLabel.Image = properties.image;
    
  end;
  
  local backGUI = templatePart:FindFirstChild("BackGUI");
  local frontGUI = templatePart:FindFirstChild("FrontGUI");
  updateImages(backGUI);
  updateImages(frontGUI);

  local item: IItem.IItem = {
    name = properties.name;
    description = properties.description;
    image = properties.image;
    status = properties.status;
    templatePart = templatePart;
    setStatus = setStatus;
    drop = drop;
    StatusChanged = statusChangedEvent.Event;
  };

  return item;

end;

return Item;