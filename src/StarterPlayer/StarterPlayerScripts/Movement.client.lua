--!strict
local UserInputService = game:GetService("UserInputService");
local ContextActionService = game:GetService("ContextActionService");

local function moveCharacter(actionName, inputState)

	local force = 30;

	local shouldMoveLeft = UserInputService:IsKeyDown(Enum.KeyCode.Left) or UserInputService:IsKeyDown(Enum.KeyCode.A);
	local shouldMoveRight = UserInputService:IsKeyDown(Enum.KeyCode.Right) or UserInputService:IsKeyDown(Enum.KeyCode.D);
	local shouldMoveForward = UserInputService:IsKeyDown(Enum.KeyCode.Up) or UserInputService:IsKeyDown(Enum.KeyCode.W);
	local shouldMoveBackward = UserInputService:IsKeyDown(Enum.KeyCode.Down) or UserInputService:IsKeyDown(Enum.KeyCode.S);
	workspace.CousinRicky.PlayerCharacter.LinearVelocity.VectorVelocity = Vector3.new(
		if shouldMoveForward and shouldMoveBackward then 0 elseif shouldMoveBackward then force elseif shouldMoveForward then -force else 0, 
		0, 
		if shouldMoveLeft and shouldMoveRight then 0 elseif shouldMoveLeft then force elseif shouldMoveRight then -force else 0
	);

end

ContextActionService:BindAction("MoveLeft", moveCharacter, false, Enum.KeyCode.A, Enum.KeyCode.Left);
ContextActionService:BindAction("MoveRight", moveCharacter, false, Enum.KeyCode.D, Enum.KeyCode.Right);
ContextActionService:BindAction("MoveBackward", moveCharacter, false, Enum.KeyCode.W, Enum.KeyCode.Up);
ContextActionService:BindAction("MoveForward", moveCharacter, false, Enum.KeyCode.S, Enum.KeyCode.Down);
