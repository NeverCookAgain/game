--!strict
local camera = workspace.CurrentCamera;

camera.CameraSubject = workspace.CousinRicky.PrimaryPart;
camera.CameraType = Enum.CameraType.Scriptable;

while task.wait() do

	camera.CFrame = workspace.CousinRicky.CameraPart.CFrame;

end