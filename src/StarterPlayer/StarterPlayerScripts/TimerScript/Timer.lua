--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage");

local React = require(ReplicatedStorage.Shared.Packages.react);
local Fonts = require(ReplicatedStorage.Client.Fonts);

local function InventoryContainer()

  local shownCompletionTimeMilliseconds, setShownCompletionTimeMilliseconds = React.useState(nil :: number?);
  local completionTimeMilliseconds, setCompletionTimeMilliseconds = React.useState(nil);

  React.useEffect(function()
  
    local function updateTime()

      local round = ReplicatedStorage.Shared.Functions.GetRound:InvokeServer();
      setCompletionTimeMilliseconds(round.completionTimeMilliseconds);

    end;

    local roundChangedEvent = ReplicatedStorage.Shared.Events.RoundChanged.OnClientEvent:Connect(updateTime);
    task.spawn(updateTime);

    return function()

      roundChangedEvent:Disconnect();

    end;

  end, {});

  React.useEffect(function()

    task.spawn(function()

      if completionTimeMilliseconds then

        task.wait();
        local remainingTime = math.max(completionTimeMilliseconds - DateTime.now().UnixTimestampMillis, 0);
        setShownCompletionTimeMilliseconds(remainingTime);

      end;
    
    end);

  end, {completionTimeMilliseconds :: number?, shownCompletionTimeMilliseconds});

  local formattedTime = "--:--.---"
  if shownCompletionTimeMilliseconds then

    local totalSeconds = math.floor(shownCompletionTimeMilliseconds / 1000);
    local totalMinutes = math.floor(totalSeconds / 60);

    local seconds = totalSeconds % 60;
    local minutes = totalMinutes;
    local milliseconds = shownCompletionTimeMilliseconds % 1000;

    formattedTime = `{if minutes < 9 then "0" else ""}{minutes}:{if seconds < 10 then "0" else ""}{seconds}.{if milliseconds < 10 then "00" elseif milliseconds < 100 then "0" else ""}{milliseconds}`;

  end;

  return React.createElement("Frame", {
    AnchorPoint = Vector2.new(0.5, 0);
    AutomaticSize = Enum.AutomaticSize.XY;
    BackgroundTransparency = 1;
    Position = UDim2.new(0.5, 0, 0, 0);
  }, {
    UIPadding = React.createElement("UIPadding", {
      PaddingTop = UDim.new(0, 15);
    });
    TextLabel = React.createElement("TextLabel", {
      AutomaticSize = Enum.AutomaticSize.XY;
      BackgroundTransparency = 1;
      FontFace = Fonts.Bold;
      TextColor3 = Color3.new(1, 1, 1);
      TextSize = 24;
      Text = formattedTime;
    });
  })

end;

return InventoryContainer;