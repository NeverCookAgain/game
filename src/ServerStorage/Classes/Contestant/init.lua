--!strict

local ServerStorage = game:GetService("ServerStorage");
local HttpService = game:GetService("HttpService");

local IRound = require(ServerStorage.Classes.Round.types);
local IItem = require(ServerStorage.Classes.Item.types);
local IContestant = require(script.types);
local ISandwich = require(ServerStorage.Classes.Sandwich.types);
local ActionItem = require(ServerStorage.Classes.ActionItem.Interface);
type ActionItem = ActionItem.ActionItem;

local characterImages = {
  ["Bill Burgers"] = {
    default = 132812371775588;
    happy = 72985907419460;
    sad = 112655319908614;
    walkCycle = {138071730441626, 127157712731282, 90099424286222, 88329203120597, 110743064881685, 138805926032055, 137674659781586, 80218653204415, 72783473022560};
  };
  ["Cousin Ricky"] = {
    default = 132812371775588;
    happy = 72985907419460;
    sad = 112655319908614;
    walkCycle = {101179113657658, 72456353728815, 74023365147120, 84568545789745, 84221731425282, 125141715909319, 96317242389211, 138771972855705, 83072127541618};
  };
  ["Rigatoni"] = {
    default = 132812371775588;
    happy = 72985907419460;
    sad = 112655319908614;
    walkCycle = {124300111633989, 83577062913571, 112527405256497, 115630068689201, 133408639133670, 95304001342245, 129917576236035, 95438706651335, 129018058977258};
  };
  ["Sweaty Todd"] = {
    default = 132812371775588;
    happy = 72985907419460;
    sad = 112655319908614;
    walkCycle = {137724741783793, 122624972898810, 75810862119768, 94575600521497, 135821123610944, 87232080596281, 76543161991488, 82722481290570, 137636329645070};
  }
}

local Contestant = {};

function Contestant.new(properties: IContestant.ContestantConstructorProperties, round: IRound.IRound): IContestant.IContestant

  local inventoryChangedEvent = Instance.new("BindableEvent");
  local customerAssignmentChangedEvent = Instance.new("BindableEvent");
  local customerServedEvent = Instance.new("BindableEvent");

  local function addToInventory(self: IContestant.IContestant, item: IItem.IItem | ISandwich.ISandwich): ()

    assert(#self.inventory < self.inventorySlots, "Inventory is full.");
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

  local function setActionItem(self: IContestant.IContestant, actionItem: ActionItem?): ()

    self.actionItem = actionItem;
    inventoryChangedEvent:Fire();

  end;

  local contestant: IContestant.IContestant = {
    id = properties.id or HttpService:GenerateGUID(false);
    player = properties.player;
    model = properties.model;
    inventorySlots = properties.inventorySlots or 2;
    inventory = properties.inventory or {};
    actionItem = properties.actionItem;
    characterName = properties.characterName;
    headshotImages = characterImages[properties.characterName];
    assignedCustomerID = properties.assignedCustomerID;
    selectedItem = properties.selectedItem;
    addToInventory = addToInventory;
    setSelectedItem = setSelectedItem;
    removeFromInventory = removeFromInventory;
    setAssignedCustomerID = setAssignedCustomerID;
    setActionItem = setActionItem;
    CustomerServed = customerServedEvent.Event;
    InventoryChanged = inventoryChangedEvent.Event;
    CustomerAssignmentChanged = customerAssignmentChangedEvent.Event;
  };

  return contestant;

end;

return Contestant;