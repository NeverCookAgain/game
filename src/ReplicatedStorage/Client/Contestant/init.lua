--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage");

local IRound = require(ReplicatedStorage.Client.Round.types);
local IItem = require(ReplicatedStorage.Client.Item.types);
local IContestant = require(script.types);

local Contestant = {};

function Contestant.new(properties: IContestant.ContestantProperties, round: IRound.IRound): IContestant.IContestant

  local inventoryChangedEvent = Instance.new("BindableEvent");

  local function getOrderAccuracy(self: IContestant.IContestant): (number, number)

    local totalSandwichIngredientCount = 0;
    local correctSandwichIngredientCount = 0;

    for _, customer in self.servedCustomers do

      for _, item in customer.order.requestedSandwich.items do
      
        if customer.order.actualSandwich == nil then

          continue;

        end;

        local itemAccuracy = 0;
        for possibleItemIndex, possibleItem in customer.order.actualSandwich.items do

          if possibleItem.name == item.name then
            
            itemAccuracy = if possibleItem.status == item.status then 1 else 0;
            table.remove(customer.order.actualSandwich.items, possibleItemIndex);
            break;

          end;

        end;
        correctSandwichIngredientCount += itemAccuracy;

      end;

      totalSandwichIngredientCount += #customer.order.requestedSandwich.items;

    end;

    return correctSandwichIngredientCount, totalSandwichIngredientCount;

  end;

  local contestant: IContestant.IContestant = {
    type = "Contestant" :: "Contestant";
    id = properties.id;
    headshotImage = properties.headshotImage;
    player = properties.player;
    model = properties.model;
    inventorySlots = properties.inventorySlots;
    inventory = properties.inventory or {};
    servedCustomers = properties.servedCustomers or {};
    getOrderAccuracy = getOrderAccuracy;
    InventoryChanged = inventoryChangedEvent.Event;
  };

  ReplicatedStorage.Shared.Events.ContestantInventoryChanged.OnClientEvent:Connect(function(newInventory: unknown)

    inventoryChangedEvent:Fire(newInventory);

  end);

  return contestant;

end;

return Contestant;