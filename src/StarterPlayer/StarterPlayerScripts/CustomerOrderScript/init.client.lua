--!strict

local Players = game:GetService("Players");
local ProximityPromptService = game:GetService("ProximityPromptService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");

local React = require(ReplicatedStorage.Shared.Packages.react);
local ReactRoblox = require(ReplicatedStorage.Shared.Packages["react-roblox"]);

local CustomerOrderWindow = require(script.CustomerOrderWindow);

local screenGUI: ScreenGui?;

ProximityPromptService.PromptTriggered:Connect(function(prompt)

  local possibleCustomerModel = prompt:FindFirstAncestorOfClass("Model");
  local customerNames = {"CustomerA", "CustomerB", "CustomerC", "CustomerD"};
  if possibleCustomerModel and table.find(customerNames, possibleCustomerModel.Name) then

    local customer = ReplicatedStorage.Shared.Functions.GetCustomer:InvokeServer(possibleCustomerModel.Name);
    if customer.order and not screenGUI then

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

          ReplicatedStorage.Shared.Functions.AcceptCustomer:InvokeServer(possibleCustomerModel.Name);
          closeGUI();

        end;
        onClose = closeGUI;
      }));

    end;

  end;

end);
