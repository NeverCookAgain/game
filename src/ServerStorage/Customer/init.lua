--!strict

local ServerStorage = game:GetService("ServerStorage");

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
    takeOrderProximityPrompt.Triggered:Connect(function(triggeringPlayer: Player)
    
      local contestant = round:findContestantFromPlayer(triggeringPlayer);
      if contestant and not contestant.assignedCustomer then

        takeOrderProximityPrompt:Destroy();
        
        contestant:setAssignedCustomer(self); 

      end;

    end);
    takeOrderProximityPrompt.Parent = self.model.PrimaryPart;

  end;

  local customer: ICustomer.ICustomer = {
    type = "Customer" :: "Customer";
    order = properties.order;
    model = properties.model;
    setOrder = setOrder;
  };

  return customer;

end;

return Customer;