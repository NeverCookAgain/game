--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage");

local IItem = require(ReplicatedStorage.Client.Classes.Item.types);

export type SandwichBaseProperties = {
  name: string;
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
  drop: (item: ISandwich, origin: CFrame, direction: Vector3) -> Model;
};

export type SandwichEvents = {
  StatusChanged: RBXScriptSignal;
}

export type ISandwich = SandwichProperties & SandwichMethods & SandwichEvents;

return {};