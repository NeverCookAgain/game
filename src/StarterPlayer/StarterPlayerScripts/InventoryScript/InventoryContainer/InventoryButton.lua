--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage");

local React = require(ReplicatedStorage.Shared.Packages.react);

export type Item = {
  name: string;
  description: string;
}

export type InventoryButtonProperties = {
  layoutOrder: number;
  item: Item?;
  isSelected: boolean;
  onSelect: () -> ();
}

local function InventoryButton(properties: InventoryButtonProperties)

  return React.createElement("TextButton", {
    AnchorPoint = Vector2.new(1, 1);
    BackgroundTransparency = if properties.item then 0.65 else 0.85;
    BackgroundColor3 = Color3.new(1, 1, 1);
    BorderSizePixel = 0;
    Size = UDim2.new(0, 50, 0, 50);
    Text = if properties.item then properties.item.name else "";
    LayoutOrder = properties.layoutOrder;
    [React.Event.Activated] = function()

      properties.onSelect();

    end;
  }, {
    UICorner = React.createElement("UICorner", {
      CornerRadius = UDim.new(1, 0);
    });
    UIStroke = React.createElement("UIStroke", {
      ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
      Color = if properties.isSelected then Color3.fromRGB(219, 117, 33) else Color3.fromRGB(255, 255, 255);
      Transparency = if properties.item then 0 else 0.75;
      Thickness = 2;
    });
  })

end;

return InventoryButton;