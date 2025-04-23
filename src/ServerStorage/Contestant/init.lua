--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerStorage = game:GetService("ServerStorage");

local Contestant = {};
local IItem = require(ServerStorage.Item.types);
local IContestant = require(script.types);

function Contestant.new(properties: IContestant.ContestantProperties): IContestant.IContestant

  local inventoryChangedEvent = Instance.new("BindableEvent");

  local function addItemToInventory(self: IContestant.IContestant, item: IItem.IItem): ()

    table.insert(self.inventory, item);
    ReplicatedStorage.Shared.Events.RoundChanged:FireAllClients(self);
    inventoryChangedEvent:Fire();

  end;

  local contestant: IContestant.IContestant = {
    player = properties.player;
    model = properties.model;
    inventory = {};
    addItemToInventory = addItemToInventory;
    InventoryChanged = inventoryChangedEvent.Event;
  };

  return contestant;

end;

return Contestant;