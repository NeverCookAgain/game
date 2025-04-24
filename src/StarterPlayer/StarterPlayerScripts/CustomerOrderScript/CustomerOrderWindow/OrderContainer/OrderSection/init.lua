--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage");

local React = require(ReplicatedStorage.Shared.Packages.react);

local IngredientSection = require(script.IngredientSection);

export type OrderSectionProperties = {
  order: any;
  layoutOrder: number;
}

local function OrderSection(properties: OrderSectionProperties)

  local ingredientSections = {};
  
  for index, ingredient in properties.order.sandwich.items do

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
    IngredientList = React.createElement("Frame", {
      AutomaticSize = Enum.AutomaticSize.XY;
      BackgroundTransparency = 1;
      LayoutOrder = 1;
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
    LabelContainer = React.createElement("Frame", {
      AutomaticSize = Enum.AutomaticSize.XY;
      BackgroundTransparency = 1;
      LayoutOrder = 2;
      Size = UDim2.new();
    }, {
      UIListLayout = React.createElement("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder;
      });
      ImageLabel = React.createElement("ImageLabel", {
        BackgroundTransparency = 1;
        Image = "rbxassetid://74941050054937";
        ImageRectOffset = Vector2.new(100, 100);
        ImageRectSize = Vector2.new(800, 800);
        LayoutOrder = 1;
        Size = UDim2.new(0, 300, 0, 300);
      });
      TextLabel = React.createElement("TextLabel", {
        LayoutOrder = 2;
        AutomaticSize = Enum.AutomaticSize.XY;
        BackgroundTransparency = 1;
        Size = UDim2.new();
        FontFace = Font.fromName("Kalam");
        Text = properties.order.sandwich.name;
        TextSize = 30;
      });
    });
  })

end;

return OrderSection;