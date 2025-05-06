--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local React = require(ReplicatedStorage.Shared.Packages.react)


local foodItems = ReplicatedStorage.Shared.Functions.GetIngredients:InvokeServer();

local itemsPerPage = 8

local function FridgeContainer(props)
	local startOpen = props.startOpen or false
	local isOpen, setIsOpen = React.useState(startOpen)
	local currentPage, setCurrentPage = React.useState(1)

	React.useEffect(function()
		setIsOpen(startOpen)
	end, {startOpen})

	local function updatePage(offset: number)
		setCurrentPage(math.clamp(currentPage + offset, 1, math.ceil(#foodItems / itemsPerPage)))
	end

	if not isOpen then
		return nil
	end

	local startIndex = (currentPage - 1) * itemsPerPage + 1
	local endIndex = math.min(currentPage * itemsPerPage, #foodItems)

	local displayedItems = {}
	for i = startIndex, endIndex do
		local foodItem = foodItems[i]
		table.insert(displayedItems, React.createElement("ImageButton", {
			Name = foodItem.name,
			Size = UDim2.new(0, 120, 0, 120),
			Image = foodItem.image,
			BackgroundTransparency = 1;
			[React.Event.MouseButton1Click] = function()
				ReplicatedStorage.Shared.Functions.AddIngredientToInventory:InvokeServer(foodItem.name);
				props.onClose();
			end,
		}))
	end

	return React.createElement("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, 666, 0, 237),
		BackgroundTransparency = 1,
	}, {
		
		BackgroundImage = React.createElement("ImageLabel", {
			Size = UDim2.fromScale(1, 1),
			Image = "rbxassetid://137018338177172", 
			BackgroundTransparency = 1,
			ZIndex = 1;
		}),

	
		foodItemGrid = React.createElement("Frame", {
			Size = UDim2.fromScale(1, 0.75),
			Position = UDim2.fromScale(0, 0.1),
			BackgroundTransparency = 1,
			ZIndex = 2;
		}, {
			UIPadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 15),
				PaddingBottom = UDim.new(0, 15),
				PaddingLeft = UDim.new(0, 60),
				PaddingRight = UDim.new(0, 60),
			}),
			UIGridLayout = React.createElement("UIGridLayout", {
				CellSize = UDim2.new(0, 90, 0, 90),
				CellPadding = UDim2.new(0, 5, 0, 5),
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				FillDirectionMaxCells = 4,
			}),
			Items = React.createElement(React.Fragment, {}, displayedItems);
		}),

		nextButton = React.createElement("ImageButton", {
			Size = UDim2.new(0, 50, 0, 50),
			Position = UDim2.new(1, -60, 1, -60), 
			Image = "rbxassetid://133982941769442",
			BackgroundTransparency = 1,
			[React.Event.MouseButton1Click] = function()
				updatePage(1)
			end,
			ZIndex = 2;
		}),

		prevButton = React.createElement("ImageButton", {
			Size = UDim2.new(0, 50, 0, 50),
			Position = UDim2.new(0, 10, 1, -60),  
			Image = "rbxassetid://118100992314434",  
			BackgroundTransparency = 1,
			[React.Event.MouseButton1Click] = function()
				updatePage(-1)
			end,
			ZIndex = 2;
		}),

		closeButton = React.createElement("ImageButton", {
			Size = UDim2.new(0, 50, 0, 50),
			Position = UDim2.new(1, -60, 0, 10),  
			Image = "rbxassetid://111357809643186", 
			BackgroundTransparency = 1,
			[React.Event.MouseButton1Click] = function()
				props.onClose();
			end,
			ZIndex = 2;
		}),
	})
end

return FridgeContainer
