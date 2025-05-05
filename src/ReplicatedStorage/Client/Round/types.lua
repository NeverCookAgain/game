--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage");

local IContestant = require(ReplicatedStorage.Client.Contestant.types);
local ICustomer = require(ReplicatedStorage.Client.Customer.types);

export type RoundStatus = "Preparing" | "Ongoing" | "Ended";

export type RoundBaseProperties = {}

export type RoundConstructorProperties = RoundBaseProperties & {
  status: RoundStatus?;
  contestants: {IContestant.IContestant};
  customers: {ICustomer.ICustomer};
}

export type RoundProperties = RoundBaseProperties & {
  status: RoundStatus;
  contestants: {IContestant.IContestant};
  customers: {ICustomer.ICustomer};
  startTimeMilliseconds: number?;
  completionTimeMilliseconds: number?;
};

export type RoundMethods = {
  findContestantFromPlayer: (self: IRound, player: Player) -> IContestant.IContestant?;
};

export type RoundEvents = {
  ContestantsChanged: RBXScriptSignal;
  RoundChanged: RBXScriptSignal;
}

export type IRound = RoundProperties & RoundMethods & RoundEvents;

return {};