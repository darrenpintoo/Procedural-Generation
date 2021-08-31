local Start = os.clock()
local Graph = require(game.ServerStorage.Maze.Graph)

local PartSize = 25

local TemplatePart = Instance.new("Part")
TemplatePart.Size = Vector3.new(PartSize + .001, PartSize + .001, PartSize + .001)
TemplatePart.Anchored = true

local TemplateWall = Instance.new("Part")
TemplateWall.Anchored = true
TemplateWall.Size = Vector3.new(PartSize, PartSize*2, PartSize/10)

local PartsFolder = Instance.new("Folder")
PartsFolder.Name = "PartsFolder"
PartsFolder.Parent = workspace

local PartWalls = Instance.new("Folder")
PartWalls.Name = "PartWalls"
PartWalls.Parent = workspace

local Size = 50 -- Size block x Size blocks

local Parts = table.create(Size)

local WallBetween = {}

for i = 1, Size do
	Parts[i] = table.create(Size)
end

local ClonePart

local NewGraph = Graph.New()

local function GetPosition(Part, Angle)

	if Angle == 90 then
		return Vector3.new(Part.Size.X/2, 0, 0) 
	elseif Angle == 180 then
		return Vector3.new(0, 0, Part.Size.Z/2)
	elseif Angle == 270 then
		return Vector3.new(-(Part.Size.X/2), 0, 0)
	else
		return Vector3.new(0, 0, -(Part.Size.Z/2))
	end
end

local function GetKey(Part, Angle, X, Z)
	return Angle == 90 and Parts[X+1] and Parts[X+1][Z] or Parts[X][Z+1]
end

local SpawnPoint = Instance.new("SpawnLocation")
SpawnPoint.Anchored = true

for X = 1, Size do

	for Z = 1, Size do
		ClonePart = TemplatePart:Clone()
		ClonePart.Position = Vector3.new(X * PartSize, 1, Z * PartSize)
		ClonePart.Name = string.format("%d_%d", X, Z)
		ClonePart.Parent = PartsFolder
		
		NewGraph:AddVertex(ClonePart)
		Parts[X][Z] = ClonePart
		WallBetween[ClonePart] = {}
	end
	
end
SpawnPoint.Position = Parts[1][1].Position
SpawnPoint.Parent = workspace

for X = 1, Size do

	for Z = 1, Size do
		
		local CurrentPart = Parts[X][Z]
		local Points = { ( Parts[X+1] and Parts[X+1][Z] ) , Parts[X][Z+1], Parts[X][Z-1], ( Parts[X-1] and Parts[X-1][Z] ) }

		NewGraph:AddEdge(CurrentPart, Points)
		
		for i = 90, 180, 90 do
			local Index = GetKey(CurrentPart, i, X, Z)
			
			if not Index then continue end
			
			local NewWall = TemplateWall:Clone()
			NewWall.Orientation = Vector3.new(0, i, 0)
			NewWall.Position = CurrentPart.Position + GetPosition(CurrentPart, i)
			NewWall.Parent = PartWalls
			
			WallBetween[CurrentPart][Index], WallBetween[Index][CurrentPart] = NewWall, NewWall

		end
		
	end
end


for Index, Previous, Current in NewGraph:DepthFirstSearch() do
	game:GetService("RunService").Heartbeat:Wait()
	if WallBetween[Previous][Current] then WallBetween[Previous][Current]:Destroy() end
end

Parts[1][1].BrickColor = BrickColor.new("Br. yellowish green")
Parts[Size][Size].BrickColor = BrickColor.new("Sage green")
print(os.clock()-Start)
