--!strict

game.Players.PlayerAdded:Connect(function(player)
	
	workspace.CousinRicky.PrimaryPart:SetNetworkOwner(player);
	
end)