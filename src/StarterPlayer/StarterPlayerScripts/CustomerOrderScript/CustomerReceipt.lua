--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage");

local React = require(ReplicatedStorage.Shared.Packages.react);
local Fonts = require(ReplicatedStorage.Client.Fonts);

local IOrder = require(ReplicatedStorage.Client.Order.types);

type IOrder = IOrder.IOrder;

type Properties = {
  order: IOrder;
}

local function CustomerReceipt(properties: Properties)

  local ingredientLabels = {}
  for index, ingredient in properties.order.requestedSandwich.items do

    local ingredientLabel = React.createElement("TextLabel", {
      Text = `{ingredient.status} {ingredient.name}`,
      AutomaticSize = Enum.AutomaticSize.XY,
      TextColor3 = Color3.fromRGB(255, 255, 255),
      BackgroundTransparency = 1,
      LayoutOrder = index,
      FontFace = Fonts.Regular;
      TextSize = 24,
      key = index;
    })

    table.insert(ingredientLabels, ingredientLabel);

  end;

  return React.createElement("Frame", {
    AutomaticSize = Enum.AutomaticSize.XY;
    BackgroundTransparency = 1;
    Position = UDim2.new(0, 15, 0.5, 0);
    AnchorPoint = Vector2.new(0, 0.5),
  }, {
    UIListLayout = React.createElement("UIListLayout", {
      Padding = UDim.new(0, 0),
      FillDirection = Enum.FillDirection.Vertical,
      HorizontalAlignment = Enum.HorizontalAlignment.Left,
      VerticalAlignment = Enum.VerticalAlignment.Center,
    }),
    IngredientLabels = React.createElement(React.Fragment, {}, ingredientLabels);
  });
  
end;

return CustomerReceipt;