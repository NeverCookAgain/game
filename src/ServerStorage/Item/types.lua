export type Status = "Raw" | "Cooked" | "Burnt";

export type ItemBaseProperties = {
  name: string;
  description: string;
  image: string;
  status: Status;
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
  createPart: (item: IItem) -> BasePart;
  drop: (item: IItem, origin: CFrame, direction: Vector3) -> BasePart;
};

export type ItemEvents = {
  StatusChanged: RBXScriptSignal;
}

export type IItem = ItemProperties & ItemMethods & ItemEvents;

return {};