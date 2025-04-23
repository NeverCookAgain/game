--!strict

local ServerStorage = game:GetService("ServerStorage");

local Item = require(ServerStorage.Item.types);

export type ContestantProperties = {
  player: Player?;
  model: Model?;
  inventory: {Item.Item};
};

export type ContestantMethods = {
  addItemToInventory: () -> ();
};

export type ContestantEvents = {
  ItemObtained: RBXScriptSignal;
}

export type Contestant = ContestantProperties & ContestantMethods & ContestantEvents;

return {};