--!strict

local ServerStorage = game:GetService("ServerStorage");

local IRound = require(ServerStorage.Classes.Round.types);
local ActionItem = require(ServerStorage.Classes.ActionItem);

type ActionItem = ActionItem.ActionItem;
type Round = IRound.IRound;

local Spatula = {
  name = "Spatula";
  description = "TBD";
  modelTemplate = script.Spatula;
};

function Spatula.new(properties: ActionItem, round: IRound.IRound): ActionItem

  local function activate(self: ActionItem)

    -- Create a giant spatula part above the user's head.
    assert(self.chefID, "Chef ID is not set.");
    local user = round:findChefFromID(self.chefID :: string);
    assert(user and user.player, "User not found.");

    local character = user.player.Character;
    assert(character, "Character not found.");

    local model: Model = script.GiantSpatula:Clone();
    assert(model:IsA("Model") and model.PrimaryPart, "Model has no PrimaryPart.");
    model:PivotTo(character:GetPivot() * CFrame.new(0, 5, 0) * CFrame.Angles(0, 0, math.rad(90)) + character:GetPivot().LookVector);
    model.Parent = workspace;

    model.PrimaryPart:ApplyImpulse(Vector3.new(1, 0, 0) * -200);

    user:setActionItem();

    -- Stun any player who touches it.
    local immuneContestants = {};
    local touchedEvent = model.PrimaryPart.Touched:Connect(function(hit: Instance)
      
      local player = game.Players:GetPlayerFromCharacter(hit:FindFirstAncestorOfClass("Model"));
      if player and player ~= user.player then
        
        local contestant = round:findContestantFromPlayer(player);
        if contestant and contestant.player and not table.find(immuneContestants, contestant) then

          table.insert(immuneContestants, contestant);

          local character = contestant.player.Character;
          if not character then return; end;

          local rootPart = character.PrimaryPart;
          if not rootPart then return; end;

          local alignOrientation = rootPart:FindFirstChild("AlignOrientation");
          if not alignOrientation or not alignOrientation:IsA("AlignOrientation") then return; end;

          local linearVelocity = rootPart:FindFirstChild("LinearVelocity");
          if not linearVelocity or not linearVelocity:IsA("LinearVelocity") then return; end;

          alignOrientation.CFrame = CFrame.new() * CFrame.Angles(0, 0, math.rad(90));
          linearVelocity.Enabled = false;

          task.delay(1.5, function()
          
            alignOrientation.CFrame = CFrame.new();
            linearVelocity.Enabled = true;

            local immuneContestantIndex = table.find(immuneContestants, contestant);
            if immuneContestantIndex then
              
              table.remove(immuneContestants, immuneContestantIndex);
            
            end;

          end);

        end;

      end;
    
    end);

    task.delay(3, function()
    
      touchedEvent:Disconnect();

    end);

    task.delay(5, function()
    
      model:Destroy();

    end);

  end;

  return ActionItem.new({
    name = Spatula.name;
    description = Spatula.description;
    chefID = properties.chefID;
    modelTemplate = Spatula.modelTemplate:Clone();
    activate = activate;
  }, round);

end;

return Spatula;