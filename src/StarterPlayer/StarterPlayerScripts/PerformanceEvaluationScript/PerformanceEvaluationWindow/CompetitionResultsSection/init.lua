--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage");

local React = require(ReplicatedStorage.Shared.Packages.react);

export type ContestantsSectionProperties = {
  contestants: {any};
}

local function CompetitionResultsSection(properties: ContestantsSectionProperties)

  -- Show the results.
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
      Text = "WINNER_NAME!";
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
        LoserButton = React.createElement("TextButton", {
          AutomaticSize = Enum.AutomaticSize.XY;
          BackgroundTransparency = 1;
          LayoutOrder = 1;
          Size = UDim2.new();
          Text = "";
        }, {
          UIListLayout = React.createElement("UIListLayout", {
            Padding = UDim.new(0, 15);
            SortOrder = Enum.SortOrder.LayoutOrder;
            FillDirection = Enum.FillDirection.Horizontal;
            VerticalAlignment = Enum.VerticalAlignment.Center;
          });
          LoserImageLabel = React.createElement("ImageLabel", {
            BackgroundTransparency = 1;
            Image = properties.contestants[2].headshotImage;
            Size = UDim2.new(0, 60, 0, 60);
          });
          LoserNameTextLabel = React.createElement("TextLabel", {
            AutomaticSize = Enum.AutomaticSize.XY;
            BackgroundTransparency = 1;
            FontFace = Font.fromName("Kalam", Enum.FontWeight.Bold);
            LayoutOrder = 1;
            Size = UDim2.new();
            Text = "0";
            TextSize = 30;
            TextColor3 = Color3.new();
          });
        });
        LoserButton2 = React.createElement("TextButton", {
          AutomaticSize = Enum.AutomaticSize.XY;
          BackgroundTransparency = 1;
          LayoutOrder = 1;
          Size = UDim2.new();
          Text = "";
        }, {
          UIListLayout = React.createElement("UIListLayout", {
            Padding = UDim.new(0, 15);
            SortOrder = Enum.SortOrder.LayoutOrder;
            FillDirection = Enum.FillDirection.Horizontal;
            VerticalAlignment = Enum.VerticalAlignment.Center;
          });
          LoserImageLabel = React.createElement("ImageLabel", {
            BackgroundTransparency = 1;
            Image = properties.contestants[2].headshotImage;
            Size = UDim2.new(0, 60, 0, 60);
          });
          LoserNameTextLabel = React.createElement("TextLabel", {
            AutomaticSize = Enum.AutomaticSize.XY;
            BackgroundTransparency = 1;
            FontFace = Font.fromName("Kalam", Enum.FontWeight.Bold);
            LayoutOrder = 1;
            Size = UDim2.new();
            Text = "0";
            TextSize = 30;
            TextColor3 = Color3.new();
          });
        });
      });
      WinnerHeadshotButton = React.createElement("ImageButton", {
        BackgroundTransparency = 1;
        LayoutOrder = 2;
        Image = properties.contestants[1].headshotImage;
        Size = UDim2.new(0, 100, 0, 100);
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
        ScoreTextLabel = React.createElement("TextLabel", {
          AutomaticSize = Enum.AutomaticSize.XY;
          BackgroundTransparency = 1;
          FontFace = Font.fromName("Kalam");
          LayoutOrder = 1;
          Size = UDim2.new();
          Text = "Score: 100%";
          TextSize = 30;
          TextColor3 = Color3.new();
        });
      });
    });
    
  })

end;

return CompetitionResultsSection;