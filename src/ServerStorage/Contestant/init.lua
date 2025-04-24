--!strict

local ServerStorage = game:GetService("ServerStorage");

local ICustomer = require(ServerStorage.Customer.types);
local IRound = require(ServerStorage.Round.types);
local IItem = require(ServerStorage.Item.types);
local IContestant = require(script.types);
local ISandwich = require(ServerStorage.Sandwich.types);

local Contestant = {};

function Contestant.new(properties: IContestant.ContestantProperties, round: IRound.IRound): IContestant.IContestant

  local inventoryChangedEvent = Instance.new("BindableEvent");
  local customerAssignmentChangedEvent = Instance.new("BindableEvent");

  local function addToInventory(self: IContestant.IContestant, item: IItem.IItem | ISandwich.ISandwich): ()

    table.insert(self.inventory, item);
    inventoryChangedEvent:Fire();

  end;

  local function removeFromInventory(self: IContestant.IContestant, item: IItem.IItem | ISandwich.ISandwich): ()

    for index = #self.inventory, 1, -1 do

      if self.inventory[index] == item then

        table.remove(self.inventory, index);
        inventoryChangedEvent:Fire();
        break;

      end;

    end;

  end;

  local function setAssignedCustomer(self: IContestant.IContestant, customer: ICustomer.ICustomer?): ()

    self.assignedCustomer = customer;
    customerAssignmentChangedEvent:Fire(customer);

  end;

  local contestant: IContestant.IContestant = {
    player = properties.player;
    model = properties.model;
    inventorySlots = properties.inventorySlots;
    inventory = {};
    addToInventory = addToInventory;
    removeFromInventory = removeFromInventory;
    setAssignedCustomer = setAssignedCustomer;
    InventoryChanged = inventoryChangedEvent.Event;
    CustomerAssignmentChanged = customerAssignmentChangedEvent.Event;
  };

  return contestant;

end;

return Contestant;