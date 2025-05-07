--!strict

local ServerStorage = game:GetService("ServerStorage");

local ICustomer = require(ServerStorage.Classes.Customer.types);
local IItem = require(ServerStorage.Classes.Item.types);
local ISandwich = require(ServerStorage.Classes.Sandwich.types);
local ActionItem = require(ServerStorage.Classes.ActionItem.Interface);

type ActionItem = ActionItem.ActionItem;

export type ContestantBaseProperties = {
  assignedCustomerID: string?;
  player: Player?;
  model: Model?;
  headshotImages: {
    default: string;
    happy: string;
    sad: string;
  };
  selectedItem: (IItem.IItem | ISandwich.ISandwich)?;
  actionItem: ActionItem?;
}

export type ContestantConstructorProperties = ContestantBaseProperties & {
  id: string?;
  inventory: {IItem.IItem | ISandwich.ISandwich}?;
  inventorySlots: number?;
}

export type ContestantProperties = ContestantBaseProperties & {
  id: string;
  inventory: {IItem.IItem | ISandwich.ISandwich};
  inventorySlots: number;
};

export type ContestantMethods = {
  setAssignedCustomerID: (self: IContestant, customerID: string?) -> ();
  addToInventory: (self: IContestant, item: IItem.IItem | ISandwich.ISandwich) -> ();
  setSelectedItem: (self: IContestant, item: (IItem.IItem | ISandwich.ISandwich)?) -> ();
  removeFromInventory: (self: IContestant, item: IItem.IItem | ISandwich.ISandwich) -> ();
  setActionItem: (self: IContestant, actionItem: ActionItem?) -> ();
};

export type ContestantEvents = {
  InventoryChanged: RBXScriptSignal;
  CustomerAssignmentChanged: RBXScriptSignal<ICustomer.ICustomer?>;
  CustomerServed: RBXScriptSignal<ICustomer.ICustomer>;
}

export type IContestant = ContestantProperties & ContestantMethods & ContestantEvents;

return {};