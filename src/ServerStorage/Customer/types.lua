--!strict

local ServerStorage = game:GetService("ServerStorage");

local IOrder = require(ServerStorage.Order.types);

export type CustomerBaseProperties = {
  order: IOrder.IOrder?;
  image: string;
  model: Model;
  status: "Thinking" | "Waiting" | "Assigned" | "Served";
}

export type CustomerConstructorProperties = CustomerBaseProperties & {
  id: string?;
}

export type CustomerProperties = CustomerBaseProperties & {
  id: string;
  type: "Customer";
};

export type CustomerMethods = {
  setOrder: (self: ICustomer, order: IOrder.IOrder) -> ();
  updateStatus: (self: ICustomer) -> ();
};

export type CustomerEvents = {
  
}

export type ICustomer = CustomerProperties & CustomerMethods & CustomerEvents;

return {};