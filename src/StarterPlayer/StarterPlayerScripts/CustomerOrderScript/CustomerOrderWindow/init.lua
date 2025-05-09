--!strict

local Lighting = game:GetService("Lighting");
local ReplicatedStorage = game:GetService("ReplicatedStorage");

local React = require(ReplicatedStorage.Shared.Packages.react);
local ReactRoblox = require(ReplicatedStorage.Shared.Packages["react-roblox"]);
local OrderContainer = require(script.OrderContainer);

export type CustomerOrderWindowProperties = {
  customer: any;
  onClose: () -> ();
  onAccept: () -> ();
}

local function CustomerOrderWindow(properties: CustomerOrderWindowProperties)

  return React.createElement("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5);
    AutomaticSize = Enum.AutomaticSize.XY;
    BackgroundTransparency = 1;
    Position = UDim2.new(0.5, 0, 0.5, 0);
    Size = UDim2.new();
  }, {
    UIListLayout = React.createElement("UIListLayout", {
      FillDirection = Enum.FillDirection.Horizontal;
      SortOrder = Enum.SortOrder.LayoutOrder;
      VerticalAlignment = Enum.VerticalAlignment.Center;
    });
    CustomerImage = React.createElement("ImageLabel", {
      BackgroundTransparency = 1;
      Image = properties.customer.image;
      ImageRectOffset = Vector2.new(512, 0);
      ImageRectSize = Vector2.new(-512, 512);
      LayoutOrder = 1;
      Size = UDim2.new(0, 300, 0, 300);
    });
    OrderContainer = React.createElement(OrderContainer, {
      order = properties.customer.order;
      onClose = properties.onClose;
      onAccept = properties.onAccept;
    });
    Blur = ReactRoblox.createPortal(React.createElement("BlurEffect", {
      Size = 12;
    }), Lighting);
  })

end;

return CustomerOrderWindow;