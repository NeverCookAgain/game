--!strict

export type RoundStatus = "Active" | "Inactive";

export type EventBaseProperties = {
  name: string;
  start: (self: IEvent) -> ();
  stop: (self: IEvent) -> ();
}

export type EventConstructorProperties = EventBaseProperties & {
}

export type EventProperties = EventBaseProperties & {
  type: "Event";
  status: RoundStatus;
};

export type EventMethods = {
  start: (self: IEvent) -> ();
  stop: (self: IEvent) -> ();
};

export type EventEvents = {
  EventStarted: RBXScriptSignal;
  EventStopped: RBXScriptSignal;
}

export type IEvent = EventProperties & EventMethods & EventEvents;

return {};