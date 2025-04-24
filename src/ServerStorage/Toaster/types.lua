--!strict

local ServerStorage = game:GetService("ServerStorage");

local IItem = require(ServerStorage.Item.types);
local ISandwich = require(ServerStorage.Sandwich.types);

export type ToasterProperties = {
  model: Model;
  item: IItem.IItem | ISandwich.ISandwich?;
};

export type ToasterMethods = {
  setItem: (self: IToaster, newItem: (IItem.IItem | ISandwich.ISandwich)?) -> ()
};

export type ToasterEvents = {
  ItemChanged: RBXScriptSignal;
}

export type IToaster = ToasterProperties & ToasterMethods & ToasterEvents;

return {};