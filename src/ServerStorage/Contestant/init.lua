--!strict

local ServerStorage = game:GetService("ServerStorage");

local Contestant = {};
local IRound = require(ServerStorage.Round.types);
local IItem = require(ServerStorage.Item.types);
local IContestant = require(script.types);

function Contestant.new(properties: IContestant.ContestantProperties, round: IRound.IRound): IContestant.IContestant

  local inventoryChangedEvent = Instance.new("BindableEvent");

  local function addItemToInventory(self: IContestant.IContestant, item: IItem.IItem): ()

    table.insert(self.inventory, item);
    inventoryChangedEvent:Fire();

  end;

  local function removeItemFromInventory(self: IContestant.IContestant, item: IItem.IItem): ()

    for index = #self.inventory, 1, -1 do

      if self.inventory[index] == item then

        table.remove(self.inventory, index);
        inventoryChangedEvent:Fire();
        break;

      end;

    end;

  end;

  local contestant: IContestant.IContestant = {
    player = properties.player;
    model = properties.model;
    inventory = {};
    addItemToInventory = addItemToInventory;
    removeItemFromInventory = removeItemFromInventory;
    InventoryChanged = inventoryChangedEvent.Event;
  };

  return contestant;

end;

return Contestant;