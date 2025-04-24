--!strict

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerScriptService = game:GetService("ServerScriptService");
local ServerStorage = game:GetService("ServerStorage");

local Contestant = require(ServerStorage.Contestant);
local Customer = require(ServerStorage.Customer);
local Avocado = require(ServerStorage.Items.Avocado);
local Round = require(ServerStorage.Round);
local Order = require(ServerStorage.Order);

local round = Round.new({
  status = "Preparing";
  contestants = {};
});

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

local function addPlayerAsContestant(player: Player)

  player.Character = workspace.CousinRicky;

  local contestant = Contestant.new({
    player = player;
    inventory = {};
    inventorySlots = 5;
    model = player.Character;
  }, round);

  contestant.CustomerAssignmentChanged:Connect(function()
  
    

  end);

  contestant.InventoryChanged:Connect(function()
  
    ReplicatedStorage.Shared.Events.ContestantInventoryChanged:FireClient(player);

  end);

  round:addContestant(contestant);

  if #contestant.inventory < 2 then

    contestant:addToInventory(Avocado.new(round));
    contestant:addToInventory(Avocado.new(round));

  end;
  

end;

Players.PlayerAdded:Connect(function(player: Player)
  
  addPlayerAsContestant(player)

end);

for _, player in Players:GetPlayers() do

  coroutine.wrap(addPlayerAsContestant)(player);

end;

local customers = {};
local customerModels = {workspace.CustomerA, workspace.CustomerB, workspace.CustomerC, workspace.CustomerD};
for _, customerModel in customerModels do

  local customer = Customer.new({
    model = customerModel;
  }, round);

  local order = Order.generate("Easy", round);
  customer:setOrder(order);

  table.insert(customers, customer);

end;

ReplicatedStorage.Shared.Functions.GetCustomer.OnServerInvoke = function(player, customerName: unknown)

  assert(typeof(customerName) == "string", "Customer name must be a string.");

  for _, customer in customers do

    if customer.model.Name == customerName then

      return customer;

    end;

  end;

  error("Customer not found.");

end;

ReplicatedStorage.Shared.Functions.ActivateItem.OnServerInvoke = function(player, slot)

  local contestant = round:findContestantFromPlayer(player);
  if contestant then

    local item = contestant.inventory[slot];
    if item then

      contestant:removeFromInventory(item);
      
      if contestant.model and contestant.model.PrimaryPart then
        
        if item.type == "Item" then

          item:drop(contestant.model.PrimaryPart.CFrame, -contestant.model.PrimaryPart.CFrame.LookVector * 5);

        elseif item.type == "Sandwich" then

          item:drop(contestant.model.PrimaryPart.CFrame, -contestant.model.PrimaryPart.CFrame.LookVector * 5);

        end;

      end;

    end;

  end;

end;

local startTimeMilliseconds = DateTime.now().UnixTimestampMillis;
local completionTimeMilliseconds = startTimeMilliseconds + (90 * 1000);
round.startTimeMilliseconds = startTimeMilliseconds;
round.completionTimeMilliseconds = completionTimeMilliseconds;
round:setStatus("Ongoing");

task.delay((completionTimeMilliseconds - startTimeMilliseconds) / 1000, function()

  round:setStatus("Ended");

end);