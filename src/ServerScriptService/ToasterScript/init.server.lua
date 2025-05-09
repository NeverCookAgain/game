--!strict

local ServerStorage = game:GetService("ServerStorage");

local Round = require(ServerStorage.Classes.Round);
local Toaster = require(ServerStorage.Classes.Toaster);

local round = Round.getFromSharedRound()

while not round and task.wait() do

  round = Round.getFromSharedRound();

end;

if round then

  Toaster.new({
    model = workspace:FindFirstChild("Toaster");
  }, round);

  round.RoundChanged:Connect(function()
    
    if round.status == "Ended" then

    end;

  end)

end;