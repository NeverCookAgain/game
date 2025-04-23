--!strict

for _, instance in workspace.SandwichStations:GetChildren() do

  if instance:IsA("Model") then

    for _, child in instance:FindFirstChild("ProximityPrompts"):GetChildren() do

      if child:IsA("ProximityPrompt") then

        child.Triggered:Connect(function(activatingPlayer: Player)
        
          print(activatingPlayer);

        end);

      end;

    end;

  end;

end;