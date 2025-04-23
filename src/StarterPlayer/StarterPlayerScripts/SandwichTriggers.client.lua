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

  for _, instance in workspace.SandwichStations:GetChildren() do

    if instance:IsA("Model") then
  
      for _, child in instance:FindFirstChild("ProximityPrompts"):GetChildren() do
  
        if child:IsA("ProximityPrompt") then

          child.Enabled = (
            (child.Name:find("LeftHand") and contestant.inventory[1]) or 
            (child.Name:find("RightHand") and contestant.inventory[2]) or
            (child.Name:find("Top") and #instance:GetChildren() > 2)
          );
  
          if child.Enabled and child.Name:find("Hand") then

            child.ActionText = `Add the {if child.Name:find("LeftHand") then contestant.inventory[1].name else contestant.inventory[2].name}`;

          end;

        end;
  
      end;
  
    end;
  
  end;

end;

ReplicatedStorage.Shared.Events.ContestantInventoryChanged.OnClientEvent:Connect(updatePrompts);

updatePrompts();