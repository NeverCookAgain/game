--!strict

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");

local Round = require(ReplicatedStorage.Client.Classes.Round);
local React = require(ReplicatedStorage.Shared.Packages.react);
local IContestant = require(ReplicatedStorage.Client.Classes.Contestant.types);
local InventoryButton = require(script.Parent.InventoryButton);

type Contestant = IContestant.IContestant;

export type Properties = {}

local function ActionItemContainer(properties: Properties)

  local contestant: Contestant?, setContestant = React.useState(nil :: Contestant?);
  local shouldActivate, setShouldActivate = React.useState(false);

  React.useEffect(function()

    local function updateContestant()

      local round = Round.getFromServerRound();
      if not round then return; end;

      local contestant = round:findContestantFromPlayer(Players.LocalPlayer);
      if not contestant then return; end;

      setContestant(contestant);

    end;

    task.spawn(updateContestant);

    local connection = ReplicatedStorage.Shared.Events.ContestantInventoryChanged.OnClientEvent:Connect(updateContestant);

    return function()

      connection:Disconnect();

    end;

  end, {});

  React.useEffect(function()
  
    if shouldActivate then

      task.spawn(function()
      
        ReplicatedStorage.Shared.Functions.ActivateActionItem:InvokeServer();
        setShouldActivate(false);

      end);

    end;

  end, {shouldActivate})

  return (
    if contestant and contestant.actionItem then
      React.createElement("Frame", {
        AnchorPoint = Vector2.new(1, 1);
        AutomaticSize = Enum.AutomaticSize.XY;
        BackgroundTransparency = 1;
        Position = UDim2.new(1, -15, 1, -80);
      }, {
        Button = React.createElement(InventoryButton, {
          isDisabled = shouldActivate;
          onSelect = function()

            setShouldActivate(true);

          end;
        });
      })
    else nil
  )
  
end;

return ActionItemContainer;