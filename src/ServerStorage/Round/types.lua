export type RoundStatus = "Preparing" | "Ongoing" | "Ended";

export type RoundProperties = {
  status: RoundStatus;
  durationSeconds: number;
};

export type RoundMethods = {
  setStatus: (self: Round, newStatus: RoundStatus) -> ()
};

export type RoundEvents = {
  RoundChanged: RBXScriptSignal;
}

export type Round = RoundProperties & RoundMethods & RoundEvents;

return {};