--!strict

local ServerStorage = game:GetService("ServerStorage");
local HttpService = game:GetService("HttpService");

local ICustomer = require(script.types);
local IRound = require(ServerStorage.Round.types);
local IOrder = require(ServerStorage.Order.types);

local Customer = {};

function Customer.new(properties: ICustomer.CustomerConstructorProperties, round: IRound.IRound): ICustomer.ICustomer

  local currentStatusPart: Part? = nil;

  local function setOrder(self: ICustomer.ICustomer, order: IOrder.IOrder): ()

    self.order = order;
    local statusPart = currentStatusPart or script.StatusPart:Clone();
    currentStatusPart = statusPart;

    if not self.model.PrimaryPart then

      error("Customer doesn't have a PrimaryPart.")

    end;

    statusPart.CFrame = self.model.PrimaryPart.CFrame + Vector3.new(0, 8, 0);
    statusPart.CanCollide = false;

    local weldConstraint = statusPart:FindFirstChild("WeldConstraint");
    if not weldConstraint or not weldConstraint:IsA("WeldConstraint") then

      error("Status part doesn't have a WeldConstraint.");

    end;

    weldConstraint.Part0 = statusPart;
    weldConstraint.Part1 = self.model.PrimaryPart;

    statusPart.Parent = self.model;

    local takeOrderProximityPrompt = script.TakeOrderProximityPrompt:Clone();
    takeOrderProximityPrompt.Parent = self.model.PrimaryPart;

  end;

  local function updateImages(surfaceGUI: Instance?)

    if not surfaceGUI then

      error("BackGUI and FrontGUI required.");

    end;

    local itemImageLabel = surfaceGUI:FindFirstChild("ImageLabel");
    if not itemImageLabel or not itemImageLabel:IsA("ImageLabel") then

      error(`{surfaceGUI.Name} needs an ImageLabel.`);

    end;

    itemImageLabel.Image = properties.image;
    
  end;

  local function setAssignedChefID(self: ICustomer.ICustomer, assignedChefID: string?): ()

    self.assignedChefID = assignedChefID;

  end;

  local spritePart = properties.model:FindFirstChild("SpritePart");
  assert(spritePart, "Character model must have primary part.");

  local backGUI = spritePart:FindFirstChild("BackGUI");
  local frontGUI = spritePart:FindFirstChild("FrontGUI");
  updateImages(backGUI);
  updateImages(frontGUI);

  local customer: ICustomer.ICustomer = {
    type = "Customer" :: "Customer";
    id = properties.id or HttpService:GenerateGUID(false);
    assignedChefID = properties.assignedChefID;
    order = properties.order;
    model = properties.model;
    image = properties.image;
    setOrder = setOrder;
    setAssignedChefID = setAssignedChefID;
  };

  if properties.order then

    customer:setOrder(properties.order);

  end;

  return customer;

end;

return Customer;