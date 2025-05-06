export type Status = "Raw" | "Cooked" | "Burnt";

export type ItemProperties = {
  type: "Item";
  name: string;
  description: string;
  status: Status;
  part: BasePart?;
};

export type ItemMethods = {
  setStatus: (item: IItem, newStatus: Status) -> ();
};

export type ItemEvents = {
  StatusChanged: RBXScriptSignal;
}

export type IItem = ItemProperties & ItemMethods & ItemEvents;

return {};