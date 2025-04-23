--!strict

local ServerStorage = game:GetService("ServerStorage");

local Contestant = {};
local IRound = require(ServerStorage.Round.types);
local IItem = require(ServerStorage.Item.types);
local IContestant = require(script.types);

function Contestant.new(properties: IContestant.ContestantProperties, round: IRound.IRound): IContestant.IContestant

  local inventoryChangedEvent = Instance.new("BindableEvent");

  local function getInventory(self: IContestant.IContestant, item: IItem.IItem): ()

    table.insert(self.inventory, item);
    inventoryChangedEvent:Fire();

  end;

  local contestant: IContestant.IContestant = {
    player = properties.player;
    model = properties.model;
    inventorySlots = properties.inventorySlots;
    getInventory = getInventory;
    InventoryChanged = inventoryChangedEvent.Event;
  };

  return contestant;

end;

return Contestant;