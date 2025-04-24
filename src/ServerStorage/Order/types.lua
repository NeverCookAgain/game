--!strict

local ServerStorage = game:GetService("ServerStorage");

local ISandwich = require(ServerStorage.Sandwich.types);

export type Difficulty = "Easy" | "Medium" | "Hard";

export type OrderBaseProperties = {
  difficulty: Difficulty;
  sandwich: ISandwich.ISandwich;
}

export type OrderConstructorProperties = OrderBaseProperties & {
  
}

export type OrderProperties = OrderBaseProperties & {
  type: "Order";
};

export type OrderMethods = {
  
};

export type OrderEvents = {
  
}

export type IOrder = OrderProperties & OrderMethods & OrderEvents;

return {};