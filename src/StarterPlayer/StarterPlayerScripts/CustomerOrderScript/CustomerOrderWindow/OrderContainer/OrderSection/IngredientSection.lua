--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage");

local React = require(ReplicatedStorage.Shared.Packages.react);

export type IngredientSectionProperties = {
  ingredient: any;
  layoutOrder: number;
}

local function IngredientSection(properties: IngredientSectionProperties)

  return React.createElement("Frame", {
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
      Image = properties.ingredient.image;
      ImageRectOffset = Vector2.new(100, 100);
      ImageRectSize = Vector2.new(800, 800);
      LayoutOrder = 1;
      Size = UDim2.new(0, 15, 0, 15);
    });
    TextLabel = React.createElement("TextLabel", {
      AutomaticSize = Enum.AutomaticSize.XY;
      BackgroundTransparency = 1;
      LayoutOrder = 2;
      Size = UDim2.new();
      FontFace = Font.fromName("Kalam");
      Text = properties.ingredient.name;
      TextSize = 22;
    });
  })

end;

return IngredientSection;