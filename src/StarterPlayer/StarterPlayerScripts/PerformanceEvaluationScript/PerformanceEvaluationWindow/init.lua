--!strict

local Lighting = game:GetService("Lighting");
local ReplicatedStorage = game:GetService("ReplicatedStorage");

local React = require(ReplicatedStorage.Shared.Packages.react);
local ReactRoblox = require(ReplicatedStorage.Shared.Packages["react-roblox"]);
local ContestantHypeSection = require(script.ContestantHypeSection);
local CompetitionResultsSection = require(script.CompetitionResultsSection);

export type PerformanceEvaluationWindowProperties = {
  contestants: {any};
}

local function PerformanceEvaluationWindow(properties: PerformanceEvaluationWindowProperties)

  local shouldShowResults, setShouldShowResults = React.useState(false);

  React.useEffect(function()
  
    task.delay(3, function()
    
      setShouldShowResults(true);

    end);

  end, {});

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
        Padding = UDim.new(0, 15);
        HorizontalAlignment = Enum.HorizontalAlignment.Center;
        SortOrder = Enum.SortOrder.LayoutOrder;
      });
      UIPadding = React.createElement("UIPadding", {
        PaddingTop = UDim.new(0, 15);
        PaddingBottom = UDim.new(0, 15);
        PaddingLeft = UDim.new(0, 15);
        PaddingRight = UDim.new(0, 15);
      });
      Title = React.createElement("TextLabel", {
        AutomaticSize = Enum.AutomaticSize.XY;
        BackgroundTransparency = 1;
        FontFace = Font.fromName("Kalam");
        LayoutOrder = 1;
        Size = UDim2.new();
        Text = "And the winner is...";
        TextSize = 30;
        TextColor3 = Color3.new();
      });
      ContestantHypeSection = if not shouldShowResults then
        React.createElement(ContestantHypeSection, {
          contestants = properties.contestants;
        })
      else nil;
      CompetitionResultsSection = if shouldShowResults then
        React.createElement(CompetitionResultsSection, {
          contestants = properties.contestants;
        })
      else nil;
    });
    Blur = ReactRoblox.createPortal(React.createElement("BlurEffect", {
      Size = 12;
    }), Lighting);
  })

end;

return PerformanceEvaluationWindow;