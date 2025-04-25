--!strict

local Players = game:GetService("Players");
local UserInputService = game:GetService("UserInputService");
local ContextActionService = game:GetService("ContextActionService");
local TweenService = game:GetService("TweenService");

local animationTask: thread?;

local shouldMoveLeft = false;
local shouldMoveRight = false;
local shouldMoveForward = false;
local shouldMoveBackward = false;

local player = Players.LocalPlayer;

local function moveCharacter(actionName, inputState)

	local force = 30;

	shouldMoveLeft = UserInputService:IsKeyDown(Enum.KeyCode.Left) or UserInputService:IsKeyDown(Enum.KeyCode.A);
	shouldMoveRight = UserInputService:IsKeyDown(Enum.KeyCode.Right) or UserInputService:IsKeyDown(Enum.KeyCode.D);
	shouldMoveForward = UserInputService:IsKeyDown(Enum.KeyCode.Up) or UserInputService:IsKeyDown(Enum.KeyCode.W);
	shouldMoveBackward = UserInputService:IsKeyDown(Enum.KeyCode.Down) or UserInputService:IsKeyDown(Enum.KeyCode.S);

	local linearVelocity: LinearVelocity = player.Character.PrimaryPart.LinearVelocity;
	linearVelocity.VectorVelocity = Vector3.new(
		if shouldMoveForward and shouldMoveBackward then 0 elseif shouldMoveBackward then force elseif shouldMoveForward then -force else 0, 
		0, 
		if shouldMoveLeft and shouldMoveRight then 0 elseif shouldMoveLeft then force elseif shouldMoveRight then -force else 0
	);

	local walkCycleLeftIDs = {138071730441626, 127157712731282, 90099424286222, 88329203120597, 110743064881685, 138805926032055, 137674659781586, 80218653204415, 72783473022560};
	local function setAnimationFrame(frameNumber: number)

		local spriteSides = {player.Character.SpritePart.BackGUI.ImageLabel, player.Character.SpritePart.FrontGUI.ImageLabel};

		for _, sprite in spriteSides do

			sprite.Image = `rbxassetid://{walkCycleLeftIDs[frameNumber]}`;

			if shouldMoveLeft or shouldMoveRight then

				TweenService:Create(player.Character.SpritePart.Attachment, TweenInfo.new(0.1), {
					CFrame = CFrame.new(player.Character.SpritePart.Attachment.CFrame.Position) * CFrame.Angles(0, if shouldMoveLeft then 0 else math.rad(180), 0);
				}):Play()

			end;

		end;
	
	end;

	if not animationTask and linearVelocity.VectorVelocity ~= Vector3.zero then

		animationTask = task.spawn(function()
		
			local frameNumber = 1;

			while task.wait(0.05) do

				setAnimationFrame(frameNumber);
				frameNumber = if frameNumber + 1 <= #walkCycleLeftIDs then frameNumber + 1 else 1;
		
			end;

		end);

	elseif linearVelocity.VectorVelocity == Vector3.zero and animationTask then

		task.cancel(animationTask);
		animationTask = nil;

		setAnimationFrame(1);

	end;

end

ContextActionService:BindAction("MoveLeft", moveCharacter, false, Enum.KeyCode.A, Enum.KeyCode.Left);
ContextActionService:BindAction("MoveRight", moveCharacter, false, Enum.KeyCode.D, Enum.KeyCode.Right);
ContextActionService:BindAction("MoveBackward", moveCharacter, false, Enum.KeyCode.W, Enum.KeyCode.Up);
ContextActionService:BindAction("MoveForward", moveCharacter, false, Enum.KeyCode.S, Enum.KeyCode.Down);
