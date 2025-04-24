export type Status = "Raw" | "Cooked" | "Burnt";

export type ItemBaseProperties = {
  name: string;
  description: string;
  image: string;
  status: Status;
  part: BasePart?;
}

export type ItemConstructorProperties = ItemBaseProperties & {
  templatePart: BasePart?;
}

export type ItemProperties = ItemBaseProperties & {
  type: "Item";
  templatePart: BasePart;
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