--!strict

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerScriptService = game:GetService("ServerScriptService");
local ServerStorage = game:GetService("ServerStorage");

local Contestant = require(ServerStorage.Contestant);
local Customer = require(ServerStorage.Customer);
local Avocado = require(ServerStorage.Items.Avocado);
local Item = require(ServerStorage.Item);
local Round = require(ServerStorage.Round);
local Order = require(ServerStorage.Order);
local Sandwich = require(ServerStorage.Sandwich);

local round = Round.new({});

Round.setSharedRound(round);

ReplicatedStorage.Shared.Functions.GetRound.OnServerInvoke = function()

  return round;

end;

ReplicatedStorage.Shared.Functions.GetContestant.OnServerInvoke = function(player)

  local contestant = round:findContestantFromPlayer(player);
  return contestant;

end;

round.RoundChanged:Connect(function()

  if round.status == "Ongoing" then

    ServerScriptService.ToasterScript.Enabled = true;
    ServerScriptService.SandwichStationScript.Enabled = true;
  
  elseif round.status == "Ended" then
    
    local roundEndSound = Instance.new("Sound");
    roundEndSound.Name = "RoundEndSound";
    roundEndSound.SoundId = "rbxassetid://9113087676";
    roundEndSound.Parent = workspace;
    roundEndSound.Ended:Once(function()
    
      roundEndSound:Destroy();

    end);
    roundEndSound:Play();

  end;

  ReplicatedStorage.Shared.Events.RoundChanged:FireAllClients(round);

end);

round.EventsChanged:Connect(function()

  ReplicatedStorage.Shared.Events.RoundEventsChanged:FireAllClients(round.events);

end);

