--!strict

local ServerStorage = game:GetService("ServerStorage");

local ICustomer = require(ServerStorage.Customer.types);
local IItem = require(ServerStorage.Item.types);
local ISandwich = require(ServerStorage.Sandwich.types);

export type ContestantProperties = {
  assignedCustomer: ICustomer.ICustomer?;
  player: Player?;
  inventorySlots: number;
  model: Model?;
  inventory: {IItem.IItem | ISandwich.ISandwich};
};

export type ContestantMethods = {
  setAssignedCustomer: (self: IContestant, customer: ICustomer.ICustomer?) -> ();
  addToInventory: (self: IContestant, item: IItem.IItem | ISandwich.ISandwich) -> ();
  removeFromInventory: (self: IContestant, item: IItem.IItem | ISandwich.ISandwich) -> ();
};

export type ContestantEvents = {
  InventoryChanged: RBXScriptSignal;
  CustomerAssignmentChanged: RBXScriptSignal<ICustomer.ICustomer?>;
}

export type IContestant = ContestantProperties & ContestantMethods & ContestantEvents;

return {};