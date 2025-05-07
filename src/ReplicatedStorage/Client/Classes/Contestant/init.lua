--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage");

local IRound = require(ReplicatedStorage.Client.Classes.Round.types);
local IContestant = require(script.types);

local Contestant = {};

function Contestant.new(properties: IContestant.ContestantProperties, round: IRound.IRound): IContestant.IContestant

  local inventoryChangedEvent = Instance.new("BindableEvent");

  local function getOrderAccuracy(self: IContestant.IContestant): (number, number)

    local totalSandwichIngredientCount = 0;
    local correctSandwichIngredientCount = 0;

    for _, customer in round.customers do

      if customer.order.assignedChefID == self.id then

        if customer.order.actualSandwich then

          local actualSandwichItems = table.clone(customer.order.actualSandwich.items);

          for _, item in customer.order.requestedSandwich.items do

            local itemAccuracy = 0;
            for possibleItemIndex, possibleItem in actualSandwichItems do

              if possibleItem.name == item.name then
                
                itemAccuracy = if possibleItem.status == item.status then 1 else 0.5;
                table.remove(actualSandwichItems, possibleItemIndex);
                break;

              end;

            end;
            correctSandwichIngredientCount += itemAccuracy;

          end;

        end;

        totalSandwichIngredientCount += #customer.order.requestedSandwich.items;

      end;

    end;

    return correctSandwichIngredientCount, totalSandwichIngredientCount;

  end;

  local contestant: IContestant.IContestant = {
    type = "Contestant" :: "Contestant";
    assignedCustomerID = properties.assignedCustomerID;
    actionItem = properties.actionItem;
    id = properties.id;
    headshotImages = properties.headshotImages;
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