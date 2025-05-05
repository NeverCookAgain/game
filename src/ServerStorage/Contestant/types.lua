--!strict

local ServerStorage = game:GetService("ServerStorage");

local ICustomer = require(ServerStorage.Customer.types);
local IItem = require(ServerStorage.Item.types);
local ISandwich = require(ServerStorage.Sandwich.types);

export type ContestantBaseProperties = {
  assignedCustomerID: string?;
  player: Player?;
  inventorySlots: number;
  model: Model?;
  headshotImages: {
    default: string;
    happy: string;
    sad: string;
  };
}

export type ContestantConstructorProperties = ContestantBaseProperties & {
  id: string?;
  inventory: {IItem.IItem | ISandwich.ISandwich}?;
}

export type ContestantProperties = ContestantBaseProperties & {
  id: string;
  inventory: {IItem.IItem | ISandwich.ISandwich};
};

export type ContestantMethods = {
  setAssignedCustomerID: (self: IContestant, customerID: string?) -> ();
  addToInventory: (self: IContestant, item: IItem.IItem | ISandwich.ISandwich) -> ();
  removeFromInventory: (self: IContestant, item: IItem.IItem | ISandwich.ISandwich) -> ();
};

export type ContestantEvents = {
  InventoryChanged: RBXScriptSignal;
  CustomerAssignmentChanged: RBXScriptSignal<ICustomer.ICustomer?>;
  CustomerServed: RBXScriptSignal<ICustomer.ICustomer>;
}

export type IContestant = ContestantProperties & ContestantMethods & ContestantEvents;

return {};