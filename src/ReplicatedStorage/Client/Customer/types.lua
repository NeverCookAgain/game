--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage");

local IOrder = require(ReplicatedStorage.Client.Order.types);

export type CustomerBaseProperties = {
  order: IOrder.IOrder;
  image: string;
  model: Model;
}

export type CustomerConstructorProperties = CustomerBaseProperties & {
  
}

export type CustomerProperties = CustomerBaseProperties & {
  type: "Customer";
};

export type CustomerMethods = {

};

export type CustomerEvents = {
  
}

export type ICustomer = CustomerProperties & CustomerMethods & CustomerEvents;

return {};