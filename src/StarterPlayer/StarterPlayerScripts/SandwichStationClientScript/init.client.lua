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

      if contestant.inventory[1] then

        local proximityPrompt = script.ProximityPrompt:Clone();
        proximityPrompt.Name = "LeftHandProximityPrompt";
        proximityPrompt.ActionText = "Add left hand item";
        proximityPrompt.KeyboardKeyCode = Enum.KeyCode.E;
        proximityPrompt.Parent = proximityPromptsPart;
        proximityPrompt.Triggered:Connect(function()
        
        end);

      end;

      if contestant.inventory[2] then

        local proximityPrompt = script.ProximityPrompt:Clone();
        proximityPrompt.Name = "RightHandProximityPrompt";
        proximityPrompt.ActionText = "Add right hand item";
        proximityPrompt.KeyboardKeyCode = Enum.KeyCode.Q;
        proximityPrompt.Parent = proximityPromptsPart;
        proximityPrompt.Triggered:Connect(function()
        
        end);

      end;

      if #stationModel:FindFirstChild("Sandwich"):GetChildren() > 1 then

        local proximityPrompt = script.ProximityPrompt:Clone();
        proximityPrompt.Name = "RemoveTopItemProximityPrompt";
        proximityPrompt.Parent = proximityPromptsPart;
        proximityPrompt.KeyboardKeyCode = Enum.KeyCode.C;
        proximityPrompt.ActionText = "Remove top item";
        proximityPrompt.UIOffset = Vector2.new(if stationModel.Name:find("Left") then -100 else 100, 0);
        proximityPrompt.Triggered:Connect(function()
        
        end);

      end;

    end;

    local sandwichModel = stationModel:FindFirstChild("Sandwich");
    if #sandwichModel:GetChildren() > 1 then

      

    end;
  
  end;

end;

ReplicatedStorage.Shared.Events.ContestantInventoryChanged.OnClientEvent:Connect(updatePrompts);

updatePrompts();