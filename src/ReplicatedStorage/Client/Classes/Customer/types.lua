--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage");

local IOrder = require(ReplicatedStorage.Client.Classes.Order.types);

export type CustomerBaseProperties = {
  id: string;
  order: IOrder.IOrder;
  image: string;
  model: Model;
  headshotImage: string;
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