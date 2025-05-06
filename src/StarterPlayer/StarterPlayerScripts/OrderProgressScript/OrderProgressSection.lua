--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage");

local React = require(ReplicatedStorage.Shared.Packages.react);
local Round = require(ReplicatedStorage.Client.Round);
local ICustomer = require(ReplicatedStorage.Client.Customer.types);
local IContestant = require(ReplicatedStorage.Client.Contestant.types);
local IItem = require(ReplicatedStorage.Client.Item.types);
local ISandwich = require(ReplicatedStorage.Client.Sandwich.types);

export type CustomerOrderWindowProperties = {
  customer: ICustomer.ICustomer;
}

local function OrderProgressSection(properties: CustomerOrderWindowProperties)

  local chef, setChef = React.useState(nil :: IContestant.IContestant?);
  local inventory, setInventory = React.useState({} :: {IItem.IItem | ISandwich.ISandwich});

  React.useEffect(function()
  
    task.spawn(function()
    
      local round = Round.getFromServerRound();
      if not round then return; end
      if properties.customer.order.assignedChefID == nil then return; end

      local contestant = round:findChefFromID(properties.customer.order.assignedChefID);
      setChef(contestant);

    end);

  end, {properties.customer});

  React.useEffect(function()
  
    if (chef == nil) then return; end;

    ReplicatedStorage.Shared.Events.ContestantInventoryChanged.OnClientEvent:Connect(function(contestant)
    
      if contestant.id ~= chef.id then return; end
      setInventory(contestant.inventory);
    
    end);

  end, {chef});

  -- Check if player has the sandwich or the ingredients in their inventory.
  local ingredientCompletion = 0;
  for _, item in inventory do

    if item.type == "Sandwich" then

      local matchingItemCount = 0;
      for _, ingredient in item.items do

        for _, requestedIngredient in properties.customer.order.requestedSandwich.items do

          if ingredient.name == requestedIngredient.name then

            matchingItemCount += 1;
            break;
          
          end;

        end;

      end;

    end;

  end;

  local specialOrderCompletion = 1 / 3;

  local orderCompletion = ingredientCompletion + specialOrderCompletion;

  return React.createElement("Frame", {
    AutomaticSize = Enum.AutomaticSize.X;
    AnchorPoint = Vector2.new(0, 1);
    BackgroundTransparency = 1;
    Position = UDim2.new(0, 15, 1, -15);
    Size = UDim2.new(0, 0, 0, 30);
  }, {
    UIListLayout = React.createElement("UIListLayout", {
      FillDirection = Enum.FillDirection.Horizontal;
      HorizontalAlignment = Enum.HorizontalAlignment.Left;
      VerticalAlignment = Enum.VerticalAlignment.Center;
      Padding = UDim.new(0, 5);
    });
    CustomerHeadshotContainer = React.createElement("Frame", {
      Size = UDim2.new(0, 30, 0, 30);
      BackgroundTransparency = 1;
      LayoutOrder = 1;
      ClipsDescendants = true;
    }, {
      CustomerHeadshot = React.createElement("ImageLabel", {
        Image = properties.customer.image;
        AnchorPoint = Vector2.new(0.5, 0.5);
        Position = UDim2.new(0.5, 0, 0.5, 12);
        Size = UDim2.new(1, 50, 1, 50);
        BackgroundTransparency = 1;
      });
    });
    OrderProgressSection = React.createElement("Frame", {
      Size = UDim2.new(0, 200, 0, 20);
      BackgroundTransparency = 0.5;
      LayoutOrder = 2;
    }, {
      UICorner = React.createElement("UICorner", {
        CornerRadius = UDim.new(1, 0);
      });
      OrderProgressBar = React.createElement("Frame", {
        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        Size = UDim2.new(orderCompletion, 0, 1, 0);
      }, {
        UICorner = React.createElement("UICorner", {
          CornerRadius = UDim.new(1, 0);
        });
      });
    });
  });

end;

return OrderProgressSection;