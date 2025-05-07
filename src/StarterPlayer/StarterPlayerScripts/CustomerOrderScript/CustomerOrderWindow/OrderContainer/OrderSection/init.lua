--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage");

local React = require(ReplicatedStorage.Shared.Packages.react);
local IOrder = require(ReplicatedStorage.Client.Classes.Order.types);

local IngredientSection = require(script.IngredientSection);

export type OrderSectionProperties = {
  order: IOrder.IOrder;
  layoutOrder: number;
}

local function OrderSection(properties: OrderSectionProperties)

  local ingredientSections = {};
  
  for index, ingredient in properties.order.requestedSandwich.items do

    table.insert(ingredientSections, React.createElement(IngredientSection, {
      key = index;
      layoutOrder = index;
      ingredient = ingredient;
    }));

  end;

  return React.createElement("Frame", {
    AutomaticSize = Enum.AutomaticSize.XY;
    BackgroundTransparency = 1;
    Size = UDim2.new();
    LayoutOrder = properties.layoutOrder;
  }, {
    UIListLayout = React.createElement("UIListLayout", {
      SortOrder = Enum.SortOrder.LayoutOrder;
    });
    LabelContainer = React.createElement("Frame", {
      AutomaticSize = Enum.AutomaticSize.XY;
      BackgroundTransparency = 1;
      LayoutOrder = 1;
      Size = UDim2.new();
    }, {
      UIListLayout = React.createElement("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal;
        SortOrder = Enum.SortOrder.LayoutOrder;
      });
      ImageLabel = React.createElement("ImageLabel", {
        BackgroundTransparency = 1;
        Image = "rbxassetid://74941050054937";
        ImageRectOffset = Vector2.new(100, 100);
        ImageRectSize = Vector2.new(800, 800);
        LayoutOrder = 1;
        Size = UDim2.new(0, 25, 0, 25);
      });
      TextLabel = React.createElement("TextLabel", {
        LayoutOrder = 2;
        AutomaticSize = Enum.AutomaticSize.XY;
        BackgroundTransparency = 1;
        Size = UDim2.new();
        FontFace = Font.fromName("Kalam");
        Text = properties.order.requestedSandwich.name;
        TextSize = 30;
      });
    });
    IngredientList = React.createElement("Frame", {
      AutomaticSize = Enum.AutomaticSize.XY;
      BackgroundTransparency = 1;
      LayoutOrder = 2;
      Size = UDim2.new();
    }, {
      UIListLayout = React.createElement("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder;
      });
      UIPadding = React.createElement("UIPadding", {
        PaddingLeft = UDim.new(0, 25);
      });
      Ingredients = React.createElement(React.Fragment, {}, ingredientSections);
    });
  })

end;

return OrderSection;