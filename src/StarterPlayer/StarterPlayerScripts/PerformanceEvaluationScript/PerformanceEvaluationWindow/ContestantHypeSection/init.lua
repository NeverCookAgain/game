--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage");

local React = require(ReplicatedStorage.Shared.Packages.react);
local IContestant = require(ReplicatedStorage.Client.Classes.Contestant.types);

local ContestantData = require(script.ContestantData);

export type ContestantsSectionProperties = {
  contestants: {IContestant.IContestant};
}

local function ContestantHypeSection(properties: ContestantsSectionProperties)

  local calculatingContestants, setCalculatingContestants = React.useState(properties.contestants);

  React.useEffect(function()
    
    if #calculatingContestants == 0 then
      
      setCalculatingContestants(properties.contestants);

    end;

  end, {calculatingContestants});

  local ContestantDatas = {};
  for index, contestant in properties.contestants do

    table.insert(ContestantDatas, React.createElement(ContestantData, {
      contestant = contestant;
      layoutOrder = index;
      key = contestant.id;  
    }));

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
    ContestantDatas = React.createElement(React.Fragment, {}, ContestantDatas);
  })

end;

return ContestantHypeSection;