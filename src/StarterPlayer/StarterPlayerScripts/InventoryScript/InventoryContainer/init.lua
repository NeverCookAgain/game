--!strict

local ContextActionService = game:GetService("ContextActionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");

local React = require(ReplicatedStorage.Shared.Packages.react);
local InventoryButton = require(script.InventoryButton);

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
  local selectedItemSlot: number?, setSelectedItemSlot = React.useState(nil :: number?);
  React.useEffect(function()
  
    local function refreshInventory()

      local contestant = ReplicatedStorage.Shared.Functions.GetContestant:InvokeServer();
      setInventory(contestant.inventory);
      setInventorySlots(contestant.inventorySlots);
      if not selectedItemSlot and #contestant.inventory > 0 then

        setSelectedItemSlot(1);

      else

        setSelectedItemSlot();
      
      end;

    end;

    local contestantInventoryChanged = ReplicatedStorage.Shared.Events.ContestantInventoryChanged.OnClientEvent:Connect(refreshInventory);

    task.spawn(refreshInventory);

    return function()

      contestantInventoryChanged:Disconnect();

    end;

  end, {});

  React.useEffect(function()
  
    local function onHotkeyInput(actionName: string, inputState: Enum.UserInputState, inputObject: InputObject)

      local map = {
        [Enum.KeyCode.One] = 1;
        [Enum.KeyCode.Two] = 2;
        [Enum.KeyCode.Three] = 3;
        [Enum.KeyCode.Four] = 4;
        [Enum.KeyCode.Five] = 5;
        [Enum.KeyCode.Six] = 6;
        [Enum.KeyCode.Seven] = 7;
        [Enum.KeyCode.Eight] = 8;
        [Enum.KeyCode.Nine] = 9;
        [Enum.KeyCode.KeypadOne] = 1;
        [Enum.KeyCode.KeypadTwo] = 2;
        [Enum.KeyCode.KeypadThree] = 3;
        [Enum.KeyCode.KeypadFour] = 4;
        [Enum.KeyCode.KeypadFive] = 5;
        [Enum.KeyCode.KeypadSix] = 6;
        [Enum.KeyCode.KeypadSeven] = 7;
        [Enum.KeyCode.KeypadEight] = 8;
        [Enum.KeyCode.KeypadNine] = 9;
      }

      local newSelectedSlot = map[inputObject.KeyCode];

      if inputState == Enum.UserInputState.Begin and newSelectedSlot then

        local item = inventory[newSelectedSlot];
        if item then

          setSelectedItemSlot(newSelectedSlot);

        end;

      end;

    end;

    ContextActionService:BindAction(
      "InventoryHotkey", onHotkeyInput, false, Enum.KeyCode.One, Enum.KeyCode.Two, 
      Enum.KeyCode.Three, Enum.KeyCode.Four, Enum.KeyCode.Five, Enum.KeyCode.Six, 
      Enum.KeyCode.Seven, Enum.KeyCode.Eight, Enum.KeyCode.Nine, Enum.KeyCode.KeypadOne, 
      Enum.KeyCode.KeypadTwo, Enum.KeyCode.KeypadThree, Enum.KeyCode.KeypadFour, 
      Enum.KeyCode.KeypadFive, Enum.KeyCode.KeypadSix, Enum.KeyCode.KeypadSeven, 
      Enum.KeyCode.KeypadEight, Enum.KeyCode.KeypadNine
    );

    return function()

      ContextActionService:UnbindAction("InventoryHotkey");

    end;

  end, {inventory});

  React.useEffect(function()
  
    ReplicatedStorage.Client.Functions.GetSelectedItem.OnInvoke = function()

      return inventory[selectedItemSlot];

    end;

    ReplicatedStorage.Client.Events.SelectedItemChanged:Fire(inventory[selectedItemSlot]);
    ReplicatedStorage.Shared.Events.SelectedItemChanged:FireServer(selectedItemSlot);

    return function()

      ReplicatedStorage.Client.Functions.GetSelectedItem.OnInvoke = nil;

    end;

  end, {inventory :: unknown, selectedItemSlot});

  local inventoryButtons = {};
  for index = 1, inventorySlots do

    local item = inventory[index];

    local inventoryButton = React.createElement(InventoryButton, {
      key = index;
      layoutOrder = index;
      item = item;
      isSelected = selectedItemSlot == index;
      onSelect = function()

        setSelectedItemSlot(index);

      end;
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