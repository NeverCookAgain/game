--!strict

local ServerStorage = game:GetService("ServerStorage");

local ICustomer = require(ServerStorage.Customer.types);
local IItem = require(ServerStorage.Item.types);
local ISandwich = require(ServerStorage.Sandwich.types);

export type ContestantBaseProperties = {
  assignedCustomer: ICustomer.ICustomer?;
  player: Player?;
  inventorySlots: number;
  model: Model?;
  headshotImage: string;
}

export type ContestantConstructorProperties = ContestantBaseProperties & {
  servedCustomers: {ICustomer.ICustomer}?;
  inventory: {IItem.IItem | ISandwich.ISandwich}?;
}

export type ContestantProperties = ContestantBaseProperties & {
  servedCustomers: {ICustomer.ICustomer};
  inventory: {IItem.IItem | ISandwich.ISandwich};
};

export type ContestantMethods = {
  setAssignedCustomer: (self: IContestant, customer: ICustomer.ICustomer?) -> ();
  addServedCustomer: (self: IContestant, customer: ICustomer.ICustomer) -> ();
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