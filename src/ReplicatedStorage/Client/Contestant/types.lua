--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage");

local IItem = require(ReplicatedStorage.Client.Item.types);
local ICustomer = require(ReplicatedStorage.Client.Customer.types);
local ISandwich = require(ReplicatedStorage.Client.Sandwich.types);

export type ContestantBaseProperties = {
  assignedCustomer: ICustomer.ICustomer?;
  player: Player?;
  inventorySlots: number;
  model: Model?;
  headshotImage: string;
  id: number;
};

export type ContestantConstructorProperties = ContestantBaseProperties & {
  servedCustomers: {ICustomer.ICustomer}?;
  inventory: {IItem.IItem | ISandwich.ISandwich}?;
}

export type ContestantProperties = ContestantBaseProperties & {
  type: "Contestant";
};

export type ContestantMethods = {
  getOrderAccuracy: (self: IContestant) -> (number, number);
};

export type ContestantEvents = {
  InventoryChanged: RBXScriptSignal;
}

export type IContestant = ContestantProperties & ContestantMethods & ContestantEvents;

return {};