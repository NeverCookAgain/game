--!strict

local Players = game:GetService("Players");
local UserInputService = game:GetService("UserInputService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ContextActionService = game:GetService("ContextActionService");
local TweenService = game:GetService("TweenService");

local Round = require(ReplicatedStorage.Client.Classes.Round);
local IRound = require(ReplicatedStorage.Client.Classes.Round.types);
local round: IRound.IRound? = nil;
repeat

	round = Round.getFromServerRound();

until round;
assert(round, "Round not found!");

local player = Players.LocalPlayer;
local contestant = round:findContestantFromPlayer(player);
assert(contestant, "Contestant not found!");

local animationTask: thread?;

local shouldMoveLeft = false;
local shouldMoveRight = false;
local shouldMoveForward = false;
local shouldMoveBackward = false;


if not player.Character then

	player.CharacterAdded:Wait();

end;

local function setAnimationFrame(frameNumber: number)

	ReplicatedStorage.Shared.Functions.SetContestantAnimationFrame:InvokeServer(frameNumber, if shouldMoveLeft then "Left" elseif shouldMoveRight then "Right" else nil);

end;

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

	if not animationTask and linearVelocity.VectorVelocity ~= Vector3.zero then

		animationTask = task.spawn(function()
		
			local frameNumber = 1;

			while task.wait(0.05) do

				setAnimationFrame(frameNumber);
				frameNumber = if frameNumber + 1 <= #contestant.headshotImages.walkCycle then frameNumber + 1 else 1;
		
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

setAnimationFrame(1)