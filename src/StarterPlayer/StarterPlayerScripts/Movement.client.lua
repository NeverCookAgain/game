--!strict
local ContextActionService = game:GetService("ContextActionService");

local vector = Vector3.zero;
local function moveCharacter(actionName, inputState)

	local force = 30;

	if actionName == "MoveLeft" then

		vector = Vector3.new(vector.X, vector.Y, if inputState == Enum.UserInputState.Begin then force else 0);

	elseif actionName == "MoveRight" then

		vector = Vector3.new(vector.X, vector.Y, if inputState == Enum.UserInputState.Begin then -force else 0);

	elseif actionName == "MoveForward" then

		vector = Vector3.new(if inputState == Enum.UserInputState.Begin then force else 0, vector.Y, vector.Z);

	elseif actionName == "MoveBackward" then

		vector = Vector3.new(if inputState == Enum.UserInputState.Begin then -force else 0, vector.Y, vector.Z);

	end

	workspace.CousinRicky.PlayerCharacter.LinearVelocity.VectorVelocity = vector;

end

ContextActionService:BindAction("MoveLeft", moveCharacter, false, Enum.KeyCode.A, Enum.KeyCode.Left);
ContextActionService:BindAction("MoveRight", moveCharacter, false, Enum.KeyCode.D, Enum.KeyCode.Right);
ContextActionService:BindAction("MoveBackward", moveCharacter, false, Enum.KeyCode.W, Enum.KeyCode.Up);
ContextActionService:BindAction("MoveForward", moveCharacter, false, Enum.KeyCode.S, Enum.KeyCode.Down);
