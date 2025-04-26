--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage");

local ISandwich = require(ReplicatedStorage.Client.Sandwich.types);

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

};

export type OrderEvents = {
  
}

export type IOrder = OrderProperties & OrderMethods & OrderEvents;

return {};