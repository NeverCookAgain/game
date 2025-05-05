--!strict

local ServerStorage = game:GetService("ServerStorage");

local ISandwich = require(ServerStorage.Sandwich.types);

export type Difficulty = "Easy" | "Medium" | "Hard";

export type OrderBaseProperties = {
  difficulty: Difficulty;
  customerID: string?;
  assignedChefID: string?;
  requestedSandwich: ISandwich.ISandwich;
  actualSandwich: ISandwich.ISandwich?;
  assignedTimeMilliseconds: number?;
  deliveredTimeMilliseconds: number?;
}

export type OrderConstructorProperties = OrderBaseProperties & {
  
}

export type OrderProperties = OrderBaseProperties & {
  type: "Order";
};

export type OrderMethods = {
  setActualSandwich: (self: IOrder, sandwich: ISandwich.ISandwich) -> ();
  setAssignedChefID: (self: IOrder, assignedChefID: string?) -> ();
};

export type OrderEvents = {
  
}

export type IOrder = OrderProperties & OrderMethods & OrderEvents;

return {};