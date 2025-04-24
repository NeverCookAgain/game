--!strict

local ServerStorage = game:GetService("ServerStorage");

local IItem = require(ServerStorage.Item.types);

export type Status = "Raw" | "Cooked" | "Burnt";

export type SandwichBaseProperties = {
  name: string;
  description: string;
  status: Status;
}

export type SandwichConstructorProperties = SandwichBaseProperties & {
  items: {IItem.IItem}?;
}

export type SandwichProperties = SandwichBaseProperties & {
  items: {IItem.IItem};
  type: "Sandwich";
};

export type SandwichMethods = {
  createModel: (item: ISandwich) -> Model;
  setStatus: (item: ISandwich, newStatus: Status) -> ();
  drop: (item: ISandwich, origin: Vector3, direction: Vector3) -> Model;
};

export type SandwichEvents = {
  StatusChanged: RBXScriptSignal;
}

export type ISandwich = SandwichProperties & SandwichMethods & SandwichEvents;

return {};