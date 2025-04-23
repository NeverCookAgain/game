--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage");

local proximityPrompt = workspace:FindFirstChild("Toaster"):WaitForChild("ProximityPrompt");
if not proximityPrompt:IsA("ProximityPrompt") then

  error("Not a proximity prompt.");

end;

proximityPrompt.Triggered:Connect(function()

  ReplicatedStorage.Shared.Functions.ActivateToaster:InvokeServer();

end);