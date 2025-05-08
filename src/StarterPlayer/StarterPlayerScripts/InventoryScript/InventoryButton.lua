--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage");

local React = require(ReplicatedStorage.Shared.Packages.react);

export type Item = {
  name: string;
  description: string;
  image: string;
}

export type InventoryButtonProperties = {
  layoutOrder: number;
  item: Item?;
  isSelected: boolean;
  onSelect: () -> ();
  isDisabled: boolean?;
  anchorPoint: Vector2?;
  text: string?;
}

local function InventoryButton(properties: InventoryButtonProperties)

  return React.createElement(if properties.item then "ImageButton" else "TextButton", {
    AnchorPoint = properties.anchorPoint or Vector2.new(1, 1);
    BackgroundTransparency = if properties.item and not properties.isDisabled then 0.65 else 0.85;
    BackgroundColor3 = Color3.new(1, 1, 1);
    BorderSizePixel = 0;
    Size = UDim2.new(0, 50, 0, 50);
    Text = if properties.item then nil else (properties.text or "");
    Image = if properties.item then (properties.item.image or "rbxassetid://107867225935323") else nil;
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
      Transparency = if properties.item and not properties.isDisabled then 0 else 0.75;
      Thickness = 2;
    });
  })

end;

return InventoryButton;