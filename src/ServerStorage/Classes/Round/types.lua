--!strict

local ServerStorage = game:GetService("ServerStorage");

local IContestant = require(ServerStorage.Classes.Contestant.types);
local IEvent = require(ServerStorage.Classes.Event.types);
local ICustomer = require(ServerStorage.Classes.Customer.types);

export type RoundStatus = "Preparing" | "Ongoing" | "Ended";

export type RoundBaseProperties = {}

export type RoundConstructorProperties = RoundBaseProperties & {
  status: RoundStatus?;
  events: {IEvent.IEvent}?;
  contestants: {IContestant.IContestant}?;
  customers: {ICustomer.ICustomer}?;
}

export type RoundProperties = RoundBaseProperties & {
  status: RoundStatus;
  events: {IEvent.IEvent};
  contestants: {IContestant.IContestant};
  customers: {ICustomer.ICustomer};
  startTimeMilliseconds: number?;
  completionTimeMilliseconds: number?;
};

export type RoundMethods = {
  addContestant: (self: IRound, contestant: IContestant.IContestant) -> ();
  addEvent: (self: IRound, event: IEvent.IEvent) -> ();
  removeEvent: (self: IRound, event: IEvent.IEvent) -> ();
  setStatus: (self: IRound, newStatus: RoundStatus) -> ();
  findContestantFromPlayer: (self: IRound, targetPlayer: Player) -> IContestant.IContestant?;
  findCustomerFromID: (self: IRound, targetCustomerID: string) -> ICustomer.ICustomer?;
  findChefFromID: (self: IRound, targetChefID: string) -> IContestant.IContestant?;
};

export type RoundEvents = {
  ContestantsChanged: RBXScriptSignal;
  RoundChanged: RBXScriptSignal;
  EventsChanged: RBXScriptSignal<{IEvent.IEvent}>;
}

export type IRound = RoundProperties & RoundMethods & RoundEvents;

return {};