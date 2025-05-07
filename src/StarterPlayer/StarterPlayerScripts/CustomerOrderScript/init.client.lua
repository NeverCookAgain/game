--!strict

local Players = game:GetService("Players");
local ProximityPromptService = game:GetService("ProximityPromptService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");

local React = require(ReplicatedStorage.Shared.Packages.react);
local ReactRoblox = require(ReplicatedStorage.Shared.Packages["react-roblox"]);
local ICustomer = require(ReplicatedStorage.Client.Customer.types);
local Round = require(ReplicatedStorage.Client.Round);

local CustomerOrderWindow = require(script.CustomerOrderWindow);
local CustomerReceipt = require(script.CustomerReceipt);

local screenGUI: ScreenGui?;

ProximityPromptService.PromptTriggered:Connect(function(prompt)

  local possibleCustomerModel = prompt:FindFirstAncestorOfClass("Model");
  local customerNames = {"CustomerA", "CustomerB", "CustomerC", "CustomerD"};
  if possibleCustomerModel and table.find(customerNames, possibleCustomerModel.Name) then

    local round = Round.getFromServerRound();
    if not round then

      return;

    end;
    local contestant = round:findContestantFromPlayer(Players.LocalPlayer);
    if not contestant then

      return;

    end;

    local customerID = possibleCustomerModel:GetAttribute("CustomerID");
    local customer = ReplicatedStorage.Shared.Functions.GetCustomer:InvokeServer(customerID) :: ICustomer.ICustomer;

    local assignedCustomer;
    if contestant.assignedCustomerID and customerID == contestant.assignedCustomerID then

      for _, possibleCustomer in round.customers do

        if possibleCustomer.id == customerID then

          assignedCustomer = possibleCustomer;
          break;

        end;

      end;

    end;

    if assignedCustomer then

      ReplicatedStorage.Shared.Functions.DeliverSandwich:InvokeServer();
      prompt.ActionText = "Take order";
    
    elseif customer.order and not screenGUI then

      ProximityPromptService.Enabled = false;

      local newScreenGUI = Instance.new("ScreenGui");
      screenGUI = newScreenGUI;
      newScreenGUI.Name = "CustomerOrder";
      newScreenGUI.ScreenInsets = Enum.ScreenInsets.None;
      newScreenGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
      newScreenGUI.Parent = Players.LocalPlayer.PlayerGui;

      local customerOrderRoot = ReactRoblox.createRoot(newScreenGUI);

      local function closeGUI()

        ProximityPromptService.Enabled = true;
        newScreenGUI:Destroy();
        customerOrderRoot:unmount();
        screenGUI = nil;

      end;

      customerOrderRoot:render(React.createElement(CustomerOrderWindow, {
        customer = customer;
        onAccept = function()

          ReplicatedStorage.Shared.Functions.AcceptCustomer:InvokeServer(customerID);
          prompt.ActionText = "Deliver sandwich";
          prompt.Enabled = true;

          closeGUI();

        end;
        onClose = closeGUI;
      }));

    end;

  end;

end);

local receiptGUI = Instance.new("ScreenGui");
receiptGUI.Name = "Receipt";
receiptGUI.ScreenInsets = Enum.ScreenInsets.None;
receiptGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
receiptGUI.Parent = Players.LocalPlayer.PlayerGui;

local receiptRoot = ReactRoblox.createRoot(receiptGUI);

local function updateOrder()

  local round = Round.getFromServerRound();
  if not round then return receiptRoot:unmount(); end;

  local contestant = round:findContestantFromPlayer(Players.LocalPlayer);
  if not contestant then return receiptRoot:unmount(); end;

  local customerID = contestant.assignedCustomerID;
  if not customerID then return receiptRoot:unmount(); end;
  
  local customer = ReplicatedStorage.Shared.Functions.GetCustomer:InvokeServer(customerID) :: ICustomer.ICustomer;
  if not customer then return receiptRoot:unmount(); end;

  receiptRoot:render(React.createElement(CustomerReceipt, {
    order = customer.order;
  }));
  
end;

ReplicatedStorage.Shared.Events.CustomerAssignmentChanged.OnClientEvent:Connect(updateOrder);
updateOrder();