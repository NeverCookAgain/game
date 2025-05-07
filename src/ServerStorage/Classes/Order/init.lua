--!strict

local ServerStorage = game:GetService("ServerStorage");

local Item = require(ServerStorage.Classes.Item);
local IOrder = require(script.types);
local IRound = require(ServerStorage.Classes.Round.types);
local ISandwich = require(ServerStorage.Classes.Sandwich.types);
local Sandwich = require(ServerStorage.Classes.Sandwich);

local Order = {};

function Order.new(properties: IOrder.OrderConstructorProperties, round: IRound.IRound): IOrder.IOrder

  local customer = round:findCustomerFromID(properties.customerID);
  assert(customer, "Customer not found.");

  local function setActualSandwich(self: IOrder.IOrder, sandwich: ISandwich.ISandwich): ()

    self.actualSandwich = sandwich;
    self.deliveredTimeMilliseconds = DateTime.now().UnixTimestampMillis;

    

    customer:updateStatus();


  end;

  local function setAssignedChefID(self: IOrder.IOrder, assignedChefID: string?): ()

    self.assignedChefID = assignedChefID;
    self.assignedTimeMilliseconds = DateTime.now().UnixTimestampMillis;

    customer:updateStatus();

  end;

  local order: IOrder.IOrder = {
    type = "Order" :: "Order";
    assignedChefID = properties.assignedChefID;
    customerID = properties.customerID;
    difficulty = properties.difficulty;
    requestedSandwich = properties.requestedSandwich;
    actualSandwich = properties.actualSandwich;
    setActualSandwich = setActualSandwich;
    setAssignedChefID = setAssignedChefID;
  };

  return order;

end;

function Order.generate(difficulty: IOrder.Difficulty, customerID: string, round: IRound.IRound): IOrder.IOrder

  local sandwich = Sandwich.new({
    name = `{difficulty} Sandwich`;
    description = (
      if difficulty == "Easy" then "..." -- TODO: Replace with lore.
      elseif difficulty == "Medium" then "..."
      elseif difficulty == "Hard" then "..."
      else "Unknown." 
    )
  }, round);

  local function addBread()

    local bread = Item.get("WhiteBread", round);
    bread:setStatus("Cooked");
    table.insert(sandwich.items, bread);

  end;

  addBread();

  repeat

    local item = Item.random(round);
    item:setStatus("Cooked");
    table.insert(sandwich.items, item);

  until (difficulty == "Easy" and #sandwich.items == 3) or (difficulty == "Medium" and #sandwich.items == 4) or (difficulty == "Hard" and #sandwich.items == 5)

  addBread();

  return Order.new({
    requestedSandwich = sandwich;
    difficulty = difficulty;
    customerID = customerID;
  }, round);

end;

return Order;