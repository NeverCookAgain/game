--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage");

local React = require(ReplicatedStorage.Shared.Packages.react);
local ContestantPerformanceSection = require(script.ContestantPerformanceSection);

export type ContestantsSectionProperties = {
  contestants: {any};
}

local function ContestantList(properties: ContestantsSectionProperties)

  local shouldShowAccuracy, setShouldShowAccuracy = React.useState(false);
  local shouldShowFinalScore, setShouldShowFinalScore = React.useState(false);
  local calculatingContestants, setCalculatingContestants = React.useState(properties.contestants);

  React.useEffect(function()
    
    if #calculatingContestants == 0 then
      
      setCalculatingContestants(properties.contestants);

    end;

  end, {calculatingContestants});

  local contestantPerformanceSections = {};
  for index, contestant in properties.contestants do

    table.insert(contestantPerformanceSections, React.createElement(ContestantPerformanceSection, {
      contestant = contestant;
      layoutOrder = contestant.layoutOrder; 
      shouldShowAccuracy = shouldShowAccuracy;      
      shouldShowFinalScore = shouldShowFinalScore;
      onDidShowOrderCount = function()
        
        local newCalculatingContestants = calculatingContestants;
        for possibleContestantIndex, possibleContestant in newCalculatingContestants do
          if possibleContestant == contestant then
            
            table.remove(newCalculatingContestants, possibleContestantIndex);
            setCalculatingContestants(newCalculatingContestants);
            break;

          end;
        end;

        if #newCalculatingContestants == 0 then

          setShouldShowAccuracy(true);

        end;

      end;
      onDidShowAccuracy = function()
        
        local newCalculatingContestants = calculatingContestants;
        for possibleContestantIndex, possibleContestant in newCalculatingContestants do
          if possibleContestant == contestant then
            
            table.remove(newCalculatingContestants, possibleContestantIndex);
            setCalculatingContestants(newCalculatingContestants);
            break;

          end;
        end;

        if #newCalculatingContestants == 0 then

          setShouldShowFinalScore(true);

        end;

      end;
      key = index;  
    }))

  end;

  -- Show the results.
  return React.createElement("Frame", {
    AutomaticSize = Enum.AutomaticSize.XY;
    BackgroundTransparency = 1;
    LayoutOrder = 2; 
    Size = UDim2.new();
  }, {
    UIListLayout = React.createElement("UIListLayout", {
      Padding = UDim.new(0, 15);
      SortOrder = Enum.SortOrder.LayoutOrder;
      FillDirection = Enum.FillDirection.Horizontal;
    });
    ContestantPerformanceSections = React.createElement(React.Fragment, {}, contestantPerformanceSections);
  })

end;

return ContestantList;