--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage");

local React = require(ReplicatedStorage.Shared.Packages.react);
local InventoryButton = require(script.Parent.InventoryButton);

export type InventoryContainerProperties = {
  onClose: () -> ();
}

local function InventoryContainer(properties: InventoryContainerProperties)

  React.useEffect(function()
    
    local function checkRound()

      local round = ReplicatedStorage.Shared.Functions.GetRound:InvokeServer();
      if round.status == "Ended" then

        properties.onClose();

      end;

    end;

    local roundEndedEvent = ReplicatedStorage.Shared.Events.RoundChanged.OnClientEvent:Connect(checkRound);

    return function()

      roundEndedEvent:Disconnect();

    end;

  end, {});

  local inventory, setInventory = React.useState({});
  local inventorySlots, setInventorySlots = React.useState(0);
  React.useEffect(function()
  
    local function refreshInventory()

      local contestant = ReplicatedStorage.Shared.Functions.GetContestant:InvokeServer();
      setInventory(contestant.inventory);
      setInventorySlots(contestant.inventorySlots);

    end;

    local contestantInventoryChanged = ReplicatedStorage.Shared.Events.ContestantInventoryChanged.OnClientEvent:Connect(refreshInventory);

    task.spawn(refreshInventory);

    return function()

      contestantInventoryChanged:Disconnect();

    end;

  end, {});

  local inventoryButtons = {};
  for index = 1, inventorySlots do

    local inventoryButton = React.createElement(InventoryButton, {
      key = index;
      layoutOrder = index;
      item = inventory[index];
    });
    table.insert(inventoryButtons, inventoryButton);

  end;

  return React.createElement("Frame", {
    AnchorPoint = Vector2.new(1, 1);
    AutomaticSize = Enum.AutomaticSize.XY;
    BackgroundTransparency = 1;
    Position = UDim2.new(1, 0, 1, 0);
  }, {
    UIListLayout = React.createElement("UIListLayout", {
      Padding = UDim.new(0, 15);
      SortOrder = Enum.SortOrder.LayoutOrder;
      FillDirection = Enum.FillDirection.Horizontal;
    });
    UIPadding = React.createElement("UIPadding", {
      PaddingBottom = UDim.new(0, 15);
      PaddingRight = UDim.new(0, 15);
    });
    InventoryButtons = React.createElement(React.Fragment, {}, inventoryButtons);
  })

end;

return InventoryContainer;