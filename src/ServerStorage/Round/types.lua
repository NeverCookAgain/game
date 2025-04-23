--!strict

local ServerStorage = game:GetService("ServerStorage");

local IContestant = require(ServerStorage.Contestant.types);

export type RoundStatus = "Preparing" | "Ongoing" | "Ended";

export type RoundProperties = {
  status: RoundStatus;
  durationSeconds: number;
  contestants: {IContestant.IContestant};
};

export type RoundMethods = {
  addContestant: (self: IRound, contestant: IContestant.IContestant) -> ();
  setStatus: (self: IRound, newStatus: RoundStatus) -> ();
  findContestantFromPlayer: (self: IRound, targetPlayer: Player) -> IContestant.IContestant?;
};

export type RoundEvents = {
  ContestantsChanged: RBXScriptSignal;
  RoundChanged: RBXScriptSignal;
}

export type IRound = RoundProperties & RoundMethods & RoundEvents;

return {};