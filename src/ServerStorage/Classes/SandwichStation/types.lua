--!strict

local ServerStorage = game:GetService("ServerStorage");

local IItem = require(ServerStorage.Classes.Item.types);
local ISandwich = require(ServerStorage.Classes.Sandwich.types);

export type SandwichStationProperties = {
  model: Model;
  sandwich: ISandwich.ISandwich?;
};

export type SandwichStationMethods = {
  pushItem: (self: ISandwichStation, item: IItem.IItem | ISandwich.ISandwich) -> ();
  popItem: (self: ISandwichStation) -> IItem.IItem;
  completeSandwich: (self: ISandwichStation) -> ISandwich.ISandwich | IItem.IItem;
  updateSandwichModel: (self: ISandwichStation) -> ();
};

export type SandwichStationEvents = {
  SandwichChanged: RBXScriptSignal;
  SandwichCompleted: RBXScriptSignal;
}

export type ISandwichStation = SandwichStationProperties & SandwichStationMethods & SandwichStationEvents;

return {};