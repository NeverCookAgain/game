--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage");

local React = require(ReplicatedStorage.Shared.Packages.react);
local ContestantList = require(script.ContestantList);

export type PerformanceEvaluationWindowProperties = {
  contestants: {any};
}

local function PerformanceEvaluationWindow(properties: PerformanceEvaluationWindowProperties)

  -- Show the results.
  return React.createElement("Frame", {
    BackgroundTransparency = 1;
    LayoutOrder = 1; 
    Size = UDim2.new(1, 0, 1, 0);
  }, {
    Content = React.createElement("ImageLabel", {
      AnchorPoint = Vector2.new(0.5, 0.5);
      BackgroundTransparency = 1;
      Image = "rbxassetid://85139156311421";
      Position = UDim2.new(0.5, 0, 0.5, 0);
      Size = UDim2.new(0, 500, 0, 300);
    }, {
      UIListLayout = React.createElement("UIListLayout", {
        HorizontalAlignment = Enum.HorizontalAlignment.Center;
        Padding = UDim.new(0, 15);
        SortOrder = Enum.SortOrder.LayoutOrder;
        FillDirection = Enum.FillDirection.Horizontal;
      });
      UIPadding = React.createElement("UIPadding", {
        PaddingLeft = UDim.new(0, 10);
        PaddingRight = UDim.new(0, 10);
      });
      Title = React.createElement("TextLabel", {
        AutomaticSize = Enum.AutomaticSize.XY;
        BackgroundTransparency = 1;
        FontFace = Font.fromName("Kalam");
        LayoutOrder = 1;
        Size = UDim2.new();
        Text = "And the winner is...";
        TextSize = 30;
        TextColor3 = Color3.fromRGB(255, 255, 255);
      });
      ContestantList = React.createElement(ContestantList, {
        contestants = properties.contestants;
      });
    });
  })

end;

return PerformanceEvaluationWindow;