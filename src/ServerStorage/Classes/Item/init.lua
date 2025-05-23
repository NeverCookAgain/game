--!strict

local ServerStorage = game:GetService("ServerStorage");

local IItem = require(script.types);
local IRound = require(ServerStorage.Classes.Round.types);

local Item = {};

function Item.new(properties: IItem.ItemConstructorProperties, round: IRound.IRound): IItem.IItem

  local statusChangedEvent = Instance.new("BindableEvent");
  local spinProcess: thread? = nil;
  local triggerEvent: RBXScriptConnection;
  local droppedPart: BasePart? = nil;

  local function setStatus(self: IItem.IItem, newStatus: IItem.Status): ()

    self.status = newStatus;
    statusChangedEvent:Fire();

  end;

  local function createPart(self: IItem.IItem): BasePart

    local part = self.templatePart:Clone();
    part.Massless = true;

    local function updateImages(surfaceGUI: Instance?)

      if not surfaceGUI then

        error("BackGUI and FrontGUI required.");

      end;

      local itemImageLabel = surfaceGUI:FindFirstChild("ItemImageLabel");
      if not itemImageLabel or not itemImageLabel:IsA("ImageLabel") then

        error(`{surfaceGUI.Name} needs an "ItemImageLabel".`);

      end;

      itemImageLabel.ImageColor3 = if self.status == "Burnt" then Color3.fromRGB(20, 20, 20) elseif self.status == "Cooked" then Color3.fromRGB(230, 208, 114) else Color3.new(1, 1, 1);
      itemImageLabel.Image = properties.image;
      
    end;
    
    if self.status == "Burnt" then

      local smoke = Instance.new("Smoke");
      smoke.Color = Color3.new(0, 0, 0);
      smoke.Size = 1;
      smoke.RiseVelocity = 2;
      smoke.Opacity = 0.1;
      smoke.Parent = part;

    end;

    local backGUI = part:FindFirstChild("BackGUI");
    local frontGUI = part:FindFirstChild("FrontGUI");
    updateImages(backGUI);
    updateImages(frontGUI);

    return part;

  end;

  local function drop(self: IItem.IItem, origin: CFrame, direction: Vector3): BasePart

    local part = droppedPart or self:createPart();
    droppedPart = part;

    local proximityPrompt = part:FindFirstChild("ProximityPrompt");
    if not proximityPrompt or not proximityPrompt:IsA("ProximityPrompt") then

      error("Proximity prompt not found. Ensure an ItemPart template is in the Item class.");
      
    end;

    proximityPrompt.Enabled = true;
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

        local soundPart = Instance.new("Part");
        soundPart.Transparency = 1;
        soundPart.Anchored = true;
        soundPart.CanCollide = false;
        soundPart.CFrame = part.CFrame;
        soundPart.Parent = workspace;
        
        local sound = Instance.new("Sound");
        sound.SoundId = "rbxassetid://6324790483";
        sound.Volume = 0.6;
        sound.Parent = soundPart;
        sound.Ended:Once(function()
        
          soundPart:Destroy();
          sound:Destroy();

        end);
        sound:Play();

        part:Destroy();
        droppedPart = nil;
        contestant:addToInventory(self);

      end;
    
    end);

    part.CFrame = origin;
    part.Parent = workspace;
    part:SetNetworkOwner();
    part:ApplyImpulse(direction);

    return part;

  end;

  local item: IItem.IItem = {
    type = "Item" :: "Item";
    name = properties.name;
    description = properties.description;
    image = properties.image;
    status = properties.status or ("Raw" :: "Raw");
    templatePart = properties.templatePart or script.Part;
    createPart = createPart;
    setStatus = setStatus;
    drop = drop;
    StatusChanged = statusChangedEvent.Event;
  };

  return item;

end;

export type ItemClass = {
  name: string;
  description: string;
  new: (round: IRound.IRound) -> IItem.IItem;
};

function Item.listClasses(): {[string]: ItemClass}

  return {
    Avocado = require(ServerStorage.Classes.Ingredients.Avocado) :: ItemClass;
    Bacon = require(ServerStorage.Classes.Ingredients.Bacon) :: ItemClass;
    Bagel = require(ServerStorage.Classes.Ingredients.Bagel) :: ItemClass;
    Beef = require(ServerStorage.Classes.Ingredients.Beef) :: ItemClass;
    Chicken = require(ServerStorage.Classes.Ingredients.Chicken) :: ItemClass;
    Egg = require(ServerStorage.Classes.Ingredients.Egg) :: ItemClass;
    Lettuce = require(ServerStorage.Classes.Ingredients.Lettuce) :: ItemClass;
    Mozzarella = require(ServerStorage.Classes.Ingredients.Mozzarella) :: ItemClass;
    Olives = require(ServerStorage.Classes.Ingredients.Olives) :: ItemClass;
    Onions = require(ServerStorage.Classes.Ingredients.Onions) :: ItemClass;
    Pepperoni = require(ServerStorage.Classes.Ingredients.Pepperoni) :: ItemClass;
    Peppers = require(ServerStorage.Classes.Ingredients.Peppers) :: ItemClass;
    Pickles = require(ServerStorage.Classes.Ingredients.Pickles) :: ItemClass;
    Pork = require(ServerStorage.Classes.Ingredients.Pork) :: ItemClass;
    Spinach = require(ServerStorage.Classes.Ingredients.Spinach) :: ItemClass;
    SwissCheese = require(ServerStorage.Classes.Ingredients.SwissCheese) :: ItemClass;
    Tomatoes = require(ServerStorage.Classes.Ingredients.Tomatoes) :: ItemClass;
    Turkey = require(ServerStorage.Classes.Ingredients.Turkey) :: ItemClass;
    WhiteBread = require(ServerStorage.Classes.Ingredients.WhiteBread) :: ItemClass;
  };

end;

function Item.random(round: IRound.IRound): IItem.IItem

  local itemNames = {};
  local items = Item.listClasses();

  for itemName in items do

    table.insert(itemNames, itemName);

  end;

  local randomIndex = Random.new():NextInteger(1, #itemNames);
  local itemName = itemNames[randomIndex];
  local item = items[itemName];

  return item.new(round);

end;

function Item.get(itemName: string, round: IRound.IRound): IItem.IItem

  local items = Item.listClasses();
  local item = items[itemName];

  if not item then

    error(`Item {itemName} not found.`);

  end;

  return item.new(round);

end;

return Item;