--!strict

local ServerStorage = game:GetService("ServerStorage");
local HttpService = game:GetService("HttpService");

local IRound = require(ServerStorage.Round.types);
local IItem = require(ServerStorage.Item.types);
local IContestant = require(script.types);
local ISandwich = require(ServerStorage.Sandwich.types);

local Contestant = {};

function Contestant.new(properties: IContestant.ContestantConstructorProperties, round: IRound.IRound): IContestant.IContestant

  local inventoryChangedEvent = Instance.new("BindableEvent");
  local customerAssignmentChangedEvent = Instance.new("BindableEvent");
  local customerServedEvent = Instance.new("BindableEvent");

  local function addToInventory(self: IContestant.IContestant, item: IItem.IItem | ISandwich.ISandwich): ()

    table.insert(self.inventory, item);
    inventoryChangedEvent:Fire();

  end;

  local function removeFromInventory(self: IContestant.IContestant, item: IItem.IItem | ISandwich.ISandwich): ()

    for index = #self.inventory, 1, -1 do

      if self.inventory[index] == item then

        table.remove(self.inventory, index);
        
        if self.selectedItem == item then

          self.selectedItem = nil;

        end;

        inventoryChangedEvent:Fire();
        break;

      end;

    end;

  end;

  local function setAssignedCustomerID(self: IContestant.IContestant, customerID: string?): ()

    self.assignedCustomerID = customerID;
    customerAssignmentChangedEvent:Fire(customerID);

  end;

  local function setSelectedItem(self: IContestant.IContestant, item: (IItem.IItem | ISandwich.ISandwich)?): ()

    if item then

      -- Verify that the item is in the inventory.
      local found = false;
      for _, inventoryItem in ipairs(self.inventory) do

        if inventoryItem == item then

          found = true;
          break;

        end;

      end;

      assert(found, "Item not found in inventory.");

    end;

    self.selectedItem = item;

  end;

  local contestant: IContestant.IContestant = {
    id = properties.id or HttpService:GenerateGUID(false);
    player = properties.player;
    model = properties.model;
    inventorySlots = properties.inventorySlots;
    inventory = properties.inventory or {};
    headshotImages = properties.headshotImages;
    assignedCustomerID = properties.assignedCustomerID;
    selectedItem = properties.selectedItem;
    addToInventory = addToInventory;
    setSelectedItem = setSelectedItem;
    removeFromInventory = removeFromInventory;
    setAssignedCustomerID = setAssignedCustomerID;
    CustomerServed = customerServedEvent.Event;
    InventoryChanged = inventoryChangedEvent.Event;
    CustomerAssignmentChanged = customerAssignmentChangedEvent.Event;
  };

  return contestant;

end;

return Contestant;