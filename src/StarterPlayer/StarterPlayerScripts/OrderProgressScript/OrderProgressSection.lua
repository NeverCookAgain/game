--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage");

local React = require(ReplicatedStorage.Shared.Packages.react);
local ICustomer = require(ReplicatedStorage.Client.Customer.types);

export type CustomerOrderWindowProperties = {
  customer: ICustomer.ICustomer;
}

local function OrderProgressSection(properties: CustomerOrderWindowProperties)

  local specialOrderCompletion = 1 / 3;

  local orderCompletion = specialOrderCompletion;

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