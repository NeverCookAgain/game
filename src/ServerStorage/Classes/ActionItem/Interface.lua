--!strict

export type ActionItemBaseProperties = {
  name: string;
  description: string;
  modelTemplate: Model;
  chefID: string?;
}

export type ActionItemConstructorProperties = ActionItemBaseProperties & {
  activate: (self: ActionItem) -> ();
}

export type ExtendedActionItemConstructorProperties = {
  chefID: string?;
}

export type ActionItemProperties = {
  type: "ActionItem";
} & ActionItemBaseProperties & ActionItemConstructorProperties;

export type ActionItemMethods = {
  activate: (self: ActionItem) -> ();
  drop: (self: ActionItem, originalPosition: CFrame) -> ();
}

export type ActionItem = ActionItemProperties & ActionItemMethods;

return {};