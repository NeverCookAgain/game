--!strict

local ServerStorage = game:GetService("ServerStorage");

local Item = require(ServerStorage.Item);
local IItem = require(ServerStorage.Item.types);
local IRound = require(ServerStorage.Round.types);
local IContestant = require(ServerStorage.Contestant.types);

local Spactula = {
  name = "Avocado";
  description = "TBD";
  image = "rbxassetid://72701864119182";
};

function Spactula.new(round: IRound.IRound): IItem.IItem

  local function activate(self: IActionItem.IActionItem)

    -- Create a giant spatula part above the user's head.
    local user = round:findChefFromID(self.chefID);
    assert(user and user.player, "User not found.");

    local character = user.player.Character;
    assert(character, "Character not found.");

    local model: Model = self.model:Clone();
    assert(model:IsA("Model") and model.PrimaryPart, "Model has no PrimaryPart.");
    model:PivotTo(character:GetPivot() * CFrame.new(0, 5, 0));
    model.Parent = workspace;

    -- Stun any player who touches it.
    local immuneContestants = {};
    model.PrimaryPart.Touched:Connect(function(hit: Instance)
      
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

    task.delay(5, function()
    
      model:Destroy();

    end);

  end;

end;

return Spactula;