--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");

local React = require(ReplicatedStorage.Shared.Packages.react);
local IContestant = require(ReplicatedStorage.Client.Classes.Contestant.types);

export type ContestantPerformanceSectionProperties = {
  contestant: IContestant.IContestant;
  layoutOrder: number;
}

local function ContestantHypeSection(properties: ContestantPerformanceSectionProperties)

  local shownFinalScore, setShownFinalScore = React.useState(0);
  React.useEffect(function()

    task.delay(0.05, function()
    
      setShownFinalScore(Random.new():NextInteger(0, 99999));

    end);

  end, {shownFinalScore});

  local headshotImage = React.useRef(nil :: ImageLabel?);
  React.useEffect(function()

    local rotationTask = task.spawn(function()
    
      if headshotImage.current == nil then

        return;

      end;

      while task.wait() and headshotImage.current do

        local leftTween = TweenService:Create(headshotImage.current, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
          Rotation = -20;
        });

        leftTween:Play();
        leftTween.Completed:Wait();

        local rightTween = TweenService:Create(headshotImage.current, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
          Rotation = 20;
        });

        rightTween:Play();
        rightTween.Completed:Wait();

      end;

    end);

    local highlightTask = task.spawn(function()

      if headshotImage.current == nil then

        return;

      end;

      headshotImage.current.ImageTransparency = 0.5;

      while task.wait() and headshotImage.current do

        task.wait(properties.layoutOrder - 1);

        local highlightTween = TweenService:Create(headshotImage.current, TweenInfo.new(0.5), {
          ImageTransparency = 0;
        });

        highlightTween:Play();
        highlightTween.Completed:Wait();
        task.wait(0.5);

        local removeHighlightTween = TweenService:Create(headshotImage.current, TweenInfo.new(0.5), {
          ImageTransparency = 0.5;
        });

        removeHighlightTween:Play();
        removeHighlightTween.Completed:Wait();
        task.wait(0.5);

      end;

    end);

    return function()

      task.cancel(rotationTask);
      task.cancel(highlightTask);

    end;

  end, {});

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
    ContestantImageLabelContainer = React.createElement("Frame", {
      AutomaticSize = Enum.AutomaticSize.XY;
      BackgroundTransparency = 1;
      LayoutOrder = 1
    }, {
      ContestantImageLabel = React.createElement("ImageLabel", {
        BackgroundTransparency = 1;
        LayoutOrder = 1;
        Image = properties.contestant.headshotImages.default;
        Size = UDim2.new(0, 100, 0, 100);
        ref = headshotImage;
      });
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