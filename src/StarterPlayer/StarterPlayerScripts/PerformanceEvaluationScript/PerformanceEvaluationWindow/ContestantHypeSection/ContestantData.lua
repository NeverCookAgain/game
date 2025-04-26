--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage");

local React = require(ReplicatedStorage.Shared.Packages.react);

export type ContestantPerformanceSectionProperties = {
  contestant: any;
  layoutOrder: number;
  shouldShowFinalScore: boolean;
}

local function ContestantHypeSection(properties: ContestantPerformanceSectionProperties)

  -- Calculate accuracy.
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

  -- Calculate final score.
  local finalScore = math.floor(finishedItemCount);

  local shownFinalScore, setShownFinalScore = React.useState(0);
  React.useEffect(function()

    if not properties.shouldShowFinalScore then

      task.delay(0.05, function()
      
        setShownFinalScore(Random.new():NextInteger(0, 99999));

      end);

    end;

  end, {properties.shouldShowFinalScore :: unknown, shownFinalScore});

  -- Show the results.
  return React.createElement("Frame", {
    AutomaticSize = Enum.AutomaticSize.XY;
    BackgroundTransparency = 1;
    LayoutOrder = properties.layoutOrder; 
    Size = UDim2.new();
  }, {
    UIListLayout = React.createElement("UIListLayout", {
      Padding = UDim.new(0, 5);
      SortOrder = Enum.SortOrder.LayoutOrder;
      HorizontalAlignment = Enum.HorizontalAlignment.Center;
    });
    ContestantImageLabel = React.createElement("ImageLabel", {
      BackgroundTransparency = 1;
      LayoutOrder = 1;
      Image = properties.contestant.headshotImage;
      Size = UDim2.new(0, 100, 0, 100);
    });
    ScoreTextLabel = React.createElement("TextLabel", {
      AutomaticSize = Enum.AutomaticSize.XY;
      BackgroundTransparency = 1;
      LayoutOrder = 2;
      Size = UDim2.new();
      FontFace = Font.fromName("Kalam", Enum.FontWeight.Bold);
      Text = `{shownFinalScore}`;
      TextSize = 40;
    });
  })

end;

return ContestantHypeSection;