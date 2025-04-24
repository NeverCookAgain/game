--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage");

local React = require(ReplicatedStorage.Shared.Packages.react);
local OrderSection = require(script.OrderSection);

export type OrderContainerProperties = {
  order: any;
}

local function OrderContainer(properties: OrderContainerProperties)

  return React.createElement("Frame", {
    BackgroundTransparency = 1;
    Size = UDim2.new(0, 400, 0, 300);
    LayoutOrder = 2;
  }, {
    CloseButton = React.createElement("ImageButton", {
      BackgroundTransparency = 1;
      Image = "rbxassetid://107499357253953";
      Position = UDim2.new(1, 20, 0, 25);
      Size = UDim2.new(0, 50, 0, 50);
    });
    Content = React.createElement("ImageLabel", {
      BackgroundTransparency = 1;
      Image = "rbxassetid://85139156311421";
      Position = UDim2.new();
      Size = UDim2.new(1, 0, 1, 0);
    }, {
      UIListLayout = React.createElement("UIListLayout", {
        HorizontalAlignment = Enum.HorizontalAlignment.Center;
        SortOrder = Enum.SortOrder.LayoutOrder;
      });
      UIPadding = React.createElement("UIPadding", {
        PaddingBottom = UDim.new(0, 15);
        PaddingLeft = UDim.new(0, 30);
        PaddingRight = UDim.new(0, 30);
        PaddingTop = UDim.new(0, 15);
      });
      TitleTextLabel = React.createElement("TextLabel", {
        AutomaticSize = Enum.AutomaticSize.XY;
        BackgroundTransparency = 1;
        Size = UDim2.new();
        FontFace = Font.fromName("Kalam");
        Text = "Order";
        TextSize = 38;
      });
      OrderItemList = React.createElement("Frame", {
        AutomaticSize = Enum.AutomaticSize.Y;
        BackgroundTransparency = 1;
        LayoutOrder = 2;
        Size = UDim2.new(1, 0, 0, 0);
      }, {
        UIListLayout = React.createElement("UIListLayout", {
          Padding = UDim.new(0, 10);
          SortOrder = Enum.SortOrder.LayoutOrder;
        });
        SandwichInformationContainer = React.createElement(OrderSection, {
          layoutOrder = 1;
          order = properties.order;
        });
        -- SpecialRequestInformationContainer = React.createElement(OrderSection, {
        --   layoutOrder = 2;
        --   order = properties.order;
        -- });
      });
    });
    ConfirmButton = React.createElement("ImageButton", {
      BackgroundTransparency = 1;
      Image = "rbxassetid://119649376156285";
      Position = UDim2.new(1, 20, 0, 25);
      Size = UDim2.new(0, 100, 0, 100);
    }, {
      UIAspectRatioConstraint = React.createElement("UIAspectRatioConstraint", {
        AspectRatio = 2.28;
      });
      TextLabel = React.createElement("TextLabel", {
        AnchorPoint = Vector2.new(0.5, 0.5);
        AutomaticSize = Enum.AutomaticSize.XY;
        BackgroundTransparency = 1;
        Position = UDim2.new(0.5, 0, 0.5, 0);
        Size = UDim2.new();
        FontFace = Font.fromName("Kalam");
        Text = "Accept";
        TextSize = 30;
      });
    });
  })

end;

return OrderContainer;