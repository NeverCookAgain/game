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
      local allIngredients = table.clone(item.items);
      for _, requestedIngredient in properties.customer.order.requestedSandwich.items do

        local matchingIngredientIndices = {};

        for index, possiblyMatchingIngredient in allIngredients do

          if possiblyMatchingIngredient.name == requestedIngredient.name then

            table.insert(matchingIngredientIndices, index);
          
          end;

        end;

        if matchingIngredientIndices[1] then

          local closestIngredientIndex = 1;

          for _, index in matchingIngredientIndices do

            local ingredient = allIngredients[index];
            if ingredient.status == requestedIngredient.status then

              closestIngredientIndex = index;
              break;

            end;

          end;

          matchingItemCount = (
            if allIngredients[closestIngredientIndex].status == requestedIngredient.status then
              matchingItemCount + 1
            else matchingItemCount + 0.5
          );

        end;

      end;

      ingredientCompletion = matchingItemCount / #properties.customer.order.requestedSandwich.items;

    elseif item.type == "Item" then

      for _, requestedIngredient in properties.customer.order.requestedSandwich.items do

        if item.name == requestedIngredient.name then

          ingredientCompletion = math.max(ingredientCompletion, (if item.status == requestedIngredient.status then 1 else 0.5) / #properties.customer.order.requestedSandwich.items);
          break;

        end;

      end;

    end;

  end;

  print(ingredientCompletion);

  local orderCompletion = (ingredientCompletion);
  -- local specialOrderCompletion = 1;
  -- local orderCompletion = (ingredientCompletion + specialOrderCompletion) / 2;

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