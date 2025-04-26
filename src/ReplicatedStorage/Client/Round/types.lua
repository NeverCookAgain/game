--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage");

local IContestant = require(ReplicatedStorage.Client.Contestant.types);

export type RoundStatus = "Preparing" | "Ongoing" | "Ended";

export type RoundBaseProperties = {}

export type RoundConstructorProperties = RoundBaseProperties & {
  status: RoundStatus?;
  contestants: {IContestant.IContestant}?;
}

export type RoundProperties = RoundBaseProperties & {
  status: RoundStatus;
  contestants: {IContestant.IContestant};
  startTimeMilliseconds: number?;
  completionTimeMilliseconds: number?;
};

export type RoundMethods = {

};

export type RoundEvents = {
  ContestantsChanged: RBXScriptSignal;
  RoundChanged: RBXScriptSignal;
}

export type IRound = RoundProperties & RoundMethods & RoundEvents;

return {};