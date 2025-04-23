export type Status = "Raw" | "Cooked" | "Burnt";

export type ItemProperties = {
  name: string;
  description: string;
  status: Status;
  part: BasePart?;
};

export type ItemMethods = {
  setStatus: (item: IItem, newStatus: Status) -> ();
  drop: (item: IItem, origin: Vector3, direction: Vector3) -> ();
};

export type ItemEvents = {
  StatusChanged: RBXScriptSignal;
}

export type IItem = ItemProperties & ItemMethods & ItemEvents;

return {};