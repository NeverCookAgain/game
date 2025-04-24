--!strict

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");

local function updatePrompts()

  local round = ReplicatedStorage.Shared.Functions.GetRound:InvokeServer();
  local contestant;
  for _, possibleContestant in round.contestants do

    if possibleContestant.player == Players.LocalPlayer then

      contestant = possibleContestant;
      break;

    end;

  end;

  for _, stationModel in workspace.SandwichStations:GetChildren() do

    if stationModel:IsA("Model") then
        
      local proximityPromptsPart = stationModel:FindFirstChild("ProximityPrompts");
      if not proximityPromptsPart then

        error("ProximityPrompts part missing.");

      end;

      for _, proximityPrompt in proximityPromptsPart:GetChildren() do

        proximityPrompt:Destroy();

      end;

      local activateSandwichStationBindableFunction = ReplicatedStorage.Shared.Functions.DynamicFunctions:FindFirstChild(`ActivateSandwichStation_{stationModel.Name}`);

      if contestant.inventory[1] then

        local proximityPrompt = script.ProximityPrompt:Clone();
        proximityPrompt.Name = "AddItemProximityPrompt";
        proximityPrompt.ActionText = `Add {contestant.inventory[1].name}`;
        proximityPrompt.KeyboardKeyCode = Enum.KeyCode.E;
        proximityPrompt.Parent = proximityPromptsPart;
        proximityPrompt.UIOffset = Vector2.new(0, 100);
        proximityPrompt.Triggered:Connect(function()
        
          proximityPrompt.Enabled = false;
          activateSandwichStationBindableFunction:InvokeServer("Add");
          proximityPrompt.Enabled = true;

        end);

      end;

      if #stationModel:GetChildren() > 2 then

        local proximityPrompt = script.ProximityPrompt:Clone();
        proximityPrompt.Name = "RemoveItemProximityPrompt";
        proximityPrompt.Parent = proximityPromptsPart;
        proximityPrompt.KeyboardKeyCode = Enum.KeyCode.C;
        proximityPrompt.ActionText = `Complete sandwich`;
        proximityPrompt.UIOffset = Vector2.new(if stationModel.Name:find("Left") then -100 else 100, 0);
        proximityPrompt.Triggered:Connect(function()
          
          proximityPrompt.Enabled = false;
          activateSandwichStationBindableFunction:InvokeServer("Complete");
          proximityPrompt.Enabled = true;

        end);

      end;

    end;
  
  end;

end;

ReplicatedStorage.Shared.Events.SandwichStationChanged.OnClientEvent:Connect(updatePrompts);
ReplicatedStorage.Shared.Events.ContestantInventoryChanged.OnClientEvent:Connect(updatePrompts);
updatePrompts();