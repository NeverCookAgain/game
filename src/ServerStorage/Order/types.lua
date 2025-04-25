--!strict

local ServerStorage = game:GetService("ServerStorage");

local ISandwich = require(ServerStorage.Sandwich.types);

export type Difficulty = "Easy" | "Medium" | "Hard";

export type OrderBaseProperties = {
  difficulty: Difficulty;
  requestedSandwich: ISandwich.ISandwich;
  actualSandwich: ISandwich.ISandwich?;
}

export type OrderConstructorProperties = OrderBaseProperties & {
  
}

export type OrderProperties = OrderBaseProperties & {
  type: "Order";
};

export type OrderMethods = {
  setActualSandwich: (self: IOrder, sandwich: ISandwich.ISandwich) -> ();
};

export type OrderEvents = {
  
}

export type IOrder = OrderProperties & OrderMethods & OrderEvents;

return {};