local function addPlayerAsContestant(player: Player)

  local spawnLocations: {SpawnLocation} = workspace:FindFirstChild("SpawnLocations"):GetChildren();

  local character = script.Character:Clone();

  character.Name = player.Name;
  player.Character = character;
  character:PivotTo(spawnLocations[Random.new():NextInteger(1, #spawnLocations)].CFrame);
  character.Parent = workspace;

  for _, part in character:GetDescendants() do

    if part:IsA("BasePart") then

      part:SetNetworkOwner(player);

    end;

  end;

  local contestant = Contestant.new({
    player = player;
    model = player.Character;
    headshotImages = {
      default = "rbxassetid://132812371775588";
      happy = "rbxassetid://72985907419460";
      sad = "rbxassetid://112655319908614";
    };
  }, round);

  contestant.CustomerAssignmentChanged:Connect(function()
  
    ReplicatedStorage.Shared.Events.CustomerAssignmentChanged:FireAllClients(contestant);

  end);

  contestant.InventoryChanged:Connect(function()
  
    ReplicatedStorage.Shared.Events.ContestantInventoryChanged:FireAllClients(contestant);

  end);

  round:addContestant(contestant);

end;

Players.PlayerAdded:Connect(function(player: Player)
  
  addPlayerAsContestant(player)

end);

for _, player in Players:GetPlayers() do

  coroutine.wrap(addPlayerAsContestant)(player);

end;

local customerModels = {workspace.CustomerA, workspace.CustomerB, workspace.CustomerC, workspace.CustomerD};
local customerImages = {"rbxassetid://136955129612174", "rbxassetid://121007848481264", "rbxassetid://85190412089778", "rbxassetid://72181972813178"};

for _, customerModel in customerModels do

  local customer = Customer.new({
    model = customerModel;
    image = customerImages[Random.new():NextInteger(1, #customerImages)];
    status = "Thinking" :: "Thinking";
  }, round);

  table.insert(round.customers, customer);

  local order = Order.generate("Easy", customer.id, round);
  customer:setOrder(order);

end;

ReplicatedStorage.Shared.Functions.GetCustomer.OnServerInvoke = function(player, customerID: unknown)

  assert(typeof(customerID) == "string", "Customer ID must be a string.");

  for _, customer in round.customers do

    if customer.id == customerID then

      return customer;

    end;

  end;

  error("Customer not found.");

end;

ReplicatedStorage.Shared.Functions.AcceptCustomer.OnServerInvoke = function(player, customerID: unknown)

  local contestant = round:findContestantFromPlayer(player);
  assert(contestant, "You aren't a contestant of this round.");
  assert(not contestant.assignedCustomerID, "You are already assigned to a customer.");
  assert(typeof(customerID) == "string", "Customer name must be a string.");

  local customer;
  for _, possibleCustomer in round.customers do

    if possibleCustomer.id == customerID then

      customer = possibleCustomer;
      break;

    end;

  end;

  assert(customer, "Customer not found.");
  assert(customer.order, "Customer doesn't have an order.");

  contestant:setAssignedCustomerID(customer.id);
  customer.order:setAssignedChefID(contestant.id);

  if customer.model.PrimaryPart and not customer.model.PrimaryPart:FindFirstChild("ProximityPrompt") then
    
    local proximityPrompt = customer.model.PrimaryPart:FindFirstChild("TakeOrderProximityPrompt");
    if proximityPrompt and proximityPrompt:IsA("ProximityPrompt") then

      proximityPrompt.Enabled = false;

    end;

  end;

end;

ReplicatedStorage.Shared.Functions.DeliverSandwich.OnServerInvoke = function(player)

  local contestant = round:findContestantFromPlayer(player);
  assert(contestant, "You aren't a contestant of this round.");
  assert(contestant.assignedCustomerID, "You don't have a customer assigned.");
  assert(contestant.selectedItem, "You don't have a sandwich selected.");

  -- Set the order.
  local item = contestant.selectedItem;
  contestant:removeFromInventory(item);
  
  local sandwich;
  if item.type == "Sandwich" then

    sandwich = item;
  
  else

    sandwich = Sandwich.new({
      items = {item};
      name = "Easy";
      type = "Sandwich";
    }, round);

  end;

  local customer = round:findCustomerFromID(contestant.assignedCustomerID);
  assert(customer, "Customer not found.");
  assert(customer.order, "Customer doesn't have an order.");
  customer.order:setActualSandwich(sandwich);

  -- Reset the customer so the contestant can take a new order.
  local newCustomer = Customer.new({
    model = customer.model;
    image = customerImages[Random.new():NextInteger(1, #customerImages)];
    status = "Thinking" :: "Thinking";
  }, round);

  table.insert(round.customers, newCustomer);

  local order = Order.generate("Easy", newCustomer.id, round);
  newCustomer:setOrder(order);

  contestant:setAssignedCustomerID();

end;

ReplicatedStorage.Shared.Functions.ActivateItem.OnServerInvoke = function(player, slot)

  local contestant = round:findContestantFromPlayer(player);
  assert(contestant, "You aren't a contestant of this round.");

  local item = contestant.inventory[slot];
  assert(item, "Item not found.");

end;

ReplicatedStorage.Shared.Events.SelectedItemChanged.OnServerEvent:Connect(function(player, slot: unknown)

  local contestant = round:findContestantFromPlayer(player);
  assert(contestant, "You aren't a contestant of this round.");
  assert(slot == nil or typeof(slot) == "number", "Slot must be a number or nil.");

  local item = if slot then contestant.inventory[slot :: number] else nil;
  contestant:setSelectedItem(item);

end);

ReplicatedStorage.Shared.Functions.AddIngredientToInventory.OnServerInvoke = function(player, ingredientName: unknown)

  local contestant = round:findContestantFromPlayer(player);
  assert(contestant, "You aren't a contestant of this round.");
  assert(typeof(ingredientName) == "string", "Ingredient name must be a string.");

  if contestant then

    local item = Item.get(ingredientName, round);
    contestant:addToInventory(item);
    print(`Added item to inventory: {item.name}`);

  end;

end;

ReplicatedStorage.Shared.Functions.GetIngredients.OnServerInvoke = function(player)

  local contestant = round:findContestantFromPlayer(player);
  assert(contestant, "You aren't a contestant of this round.");

  local itemClasses = Item.listClasses();
  local possibleIngredients = {};
  for _, itemClass in itemClasses do

    table.insert(possibleIngredients, itemClass);

  end;

  return possibleIngredients;

end;

local startTimeMilliseconds = DateTime.now().UnixTimestampMillis;
local completionTimeMilliseconds = startTimeMilliseconds + (script:GetAttribute("Debug_CompletionTimeMilliseconds") or (90 * 1000));
round.startTimeMilliseconds = startTimeMilliseconds;
round.completionTimeMilliseconds = completionTimeMilliseconds;
round:setStatus("Ongoing");

task.delay((completionTimeMilliseconds - startTimeMilliseconds) / 1000, function()

  round:setStatus("Ended");

end);