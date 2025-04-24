--!strict

local ServerStorage = game:GetService("ServerStorage");

local IOrder = require(ServerStorage.Order.types);

export type CustomerBaseProperties = {
  order: IOrder.IOrder?;
  image: string;
  model: Model;
}

export type CustomerConstructorProperties = CustomerBaseProperties & {
  
}

export type CustomerProperties = CustomerBaseProperties & {
  type: "Customer";
};

export type CustomerMethods = {
  setOrder: (self: ICustomer, order: IOrder.IOrder) -> ();
};

export type CustomerEvents = {
  
}

export type ICustomer = CustomerProperties & CustomerMethods & CustomerEvents;

return {};