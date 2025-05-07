--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage");

local IItem = require(ReplicatedStorage.Client.Classes.Item.types);
local ICustomer = require(ReplicatedStorage.Client.Classes.Customer.types);
local ISandwich = require(ReplicatedStorage.Client.Classes.Sandwich.types);
local ActionItem = require(ReplicatedStorage.Client.Interfaces.ActionItem);

type ActionItem = ActionItem.ActionItem;

export type ContestantBaseProperties = {
  actionItem: ActionItem?;
  assignedCustomerID: string?;
  player: Player?;
  inventorySlots: number;
  model: Model?;
  characterName: string;
  headshotImages: {
    default: number;
    happy: number;
    sad: number;
    walkCycle: {number};
  };
  id: string;
};

export type ContestantConstructorProperties = ContestantBaseProperties & {
  servedCustomers: {ICustomer.ICustomer}?;
  inventory: {IItem.IItem | ISandwich.ISandwich}?;
}

export type ContestantProperties = ContestantBaseProperties & {
  type: "Contestant";
  servedCustomers: {ICustomer.ICustomer};
  inventory: {IItem.IItem | ISandwich.ISandwich};
};

export type ContestantMethods = {
  getOrderAccuracy: (self: IContestant) -> (number, number);
};

export type ContestantEvents = {
  InventoryChanged: RBXScriptSignal;
}

export type IContestant = ContestantProperties & ContestantMethods & ContestantEvents;

return {};