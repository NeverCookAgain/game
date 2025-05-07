--!strict

local ServerStorage = game:GetService("ServerStorage");

local IItem = require(ServerStorage.Classes.Item.types);
local ISandwich = require(ServerStorage.Classes.Sandwich.types);

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