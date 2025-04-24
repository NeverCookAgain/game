--!strict

local ServerStorage = game:GetService("ServerStorage");

local IItem = require(ServerStorage.Item.types);
local ISandwich = require(ServerStorage.Sandwich.types);

export type ContestantProperties = {
  player: Player?;
  inventorySlots: number;
  model: Model?;
  inventory: {IItem.IItem | ISandwich.ISandwich};
};

export type ContestantMethods = {
  addToInventory: (self: IContestant, item: IItem.IItem | ISandwich.ISandwich) -> ();
  removeFromInventory: (self: IContestant, item: IItem.IItem | ISandwich.ISandwich) -> ();
};

export type ContestantEvents = {
  InventoryChanged: RBXScriptSignal;
}

export type IContestant = ContestantProperties & ContestantMethods & ContestantEvents;

return {};