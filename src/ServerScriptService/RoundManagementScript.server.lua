--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerStorage = game:GetService("ServerStorage");

local Round = require(ServerStorage.Round);

local round = Round.new({
  status = "Preparing";
  durationSeconds = 2;
});

ReplicatedStorage.Shared.Functions.GetRound.OnServerInvoke = function()

  return round;

end;

round.RoundChanged:Connect(function()

  if (round.status == "Ended") then
    
    local roundEndSound = Instance.new("Sound");
    roundEndSound.Name = "RoundEndSound";
    roundEndSound.SoundId = "rbxassetid://9113087676";
    roundEndSound.Parent = workspace;
    roundEndSound.Ended:Once(function()
    
      roundEndSound:Destroy();

    end);
    roundEndSound:Play();

  end;

end);

task.delay(round.durationSeconds, function()

  round:setStatus("Ended");

end);

round:setStatus("Ongoing");