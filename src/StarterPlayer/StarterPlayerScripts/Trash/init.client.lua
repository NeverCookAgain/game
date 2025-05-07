--!strict

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");

local Round = require(ReplicatedStorage.Client.Classes.Round);

local round = Round.getFromServerRound();
assert(round, "Round not found.");

local player = Players.LocalPlayer;

local contestant = round:findContestantFromPlayer(player);
assert(contestant, "Contestant not found.");

local proximityPrompt = script.ProximityPrompt:Clone();
proximityPrompt.Parent = workspace.TrashTrigger;

local triggerConnection: RBXScriptConnection? = nil;

local function updateProximityPrompt()

  if triggerConnection then

    triggerConnection:Disconnect();
    triggerConnection = nil;

  end;

  local selectedItem = ReplicatedStorage.Client.Functions.GetSelectedItem:Invoke();
  if selectedItem then

    proximityPrompt.ActionText = `Discard {selectedItem.name}`;
    proximityPrompt.Enabled = true;
    triggerConnection = proximityPrompt.Triggered:Once(function()
    
      proximityPrompt.Enabled = false;
      ReplicatedStorage.Shared.Functions.DiscardItem:InvokeServer();

    end);
  
  else

    proximityPrompt.Enabled = false;
  
  end;

end;

ReplicatedStorage.Client.Events.SelectedItemChanged.Event:Connect(updateProximityPrompt);
updateProximityPrompt();