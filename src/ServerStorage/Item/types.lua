export type Status = "Raw" | "Cooked" | "Burnt";

export type ItemProperties = {
  name: string;
  description: string;
  status: Status;
  model: Model?;
};

export type ItemMethods = {
  
};

export type ItemEvents = {
  StatusChanged: (status: Status) -> ()
}

export type IItem = ItemProperties;

return {};