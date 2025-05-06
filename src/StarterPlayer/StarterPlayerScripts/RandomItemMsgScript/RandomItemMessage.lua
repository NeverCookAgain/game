--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage");

local React = require(ReplicatedStorage.Shared.Packages.react)

local function RandomItemMessage(props)

  React.useEffect(function()

    task.delay(2, function()
      props.onClose()
    end)

  end, {})

  return React.createElement("TextLabel", {
    Size = UDim2.fromScale(0.3, 0.1),
    Position = UDim2.fromScale(0.35, 0.05),
    BackgroundTransparency = 0.5,
    BackgroundColor3 = Color3.fromRGB(255,255,255),
    Text = "Random item has spawned!",
    FontFace = Font.fromName("Kalam"),
    TextScaled = true,
    TextColor3 = Color3.fromRGB(0, 0, 0)
  })
end

return RandomItemMessage;