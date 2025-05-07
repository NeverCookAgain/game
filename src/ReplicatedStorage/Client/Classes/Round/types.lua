--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage");

local IContestant = require(ReplicatedStorage.Client.Classes.Contestant.types);
local ICustomer = require(ReplicatedStorage.Client.Classes.Customer.types);

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
  findChefFromID: (self: IRound, chefID: string) -> IContestant.IContestant?;
};

export type RoundEvents = {
  ContestantsChanged: RBXScriptSignal;
  RoundChanged: RBXScriptSignal;
}

export type IRound = RoundProperties & RoundMethods & RoundEvents;

return {};