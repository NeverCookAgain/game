--!strict

local Players = game:GetService("Players");

local camera = workspace.CurrentCamera;

camera.CameraType = Enum.CameraType.Scriptable;

local cameraThread: thread? = nil;

Players.LocalPlayer.CharacterAdded:Connect(function()

	camera.CameraSubject = Players.LocalPlayer.Character.PrimaryPart;

	if cameraThread then

		task.cancel(cameraThread);
		cameraThread = nil;

	end;

	cameraThread = task.spawn(function()

		while task.wait() do

			camera.CFrame = Players.LocalPlayer.Character.CameraPart.CFrame;
		
		end

	end);

end);

