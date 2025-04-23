--!strict
local camera = workspace.CurrentCamera;

camera.CameraSubject = workspace.CousinRicky.PlayerCharacter;
camera.CameraType = Enum.CameraType.Scriptable;

while task.wait() do

	camera.CFrame = workspace.CousinRicky.CameraPart.CFrame;

end