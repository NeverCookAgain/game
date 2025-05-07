--!strict

export type ActionItemProperties = {
  type: "ActionItem";
  name: string;
  description: string;
  modelTemplate: Model;
  chefID: string?;
}

export type ActionItemConstructorProperties = {
  chefID: string?;
}

export type ActionItemMethods = {
  activate: (self: ActionItem) -> ();
}

export type ActionItem = ActionItemProperties & ActionItemMethods;

return {};