--!strict

local ServerStorage = game:GetService("ServerStorage");
local HttpService = game:GetService("HttpService");

local ICustomer = require(script.types);
local IRound = require(ServerStorage.Round.types);
local IOrder = require(ServerStorage.Order.types);

local Customer = {};

function Customer.new(properties: ICustomer.CustomerConstructorProperties, round: IRound.IRound): ICustomer.ICustomer

  if not properties.model.PrimaryPart then

    error("Customer doesn't have a PrimaryPart.")

  end;

  local statusPart: Part = script.StatusPart:Clone();
  statusPart.CFrame = properties.model.PrimaryPart.CFrame + Vector3.new(0, 8, 0);
  statusPart.CanCollide = false;

  local weldConstraint = statusPart:FindFirstChild("WeldConstraint");
  if not weldConstraint or not weldConstraint:IsA("WeldConstraint") then

    error("Status part doesn't have a WeldConstraint.");

  end;

  weldConstraint.Part0 = statusPart;
  weldConstraint.Part1 = properties.model.PrimaryPart;

  statusPart.Parent = properties.model;

  local function setOrder(self: ICustomer.ICustomer, order: IOrder.IOrder): ()

    self.order = order;

    local takeOrderProximityPrompt = script.TakeOrderProximityPrompt:Clone();
    takeOrderProximityPrompt.Parent = self.model.PrimaryPart;

    self:updateStatus();

  end;

  local spritePart = properties.model:FindFirstChild("SpritePart");
  assert(spritePart, "Character model must have primary part.");

  local backGUI = spritePart:FindFirstChild("BackGUI");
  local frontGUI = spritePart:FindFirstChild("FrontGUI");

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

  local function updateStatus(self: ICustomer.ICustomer): ()

    self.status = (
      if self.order then
        if self.order.deliveredTimeMilliseconds then "Served"
        elseif self.order.assignedTimeMilliseconds then "Assigned"
        else "Waiting"
      else "Thinking"
    );

    local statusPartFrontGUI = statusPart:FindFirstChild("FrontGUI");
    assert(statusPartFrontGUI);
    local statusPartFrontImageLabel = statusPartFrontGUI:FindFirstChild("ImageLabel");
    assert(statusPartFrontImageLabel and statusPartFrontImageLabel:IsA("ImageLabel"));
    local statusPartBackGUI = statusPart:FindFirstChild("BackGUI");
    assert(statusPartBackGUI);
    local statusPartBackImageLabel = statusPartBackGUI:FindFirstChild("ImageLabel");
    assert(statusPartBackImageLabel and statusPartBackImageLabel:IsA("ImageLabel"));

    local images = {
      Thinking = "rbxassetid://132687863617866",
      Waiting = "rbxassetid://132687863617866",
      Assigned = "rbxassetid://96368665540754",
      Served = "rbxassetid://9113087676",
    }

    statusPartFrontImageLabel.Image = images[self.status];
    statusPartBackImageLabel.Image = images[self.status];

  end;

  updateImages(backGUI);
  updateImages(frontGUI);

  local customer: ICustomer.ICustomer = {
    type = "Customer" :: "Customer";
    id = properties.id or HttpService:GenerateGUID(false);
    status = properties.status;
    order = properties.order;
    model = properties.model;
    image = properties.image;
    setOrder = setOrder;
    updateStatus = updateStatus;
  };

  if properties.order then

    customer:setOrder(properties.order);

  end;

  customer:updateStatus();

  customer.model:SetAttribute("CustomerID", customer.id);

  return customer;

end;

return Customer;