-- !strict

type PartsHolder = {
	[number] : {
		[number] : number? 
	}?
}

wait(4)

local S : number = os.clock()

--workspace.Part:Destroy()
--workspace.Part:Destroy()

local RunService : service = game:GetService("RunService")

local RandomSeed = Random.new()

local Seed : number = RandomSeed:NextInteger(0, 1000000)

local XSize : number = 1
local YSize : number = 1
local ZSize : number = 1

local XMax : number = 100
local ZMax : number = 100

print("Total Number of Blocks :", XMax * ZMax)

local XOffset : number = -349.44 -- RandomSeed:NextNumber(-1000, 1000)
local ZOffset : number = 279.554 -- RandomSeed:NextNumber(-1000, 1000)

local WorldSeed : string = (Seed..XOffset..ZOffset)--("%d%s%s"):format(Seed, XOffset * -1 ~= XOffset and string.format("01%d", XOffset * -1) or string.format("00%d", XOffset), ZOffset * -1 ~= ZOffset and string.format("01%d", ZOffset * -1) or string.format("00%d", ZOffset))

print(WorldSeed)

local Part : Part = Instance.new("Part")
Part.Anchored = true
Part.Size = Vector3.new(XSize * 10, YSize * 10, ZSize * 10)
Part.Color = Color3.new(1, 0.999939, 0.0410315)
Part.Material = Enum.Material.Sand

local Parts : PartsHolder? = table.create(XMax/XSize)
		
wait(1)
for x : number = 1, XMax, XSize do
	
	Parts[x] = table.create(math.ceil(ZMax/ZSize))
	
	for z : number = 1, ZMax, ZSize do
		
		local Part1 : Part = Part:Clone()
		Part1.Position = Vector3.new(x*10, 
			math.noise(Seed, x/10 + XOffset, z/10 + ZOffset) * ( (YSize * 9) * 5),
			z*10)
		Parts[x][z] = Part1
		
	end
end

wait(1)

for x : number = 1, XMax, XSize do
	
	for z : number = 1, ZMax, ZSize do
		
		Parts[x][z].Parent = workspace
		
	end
	
	RunService.Heartbeat:Wait()
	
end

print("Done")

wait(1)

print(os.clock() - S)
