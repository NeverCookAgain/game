--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage");

local React = require(ReplicatedStorage.Shared.Packages.react);
local IContestant = require(ReplicatedStorage.Client.Contestant.types);

export type ContestantsSectionProperties = {
  contestants: {IContestant.IContestant};
}

local function CompetitionResultsSection(properties: ContestantsSectionProperties)

  local selectedContestant, setSelectedContestant = React.useState(nil :: IContestant.IContestant?);

  local contestantScores = {};
  local loserButtons = {};
  local bestContestant = nil;
  for _, contestant in properties.contestants do

    contestantScores[contestant] = contestant:getOrderAccuracy();
    
    local function insertLoserButton(losingContestant: IContestant.IContestant)
      
      local button = React.createElement("TextButton", {
        AutomaticSize = Enum.AutomaticSize.XY;
        BackgroundTransparency = 1;
        LayoutOrder = #loserButtons + 1;
        Size = UDim2.new();
        Text = "";
        key = contestant.id;
        [React.Event.Activated] = function()

          setSelectedContestant(losingContestant);

        end;
      }, {
        UIListLayout = React.createElement("UIListLayout", {
          Padding = UDim.new(0, 15);
          SortOrder = Enum.SortOrder.LayoutOrder;
          FillDirection = Enum.FillDirection.Horizontal;
          VerticalAlignment = Enum.VerticalAlignment.Center;
        });
        LoserImageLabel = React.createElement("ImageLabel", {
          BackgroundTransparency = 1;
          Image = losingContestant.headshotImages.sad;
          Size = UDim2.new(0, 60, 0, 60);
          ImageTransparency = 0.5;
        });
        LoserScoreTextLabel = React.createElement("TextLabel", {
          AutomaticSize = Enum.AutomaticSize.XY;
          BackgroundTransparency = 1;
          FontFace = Font.fromName("Kalam", Enum.FontWeight.Bold);
          LayoutOrder = 1;
          Size = UDim2.new();
          Text = contestantScores[bestContestant];
          TextSize = 30;
          TextColor3 = Color3.new();
        });
      });

      table.insert(loserButtons, button);

    end;

    if bestContestant == nil or contestantScores[contestant] > contestantScores[bestContestant] then

      if bestContestant then

        insertLoserButton(bestContestant);

      end;

      bestContestant = contestant;

    else

      insertLoserButton(contestant);

    end;

  end;

  -- Show the results.
  local correctSandwichIngredientCount = (selectedContestant or bestContestant):getOrderAccuracy();
  return React.createElement("Frame", {
    AutomaticSize = Enum.AutomaticSize.Y;
    BackgroundTransparency = 1;
    LayoutOrder = 2; 
    Size = UDim2.new(1, 0, 0, 0);
  }, {
    UIListLayout = React.createElement("UIListLayout", {
      Padding = UDim.new(0, 15);
      SortOrder = Enum.SortOrder.LayoutOrder;
      HorizontalAlignment = Enum.HorizontalAlignment.Center;
    });
    WinnerNameTextLabel = React.createElement("TextLabel", {
      AutomaticSize = Enum.AutomaticSize.XY;
      BackgroundTransparency = 1;
      FontFace = Font.fromName("Kalam", Enum.FontWeight.Bold);
      LayoutOrder = 1;
      Size = UDim2.new();
      Text = if selectedContestant and selectedContestant.player then selectedContestant.player.Name elseif bestContestant.player then bestContestant.player.Name else "Unknown player";
      TextSize = 30;
      TextColor3 = Color3.new();
    });
    ContestantRowSection = React.createElement("Frame", {
      AutomaticSize = Enum.AutomaticSize.Y;
      BackgroundTransparency = 1;
      LayoutOrder = 2;
      Size = UDim2.new(1, 0, 0, 0);
    }, {
      UIListLayout = React.createElement("UIListLayout", {
        HorizontalFlex = Enum.UIFlexAlignment.SpaceBetween;
        SortOrder = Enum.SortOrder.LayoutOrder;
        FillDirection = Enum.FillDirection.Horizontal;
        VerticalAlignment = Enum.VerticalAlignment.Center;
      });
      UIPadding = React.createElement("UIPadding", {
        PaddingLeft = UDim.new(0, 15);
        PaddingRight = UDim.new(0, 15);
      });
      LoserSection = React.createElement("Frame", {
        AutomaticSize = Enum.AutomaticSize.XY;
        BackgroundTransparency = 1;
        LayoutOrder = 1; 
        Size = UDim2.new();
      }, {
        UIListLayout = React.createElement("UIListLayout", {
          SortOrder = Enum.SortOrder.LayoutOrder;
        });
        LoserButtons = React.createElement(React.Fragment, {}, loserButtons);
      });
      WinnerHeadshotButton = React.createElement("ImageButton", {
        BackgroundTransparency = 1;
        LayoutOrder = 2;
        Image = bestContestant.headshotImages.happy;
        Size = UDim2.new(0, 100, 0, 100);
        [React.Event.Activated] = function()

          setSelectedContestant(bestContestant);

        end;
      });
      SelectedContestantDetailsSection = React.createElement("Frame", {
        AutomaticSize = Enum.AutomaticSize.XY;
        BackgroundTransparency = 1;
        LayoutOrder = 3; 
        Size = UDim2.new();
      }, {
        UIListLayout = React.createElement("UIListLayout", {
          Padding = UDim.new(0, 15);
          SortOrder = Enum.SortOrder.LayoutOrder;
        });
        FinalScoreTextLabel = React.createElement("TextLabel", {
          AutomaticSize = Enum.AutomaticSize.XY;
          BackgroundTransparency = 1;
          FontFace = Font.fromName("Kalam", Enum.FontWeight.Bold);
          LayoutOrder = 1;
          Size = UDim2.new();
          Text = "FINAL SCORE";
          TextSize = 22;
          TextColor3 = Color3.new();
        });
        ScoreTextLabel = React.createElement("TextLabel", {
          AutomaticSize = Enum.AutomaticSize.XY;
          BackgroundTransparency = 1;
          FontFace = Font.fromName("Kalam", Enum.FontWeight.Bold);
          LayoutOrder = 2;
          Size = UDim2.new();
          Text = correctSandwichIngredientCount;
          TextSize = 30;
          TextColor3 = Color3.new();
        });
      });
    });
    
  })

end;

return CompetitionResultsSection;