--!strict

local ServerStorage = game:GetService("ServerStorage");

local IItem = require(ServerStorage.Item.types);

export type SandwichStationProperties = {
  model: Model;
  sandwich: {IItem.IItem};
};

export type SandwichStationMethods = {
  pushItem: (self: ISandwichStation, item: IItem.IItem) -> ();
  popItem: (self: ISandwichStation) -> IItem.IItem;
  completeSandwich: (self: ISandwichStation) -> {IItem.IItem};
};

export type SandwichStationEvents = {
  SandwichChanged: RBXScriptSignal;
  SandwichCompleted: RBXScriptSignal;
}

export type ISandwichStation = SandwichStationProperties & SandwichStationMethods & SandwichStationEvents;

return {};