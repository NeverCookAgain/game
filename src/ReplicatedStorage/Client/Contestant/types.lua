--!strict

local ServerStorage = game:GetService("ServerStorage");

local IItem = require(ServerStorage.Item.types);

export type ContestantProperties = {
  player: Player?;
  inventorySlots: number;
};

export type ContestantMethods = {
  addItemToInventory: (self: IContestant, item: IItem.IItem) -> ();
  removeItemFromInventory: (self: IContestant, item: IItem.IItem) -> ();
};

export type ContestantEvents = {
  InventoryChanged: RBXScriptSignal;
}

export type IContestant = ContestantProperties & ContestantMethods & ContestantEvents;

return {};