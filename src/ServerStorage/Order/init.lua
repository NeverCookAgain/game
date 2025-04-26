--!strict

local ServerStorage = game:GetService("ServerStorage");

local Item = require(ServerStorage.Item);
local IOrder = require(script.types);
local IRound = require(ServerStorage.Round.types);
local ISandwich = require(ServerStorage.Sandwich.types);
local Sandwich = require(ServerStorage.Sandwich);

local Order = {};

function Order.new(properties: IOrder.OrderConstructorProperties): IOrder.IOrder

  local function setActualSandwich(self: IOrder.IOrder, sandwich: ISandwich.ISandwich): ()

    self.actualSandwich = sandwich;

  end;

  local order: IOrder.IOrder = {
    type = "Order" :: "Order";
    difficulty = properties.difficulty;
    requestedSandwich = properties.requestedSandwich;
    actualSandwich = properties.actualSandwich;
    setActualSandwich = setActualSandwich;
  };

  return order;

end;

function Order.generate(difficulty: IOrder.Difficulty, round: IRound.IRound): IOrder.IOrder

  local sandwich = Sandwich.new({
    name = `{difficulty} Sandwich`;
    description = (
      if difficulty == "Easy" then "..." -- TODO: Replace with lore.
      elseif difficulty == "Medium" then "..."
      elseif difficulty == "Hard" then "..."
      else "Unknown." 
    )
  }, round);

  repeat

    local item = Item.random(round);
    item.status = "Cooked";
    table.insert(sandwich.items, item);

  until (difficulty == "Easy" and #sandwich.items == 3) or (difficulty == "Medium" and #sandwich.items == 4) or (difficulty == "Hard" and #sandwich.items == 5)

  return Order.new({
    requestedSandwich = sandwich;
    difficulty = difficulty
  });

end;

return Order;