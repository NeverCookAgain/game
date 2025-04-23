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
        sandwich = {};
      }, round);

      sandwichStation.SandwichChanged:Connect(function()
      
        ReplicatedStorage.Shared.Events.SandwichStationChanged:FireAllClients(sandwichStation);

      end);

      local activateSandwichStationRemoteFunction = Instance.new("RemoteFunction");
      activateSandwichStationRemoteFunction.Name = `ActivateSandwichStation_{instance.Name}`;
      activateSandwichStationRemoteFunction.OnServerInvoke = function(player: Player, action: unknown)

        if typeof(action) ~= "string" or (action ~= "PushLeft" and action ~= "PushRight" and action ~= "Pop" and action ~= "Complete") then

          error(`Action name must be a "PushLeft", "PushRight", "Pop", or "Complete".`);

        end;

        local contestant = round:findContestantFromPlayer(player);
        if contestant then

          if action:find("Push") then

            local item = (
              if action == "PushLeft" then contestant.inventory[1] 
              elseif action == "PushRight" then contestant.inventory[2]
              else nil
            );

            if item then

              contestant:removeItemFromInventory(item);
              sandwichStation:pushItem(item);

            end;

          elseif action == "Pop" then

            -- Remove the top-most ingredient from the sandwich.
            local item = sandwichStation.sandwich[#sandwichStation.sandwich];
            if item then

              sandwichStation:popItem();

            end;
          
          elseif action == "Complete" then

            -- TODO: Get the sandwich and add it to the player's inventory.

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

  while task.wait(1) do

    print(round.contestants);

  end;

end;