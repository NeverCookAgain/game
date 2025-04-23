export type RoundStatus = "Preparing" | "Ongoing" | "Ended";

export type RoundProperties = {
  status: RoundStatus;
  durationSeconds: number;
};

export type RoundMethods = {
  setStatus: (self: IRound, newStatus: RoundStatus) -> ()
};

export type RoundEvents = {
  RoundChanged: RBXScriptSignal;
}

export type IRound = RoundProperties & RoundMethods & RoundEvents;

return {};