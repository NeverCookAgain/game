--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerStorage = game:GetService("ServerStorage");

local SandwichStation = require(ServerStorage.SandwichStation);
local Round = require(ServerStorage.Round);

local sandwichStations = {};

local round = Round.getFromSharedRound() or Round.SharedRoundChanged:Wait();

if round then

  for _, instance in workspace.SandwichStations:GetChildren() do

    if instance:IsA("Model") then

      local sandwichStation = SandwichStation.new({
        model = instance;
      }, round);

      sandwichStation.SandwichChanged:Connect(function()
      
        ReplicatedStorage.Shared.Events.SandwichStationChanged:FireAllClients(sandwichStation);

      end);

      local activateSandwichStationRemoteFunction = Instance.new("RemoteFunction");
      activateSandwichStationRemoteFunction.Name = `ActivateSandwichStation_{instance.Name}`;
      activateSandwichStationRemoteFunction.OnServerInvoke = function(player: Player, action: unknown)

        if typeof(action) ~= "string" or (action ~= "Add" and action ~= "Complete") then

          error(`Action name must be a "PushLeft", "PushRight", "Pop", or "Complete".`);

        end;

        local contestant = round:findContestantFromPlayer(player);
        if contestant then

          if action:find("Add") then

            local item = contestant.inventory[#contestant.inventory];

            if item then

              contestant:removeFromInventory(item);
              sandwichStation:pushItem(item);

            end;

          elseif action == "Complete" then

            -- TODO: Get the sandwich and add it to the player's inventory.
            if not sandwichStation.sandwich then

              error("No sandwich found.");

            end;

            sandwichStation:completeSandwich();

          end;

        end;

      end;

      activateSandwichStationRemoteFunction.Parent = ReplicatedStorage.Shared.Functions.DynamicFunctions;

      table.insert(sandwichStations, sandwichStation);

      local function checkStatus()

        if round.status == "Ended" then

          -- TODO: Break down sandwich station.

        end;

      end;

      round.RoundChanged:Connect(checkStatus);
      checkStatus();

    end;

  end;

  print(`Initialized {#sandwichStations} sandwich stations.`);

end;