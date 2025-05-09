--!strict

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");

local camera = workspace.CurrentCamera;

camera.CameraType = Enum.CameraType.Scriptable;

local followPlayerThread: thread? = nil;

local function stopFollowingPlayer()

	if followPlayerThread then

		task.cancel(followPlayerThread);
		followPlayerThread = nil;

	end;

end;

local function updateCamera()

	if not Players.LocalPlayer.Character then return end
	
	camera.CameraSubject = Players.LocalPlayer.Character.PrimaryPart;

	stopFollowingPlayer();

	followPlayerThread = task.spawn(function()

		while task.wait() do

			camera.CFrame = Players.LocalPlayer.Character.CameraPart.CFrame;
		
		end

	end);

end;

Players.LocalPlayer.CharacterAdded:Connect(updateCamera);
updateCamera();

ReplicatedStorage.Shared.Events.RoundChanged.OnClientEvent:Connect(function(round)
	
	if round.status == "Ended" then

		stopFollowingPlayer();
		while task.wait() do

			camera.CFrame = workspace:FindFirstChild("JudgingCameraPart").CFrame;

		end;

	end;

end);
