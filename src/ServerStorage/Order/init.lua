--!strict

local ServerStorage = game:GetService("ServerStorage");

local Item = require(ServerStorage.Item);
local IOrder = require(script.types);
local IRound = require(ServerStorage.Round.types);
local Sandwich = require(ServerStorage.Sandwich);

local Order = {};

function Order.new(properties: IOrder.OrderConstructorProperties): IOrder.IOrder

  local order: IOrder.IOrder = {
    type = "Order" :: "Order";
    sandwich = properties.sandwich;
  };

  return order;

end;

function Order.generate(type: "Easy" | "Medium" | "Difficult", round: IRound.IRound): IOrder.IOrder

  local sandwich = Sandwich.new({
    name = `{type} Sandwich`;
    description = (
      if type == "Easy" then "..." -- TODO: Replace with lore.
      elseif type == "Medium" then "..."
      elseif type == "Difficult" then "..."
      else "Unknown." 
    )
  }, round);

  repeat

    local item = Item.random(round);
    item.status = "Cooked";
    table.insert(sandwich.items, item);

  until (type == "Easy" and #sandwich.items == 5) or (type == "Medium" and #sandwich.items == 10) or (type == "Difficult" and #sandwich.items == 15)

  return Order.new({
    sandwich = sandwich;
  });

end;

return Order;