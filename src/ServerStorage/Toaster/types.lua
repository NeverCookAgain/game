--!strict

local ServerStorage = game:GetService("ServerStorage");

local IItem = require(ServerStorage.Item.types);

export type ToasterProperties = {
  model: Model;
  item: IItem.IItem?;
};

export type ToasterMethods = {
  setItem: (self: IToaster, newItem: IItem.IItem?) -> ()
};

export type ToasterEvents = {
  ItemChanged: RBXScriptSignal;
}

export type IToaster = ToasterProperties & ToasterMethods & ToasterEvents;

return {};