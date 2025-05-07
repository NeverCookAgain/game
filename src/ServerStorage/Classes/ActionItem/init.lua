--!strict

local ServerStorage = game:GetService("ServerStorage");

local IRound = require(ServerStorage.Classes.Round.types);
local IActionItem = require(script.Interface);

type Round = IRound.IRound;
export type ActionItem = IActionItem.ActionItem;

local ActionItem = {};

export type ActionItemClass = {
  name: string;
  description: string;
  new: (round: IRound.IRound) -> ActionItem;
};

function ActionItem.new(properties: IActionItem.ActionItemConstructorProperties, round: Round): ActionItem

  local function drop(self: ActionItem, originalPosition: CFrame): ()

    local model = self.modelTemplate:Clone();
    assert(model.PrimaryPart, "Model has no PrimaryPart.");

    model:PivotTo(originalPosition);
    model.Parent = workspace;

  end;

  local self: ActionItem = {
    type = "ActionItem" :: "ActionItem";
    name = properties.name;
    description = properties.description;
    modelTemplate = properties.modelTemplate;
    chefID = properties.chefID;
    activate = properties.activate;
    drop = drop;
  };

  return self;

end;

function ActionItem.listClasses(): {[string]: ActionItemClass}

  return {
    Spatula = require(ServerStorage.Classes.ActionItems.Spatula) :: ActionItemClass;
  };

end;

function ActionItem.random(round: Round): ActionItem

  local itemNames = {};
  local items = ActionItem.listClasses();

  for itemName in items do

    table.insert(itemNames, itemName);

  end;

  local randomIndex = Random.new():NextInteger(1, #itemNames);
  local itemName = itemNames[randomIndex];
  local item = items[itemName];

  return item.new(round);

end;

function ActionItem.get(itemName: string, round: IRound.IRound): ActionItem

  local items = ActionItem.listClasses();
  local item = items[itemName];

  if not item then

    error(`Action item {itemName} not found.`);

  end;

  return item.new(round);

end;

return ActionItem;