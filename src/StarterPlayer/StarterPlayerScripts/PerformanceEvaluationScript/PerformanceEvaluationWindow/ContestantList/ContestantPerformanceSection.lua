--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage");

local React = require(ReplicatedStorage.Shared.Packages.react);

export type ContestantPerformanceSectionProperties = {
  contestant: any;
  layoutOrder: number;
  onDidShowOrderCount: () -> ();
  shouldShowAccuracy: boolean;
  onDidShowAccuracy: () -> ();
  shouldShowFinalScore: boolean;
  onDidShowFinalScore: () -> ();
}

local function ContestantPerformanceSection(properties: ContestantPerformanceSectionProperties)

  -- Calculate fufilled orders.
  local shownFufilledOrderCount, setShownFufilledOrderCount = React.useState(0);

  local function animateValue(originalValue: number, shouldContinue: boolean, setter: (number) -> ()): ()

    if originalValue == 0 then

      task.wait(0.9);

    end;

    if shownFufilledOrderCount < #properties.contestant.servedCustomers then

      task.wait(0.1);
      setter(originalValue + 1);

    end;

  end;

  React.useEffect(function()
  
    task.spawn(function()

      if shownFufilledOrderCount ~= #properties.contestant.servedCustomers then

        animateValue(shownFufilledOrderCount, shownFufilledOrderCount < #properties.contestant.servedCustomers, setShownFufilledOrderCount);

      else

        properties.onDidShowOrderCount();

      end;
      
    end);

  end, {shownFufilledOrderCount});

  -- Calculate accuracy.
  local shownAccuracy, setShownAccuracy = React.useState(0);
  local overallAccuracy = 0;
  local totalItemCount = 0;
  local finishedItemCount = 0;

  for _, customer in properties.contestant.servedCustomers do

    for _, item in customer.order.requestedSandwich.items do
    
      local itemAccuracy = 0;
      for possibleItemIndex, possibleItem in customer.order.actualSandwich.items do

        if possibleItem.name == item.name then
          
          itemAccuracy = if possibleItem.status == item.status then 1 else 0;
          table.remove(customer.order.actualSandwich.items, possibleItemIndex);
          break;

        end;

      end;
      finishedItemCount += itemAccuracy;

    end;

    totalItemCount += #customer.order.requestedSandwich.items;

  end;

  overallAccuracy = finishedItemCount / totalItemCount;

  React.useEffect(function()

    if properties.shouldShowAccuracy then

      if shownAccuracy ~= overallAccuracy then

        animateValue(shownAccuracy, shownAccuracy < overallAccuracy, setShownAccuracy);

      else

        properties.onDidShowAccuracy();

      end;

    end;
    
  end, {properties.shouldShowAccuracy :: unknown, shownAccuracy})

  -- Calculate final score.
  local finalScore = math.floor(finishedItemCount);
  local shownFinalScore, setShownFinalScore = React.useState(0);
  
  React.useEffect(function()
  
    if properties.shouldShowFinalScore then

      if shownFinalScore ~= finalScore then

        animateValue(shownFinalScore, shownFinalScore < finalScore, setShownFinalScore);

      else

        properties.onDidShowFinalScore();

      end;

    end;

  end, {properties.shouldShowFinalScore :: unknown, shownFinalScore});

  -- Show the results.
  return React.createElement("Frame", {
    AutomaticSize = Enum.AutomaticSize.Y;
    BackgroundTransparency = 1;
    LayoutOrder = properties.layoutOrder; 
    Size = UDim2.new(0, 80, 0, 0);
  }, {
    UIListLayout = React.createElement("UIListLayout", {
      Padding = UDim.new(0, 5);
      SortOrder = Enum.SortOrder.LayoutOrder;
    });
    ContestantImageLabel = React.createElement("ImageLabel", {
      BackgroundTransparency = 1;
      LayoutOrder = 1;
      Image = properties.contestant.headshotImage;
      Size = UDim2.new(0, 60, 0, 60);
    });
    SummarySection = React.createElement("Frame", {
      LayoutOrder = 2;
      AutomaticSize = Enum.AutomaticSize.Y;
      BackgroundTransparency = 1;
      Size = UDim2.new(1, 0, 0, 0);
    }, {
      UIListLayout = React.createElement("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder;
      });
      OrderCountTextLabel = React.createElement("TextLabel", {
        AutomaticSize = Enum.AutomaticSize.XY;
        BackgroundTransparency = 1;
        Size = UDim2.new();
        FontFace = Font.fromName("Kalam");
        Text = `{shownFufilledOrderCount} orders`;
        TextSize = 18;
      });
      AccuracyTextLabel = if properties.shouldShowAccuracy then 
        React.createElement("TextLabel", {
          AutomaticSize = Enum.AutomaticSize.XY;
          BackgroundTransparency = 1;
          Size = UDim2.new();
          FontFace = Font.fromName("Kalam");
          Text = `{math.floor(shownAccuracy * 100)}% accuracy`;  -- Updated to show accuracy as a percentage
          TextSize = 18;
        })
      else nil;
    });
    FinalScoreSection = if properties.shouldShowFinalScore then
      React.createElement("Frame", {
        LayoutOrder = 3;
        AutomaticSize = Enum.AutomaticSize.Y;
        BackgroundTransparency = 1;
        Size = UDim2.new(1, 0, 0, 0);
      }, {
        UIListLayout = React.createElement("UIListLayout", {
          SortOrder = Enum.SortOrder.LayoutOrder;
        });
        HeadingTextLabel = React.createElement("TextLabel", {
          AutomaticSize = Enum.AutomaticSize.XY;
          BackgroundTransparency = 1;
          Size = UDim2.new();
          FontFace = Font.fromName("Kalam", Enum.FontWeight.Bold);
          Text = "FINAL SCORE";
          TextSize = 18;
        });
        ScoreTextLabel = React.createElement("TextLabel", {
          AutomaticSize = Enum.AutomaticSize.XY;
          BackgroundTransparency = 1;
          Size = UDim2.new();
          FontFace = Font.fromName("Kalam", Enum.FontWeight.Bold);
          Text = `{shownFinalScore}`;
          TextSize = 30;
        });
      })
    else nil;
  })

end;

return ContestantPerformanceSection;