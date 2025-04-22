--!strict

game.Players.PlayerAdded:Connect(function(player)
	
	workspace.CousinRicky.PlayerCharacter:SetNetworkOwner(player);
	
end)