-- YoshI/O by BrunoValads
-- Just a port of SethBling's MarI/O
-- partially translated to Snes9x 1.43 v18 API by Amaraticando
-- Feel free to use this code, but please do not redistribute it.
-- Intended for use with the Snes9x-rr emulator and Super Mario World 2 - Yoshi's Island ROM.
-- Start this script a bit prior to the desired level, an internal savestate will be created then...
 
-- USER OPTIONS
local OPTIONS = {
	showNetwork = true,
	showMutationRates = false,
	hideBanner = false,
	display_fitness_lines = true,
	draw_tile_map_type = false,
	draw_tile_map_grid = false,
	draw_tile_map_screen = false
}
 
-- Compatibility
function gui.drawBox(x1, y1, x2, y2, line, fill) gui.box(x1, y1, x2, y2, fill, line) end
gui.drawText = gui.text
gui.drawLine = gui.line
--function memory.read_s8(address) return memory.readbytesigned(0x700000 + address) end     --\ Bank 0x70 is SFXRAM
--function memory.read_s16_le(address) return memory.readwordsigned(0x700000 + address) end --/
function joypad.set2(controler) joypad.table = controller end

fmt = string.format
 
Savestate_object = savestate.create() -- savestate is created on the fly, not a previous "DP1.state"
savestate.save(Savestate_object)
 
ButtonNames = {
    "A",
    "B",
    "X",
    "Y",
    "up",
    "down",
    "left",
    "right",
}
 
BoxRadius = 6
InputSize = (BoxRadius*2+1)*(BoxRadius*2+1)
 
Inputs = InputSize+1
Outputs = #ButtonNames
 
Population = 300
DeltaDisjoint = 2.0
DeltaWeights = 0.4
DeltaThreshold = 1.0
 
StaleSpecies = 15
 
MutateConnectionsChance = 0.25
PerturbChance = 0.90
CrossoverChance = 0.75
LinkMutationChance = 2.0
NodeMutationChance = 0.50
BiasMutationChance = 0.40
StepSize = 0.1
DisableMutationChance = 0.4
EnableMutationChance = 0.2
 
TimeoutConstant = 20
 
MaxNodes = 1000000

Y_CAMERA_OFF = 1 

RAM = {
    yoshi_x = 0x70008C, -- 2 bytes
    yoshi_y = 0x700090, -- 2 bytes
	invincibility_timer = 0x7001D6, -- 2 bytes
	
	baby_mario_x = 0x7010E2, -- 2 bytes
	baby_mario_y = 0x701182, -- 2 bytes
	
	sprite_status = 0x700F00,
    sprite_x = 0x7010E0, -- 2 bytes
    sprite_y = 0x701180, -- 2 bytes
	
    camera_x = 0x7E0039, -- 2 bytes
    camera_y = 0x7E003B, -- 2 bytes
	
	screen_number_to_id = 0x700CAA, -- 128 bytes table
	Map16_data = 0x7F8000, -- 32768 bytes table, in words
}

SOLID_BLOCKS = { -- solid and one-way solid blocks, via tests
	0x01, 0x02, 0x03, 0x05, 0x06, 0x08, 0x0A, 0x0C, 0x0D, 0x0F,
	0x10, 0x15, 0x1A, 0x1B, 0x1C ,
	0x29, 0x2C, 0x2F,
	0x33, 0x38, 0x39, 0x3E, 0x3F,
	0x40, 0x41, 0x44, 0x45, 0x48, 0x49, 0x4B, 0x4C, 0x4E,
	0x50, 0x53, 0x55, 0x57, 0x59, 0x5B, 0x5D, 0x5F,
	0x66, 0x67, 0x6B, 0x6E,
	0x79, 0x7D,
	0x90, 0x95, 0x9A, 0x9D, 0x9F,
	0xA0, 0xA1, 0xA2
}

-- draws a rectangle given (x,y) and dimensions, with SNES' pixel sizes
local draw_rectangle = function(x, y, w, h, line, fill)
    gui.box(x, y, x + w, y + h, fill, line)
end

-- Converts the in-game (x, y) to SNES-screen coordinates
local function screen_coordinates(x, y)
    
    camera_x = memory.readwordsigned(RAM.camera_x)
    camera_y = memory.readwordsigned(RAM.camera_y)
    
    local x_screen = (x - camera_x)
    local y_screen = (y - camera_y) - Y_CAMERA_OFF
    
    return x_screen, y_screen
end

function getPositions()
    yoshi_x = memory.readwordsigned(RAM.yoshi_x)
    yoshi_y = memory.readwordsigned(RAM.yoshi_y)
   
    yoshi_screen_x, yoshi_screen_y = screen_coordinates(yoshi_x, yoshi_y)
	
    baby_mario_x = memory.readwordsigned(RAM.baby_mario_x)
    baby_mario_y = memory.readwordsigned(RAM.baby_mario_y)
   
    baby_mario_screen_x, baby_mario_screen_y = screen_coordinates(baby_mario_x, baby_mario_y)
	
	
end
 
function getTile(dx, dy)
    x = 16*math.floor((yoshi_x + dx + 4)/16)  --\ Yoshi's center tile
    y = 16*math.floor((yoshi_y + dy + 10)/16) --/
   
	local screen_region_x = math.floor(x/256) 
	local screen_region_y = math.floor(y/256)
	
	local screen_number = screen_region_y*16 + screen_region_x
	local screen_id = memory.readbyte(RAM.screen_number_to_id + screen_number)
	
	local block_x = (x%256)/16
	local block_y = (y%256)/16
	
	local block_id = 256*screen_id + 16*block_y + block_x
	
	local kind_low = memory.readbyte(RAM.Map16_data + 2*block_id) -- 
	local kind_high = memory.readbyte(RAM.Map16_data + 2*block_id + 1) --
	
    return kind_high
end
 
function getSprites()
    local sprites = {}
    for id = 0, 23 do
		
		-- id to read memory correctly
		local id_off = 4*id
		
        local status = memory.readbyte(RAM.sprite_status + id_off)
        if status ~= 0 then
            sprite_x = memory.readwordsigned(RAM.sprite_x + id_off + 2)
            sprite_y = memory.readwordsigned(RAM.sprite_y + id_off + 2)
            sprites[#sprites+1] = {["x"]=sprite_x, ["y"]=sprite_y}
        end
    end        
   
    return sprites
end
 
function getExtendedSprites() -- not used in this YI port
    local extended = {}
    for id=0,11 do
        local number = memory.readbyte(0x7e170B+id)
        if number ~= 0 then
            spritex = memory.readbyte(0x7e171F+id) + memory.readbyte(0x7e1733+id)*256
            spritey = memory.readbyte(0x7e1715+id) + memory.readbyte(0x7e1729+id)*256
            extended[#extended+1] = {["x"]=spritex, ["y"]=spritey}
        end
    end        
   
    return extended
end
 
function getInputs()  -- not ready
        getPositions()
       
        sprites = getSprites()
        --extended = getExtendedSprites()
       
        local inputs = {}
	   
        for dy=-BoxRadius*16,BoxRadius*16,16 do
                for dx=-BoxRadius*16,BoxRadius*16,16 do
                        inputs[#inputs+1] = 0
                       
                        tile_high = getTile(dx, dy)
						
						local tile_is_solid = false
						for i = 1, #SOLID_BLOCKS do
							if tile_high == SOLID_BLOCKS[i] then
								tile_is_solid = true
								break
							end
						end
						
                        if tile_is_solid then --and yoshi_y+dy < 0x100 then
                                inputs[#inputs] = 1
                        end
                       
                        for i = 1,#sprites do
                                distx = math.abs(sprites[i]["x"] - (yoshi_x+dx))
                                disty = math.abs(sprites[i]["y"] - (yoshi_y+dy))
                                if distx <= 8 and disty <= 8 then
                                        inputs[#inputs] = -1
                                end
                        end
 
						--[[
                        for i = 1,#extended do
                                distx = math.abs(extended[i]["x"] - (yoshi_x+dx))
                                disty = math.abs(extended[i]["y"] - (yoshi_y+dy))
                                if distx < 8 and disty < 8 then
                                        inputs[#inputs] = -1
                                end
                        end]]
				end
				
        end
		
        return inputs
end
 
function sigmoid(x)
        return 2/(1+math.exp(-4.9*x))-1
end
 
function newInnovation()
        pool.innovation = pool.innovation + 1
        return pool.innovation
end
 
function newPool()
        local pool = {}
        pool.species = {}
        pool.generation = 0
        pool.innovation = Outputs
        pool.currentSpecies = 1
        pool.currentGenome = 1
        pool.currentFrame = 0
        pool.maxFitness = 0
       
        return pool
end
 
function newSpecies()
        local species = {}
        species.topFitness = 0
        species.staleness = 0
        species.genomes = {}
        species.averageFitness = 0
       
        return species
end
 
function newGenome()
        local genome = {}
        genome.genes = {}
        genome.fitness = 0
        genome.adjustedFitness = 0
        genome.network = {}
        genome.maxneuron = 0
        genome.globalRank = 0
        genome.mutationRates = {}
        genome.mutationRates["connections"] = MutateConnectionsChance
        genome.mutationRates["link"] = LinkMutationChance
        genome.mutationRates["bias"] = BiasMutationChance
        genome.mutationRates["node"] = NodeMutationChance
        genome.mutationRates["enable"] = EnableMutationChance
        genome.mutationRates["disable"] = DisableMutationChance
        genome.mutationRates["step"] = StepSize
       
        return genome
end
 
function copyGenome(genome)
        local genome2 = newGenome()
        for g=1,#genome.genes do
                table.insert(genome2.genes, copyGene(genome.genes[g]))
        end
        genome2.maxneuron = genome.maxneuron
        genome2.mutationRates["connections"] = genome.mutationRates["connections"]
        genome2.mutationRates["link"] = genome.mutationRates["link"]
        genome2.mutationRates["bias"] = genome.mutationRates["bias"]
        genome2.mutationRates["node"] = genome.mutationRates["node"]
        genome2.mutationRates["enable"] = genome.mutationRates["enable"]
        genome2.mutationRates["disable"] = genome.mutationRates["disable"]
       
        return genome2
end
 
function basicGenome()
        local genome = newGenome()
        local innovation = 1
 
        genome.maxneuron = Inputs
        mutate(genome)
       
        return genome
end
 
function newGene()
        local gene = {}
        gene.into = 0
        gene.out = 0
        gene.weight = 0.0
        gene.enabled = true
        gene.innovation = 0
       
        return gene
end
 
function copyGene(gene)
        local gene2 = newGene()
        gene2.into = gene.into
        gene2.out = gene.out
        gene2.weight = gene.weight
        gene2.enabled = gene.enabled
        gene2.innovation = gene.innovation
       
        return gene2
end
 
function newNeuron()
        local neuron = {}
        neuron.incoming = {}
        neuron.value = 0.0
       
        return neuron
end
 
function generateNetwork(genome)
        local network = {}
        network.neurons = {}
       
        for i=1,Inputs do
                network.neurons[i] = newNeuron()
        end
       
        for o=1,Outputs do
                network.neurons[MaxNodes+o] = newNeuron()
        end
       
        table.sort(genome.genes, function (a,b)
                return (a.out < b.out)
        end)
        for i=1,#genome.genes do
                local gene = genome.genes[i]
                if gene.enabled then
                        if network.neurons[gene.out] == nil then
                                network.neurons[gene.out] = newNeuron()
                        end
                        local neuron = network.neurons[gene.out]
                        table.insert(neuron.incoming, gene)
                        if network.neurons[gene.into] == nil then
                                network.neurons[gene.into] = newNeuron()
                        end
                end
        end
       
        genome.network = network
end
 
function evaluateNetwork(network, inputs)
        table.insert(inputs, 1)
        if #inputs ~= Inputs then
                print("Incorrect number of neural network inputs.")
                return {}
        end
       
        for i=1,Inputs do
                network.neurons[i].value = inputs[i]
        end
       
        for _,neuron in pairs(network.neurons) do
                local sum = 0
                for j = 1,#neuron.incoming do
                        local incoming = neuron.incoming[j]
                        local other = network.neurons[incoming.into]
                        sum = sum + incoming.weight * other.value
                end
               
                if #neuron.incoming > 0 then
                        neuron.value = sigmoid(sum)
                end
        end
       
        local outputs = {}
        for o=1,Outputs do
                local button = "P1 " .. ButtonNames[o]
                if network.neurons[MaxNodes+o].value > 0 then
                        outputs[button] = true
                else
                        outputs[button] = false
                end
        end
       
        return outputs
end
 
function crossover(g1, g2)
        -- Make sure g1 is the higher fitness genome
        if g2.fitness > g1.fitness then
                tempg = g1
                g1 = g2
                g2 = tempg
        end
 
        local child = newGenome()
       
        local innovations2 = {}
        for i=1,#g2.genes do
                local gene = g2.genes[i]
                innovations2[gene.innovation] = gene
        end
       
        for i=1,#g1.genes do
                local gene1 = g1.genes[i]
                local gene2 = innovations2[gene1.innovation]
                if gene2 ~= nil and math.random(2) == 1 and gene2.enabled then
                        table.insert(child.genes, copyGene(gene2))
                else
                        table.insert(child.genes, copyGene(gene1))
                end
        end
       
        child.maxneuron = math.max(g1.maxneuron,g2.maxneuron)
       
        for mutation,rate in pairs(g1.mutationRates) do
                child.mutationRates[mutation] = rate
        end
       
        return child
end
 
function randomNeuron(genes, nonInput)
        local neurons = {}
        if not nonInput then
                for i=1,Inputs do
                        neurons[i] = true
                end
        end
        for o=1,Outputs do
                neurons[MaxNodes+o] = true
        end
        for i=1,#genes do
                if (not nonInput) or genes[i].into > Inputs then
                        neurons[genes[i].into] = true
                end
                if (not nonInput) or genes[i].out > Inputs then
                        neurons[genes[i].out] = true
                end
        end
 
        local count = 0
        for _,_ in pairs(neurons) do
                count = count + 1
        end
        local n = math.random(1, count)
       
        for k,v in pairs(neurons) do
                n = n-1
                if n == 0 then
                        return k
                end
        end
       
        return 0
end
 
function containsLink(genes, link)
        for i=1,#genes do
                local gene = genes[i]
                if gene.into == link.into and gene.out == link.out then
                        return true
                end
        end
end
 
function pointMutate(genome)
        local step = genome.mutationRates["step"]
       
        for i=1,#genome.genes do
                local gene = genome.genes[i]
                if math.random() < PerturbChance then
                        gene.weight = gene.weight + math.random() * step*2 - step
                else
                        gene.weight = math.random()*4-2
                end
        end
end
 
function linkMutate(genome, forceBias)
        local neuron1 = randomNeuron(genome.genes, false)
        local neuron2 = randomNeuron(genome.genes, true)
         
        local newLink = newGene()
        if neuron1 <= Inputs and neuron2 <= Inputs then
                --Both input nodes
                return
        end
        if neuron2 <= Inputs then
                -- Swap output and input
                local temp = neuron1
                neuron1 = neuron2
                neuron2 = temp
        end
 
        newLink.into = neuron1
        newLink.out = neuron2
        if forceBias then
                newLink.into = Inputs
        end
       
        if containsLink(genome.genes, newLink) then
                return
        end
        newLink.innovation = newInnovation()
        newLink.weight = math.random()*4-2
       
        table.insert(genome.genes, newLink)
end
 
function nodeMutate(genome)
        if #genome.genes == 0 then
                return
        end
 
        genome.maxneuron = genome.maxneuron + 1
 
        local gene = genome.genes[math.random(1,#genome.genes)]
        if not gene.enabled then
                return
        end
        gene.enabled = false
       
        local gene1 = copyGene(gene)
        gene1.out = genome.maxneuron
        gene1.weight = 1.0
        gene1.innovation = newInnovation()
        gene1.enabled = true
        table.insert(genome.genes, gene1)
       
        local gene2 = copyGene(gene)
        gene2.into = genome.maxneuron
        gene2.innovation = newInnovation()
        gene2.enabled = true
        table.insert(genome.genes, gene2)
end
 
function enableDisableMutate(genome, enable)
        local candidates = {}
        for _,gene in pairs(genome.genes) do
                if gene.enabled == not enable then
                        table.insert(candidates, gene)
                end
        end
       
        if #candidates == 0 then
                return
        end
       
        local gene = candidates[math.random(1,#candidates)]
        gene.enabled = not gene.enabled
end
 
function mutate(genome)
        for mutation,rate in pairs(genome.mutationRates) do
                if math.random(1,2) == 1 then
                        genome.mutationRates[mutation] = 0.95*rate
                else
                        genome.mutationRates[mutation] = 1.05263*rate
                end
        end
 
        if math.random() < genome.mutationRates["connections"] then
                pointMutate(genome)
        end
       
        local p = genome.mutationRates["link"]
        while p > 0 do
                if math.random() < p then
                        linkMutate(genome, false)
                end
                p = p - 1
        end
 
        p = genome.mutationRates["bias"]
        while p > 0 do
                if math.random() < p then
                        linkMutate(genome, true)
                end
                p = p - 1
        end
       
        p = genome.mutationRates["node"]
        while p > 0 do
                if math.random() < p then
                        nodeMutate(genome)
                end
                p = p - 1
        end
       
        p = genome.mutationRates["enable"]
        while p > 0 do
                if math.random() < p then
                        enableDisableMutate(genome, true)
                end
                p = p - 1
        end
 
        p = genome.mutationRates["disable"]
        while p > 0 do
                if math.random() < p then
                        enableDisableMutate(genome, false)
                end
                p = p - 1
        end
end
 
function disjoint(genes1, genes2)
        local i1 = {}
        for i = 1,#genes1 do
                local gene = genes1[i]
                i1[gene.innovation] = true
        end
 
        local i2 = {}
        for i = 1,#genes2 do
                local gene = genes2[i]
                i2[gene.innovation] = true
        end
       
        local disjointGenes = 0
        for i = 1,#genes1 do
                local gene = genes1[i]
                if not i2[gene.innovation] then
                        disjointGenes = disjointGenes+1
                end
        end
       
        for i = 1,#genes2 do
                local gene = genes2[i]
                if not i1[gene.innovation] then
                        disjointGenes = disjointGenes+1
                end
        end
       
        local n = math.max(#genes1, #genes2)
       
        return disjointGenes / n
end
 
function weights(genes1, genes2)
        local i2 = {}
        for i = 1,#genes2 do
                local gene = genes2[i]
                i2[gene.innovation] = gene
        end
 
        local sum = 0
        local coincident = 0
        for i = 1,#genes1 do
                local gene = genes1[i]
                if i2[gene.innovation] ~= nil then
                        local gene2 = i2[gene.innovation]
                        sum = sum + math.abs(gene.weight - gene2.weight)
                        coincident = coincident + 1
                end
        end
       
        return sum / coincident
end
       
function sameSpecies(genome1, genome2)
        local dd = DeltaDisjoint*disjoint(genome1.genes, genome2.genes)
        local dw = DeltaWeights*weights(genome1.genes, genome2.genes)
        return dd + dw < DeltaThreshold
end
 
function rankGlobally()
        local global = {}
        for s = 1,#pool.species do
                local species = pool.species[s]
                for g = 1,#species.genomes do
                        table.insert(global, species.genomes[g])
                end
        end
        table.sort(global, function (a,b)
                return (a.fitness < b.fitness)
        end)
       
        for g=1,#global do
                global[g].globalRank = g
        end
end
 
function calculateAverageFitness(species)
        local total = 0
       
        for g=1,#species.genomes do
                local genome = species.genomes[g]
                total = total + genome.globalRank
        end
       
        species.averageFitness = total / #species.genomes
end
 
function totalAverageFitness()
        local total = 0
        for s = 1,#pool.species do
                local species = pool.species[s]
                total = total + species.averageFitness
        end
 
        return total
end
 
function cullSpecies(cutToOne)
        for s = 1,#pool.species do
                local species = pool.species[s]
               
                table.sort(species.genomes, function (a,b)
                        return (a.fitness > b.fitness)
                end)
               
                local remaining = math.ceil(#species.genomes/2)
                if cutToOne then
                        remaining = 1
                end
                while #species.genomes > remaining do
                        table.remove(species.genomes)
                end
        end
end
 
function breedChild(species)
        local child = {}
        if math.random() < CrossoverChance then
                g1 = species.genomes[math.random(1, #species.genomes)]
                g2 = species.genomes[math.random(1, #species.genomes)]
                child = crossover(g1, g2)
        else
                g = species.genomes[math.random(1, #species.genomes)]
                child = copyGenome(g)
        end
       
        mutate(child)
       
        return child
end
 
function removeStaleSpecies()
        local survived = {}
 
        for s = 1,#pool.species do
                local species = pool.species[s]
               
                table.sort(species.genomes, function (a,b)
                        return (a.fitness > b.fitness)
                end)
               
                if species.genomes[1].fitness > species.topFitness then
                        species.topFitness = species.genomes[1].fitness
                        species.staleness = 0
                else
                        species.staleness = species.staleness + 1
                end
                if species.staleness < StaleSpecies or species.topFitness >= pool.maxFitness then
                        table.insert(survived, species)
                end
        end
 
        pool.species = survived
end
 
function removeWeakSpecies()
        local survived = {}
 
        local sum = totalAverageFitness()
        for s = 1,#pool.species do
                local species = pool.species[s]
                breed = math.floor(species.averageFitness / sum * Population)
                if breed >= 1 then
                        table.insert(survived, species)
                end
        end
 
        pool.species = survived
end
 
 
function addToSpecies(child)
        local foundSpecies = false
        for s=1,#pool.species do
                local species = pool.species[s]
                if not foundSpecies and sameSpecies(child, species.genomes[1]) then
                        table.insert(species.genomes, child)
                        foundSpecies = true
                end
        end
       
        if not foundSpecies then
                local childSpecies = newSpecies()
                table.insert(childSpecies.genomes, child)
                table.insert(pool.species, childSpecies)
        end
end
 
function newGeneration()
        cullSpecies(false) -- Cull the bottom half of each species
        rankGlobally()
        removeStaleSpecies()
        rankGlobally()
        for s = 1,#pool.species do
                local species = pool.species[s]
                calculateAverageFitness(species)
        end
        removeWeakSpecies()
        local sum = totalAverageFitness()
        local children = {}
        for s = 1,#pool.species do
                local species = pool.species[s]
                breed = math.floor(species.averageFitness / sum * Population) - 1
                for i=1,breed do
                        table.insert(children, breedChild(species))
                end
        end
        cullSpecies(true) -- Cull all but the top member of each species
        while #children + #pool.species < Population do
                local species = pool.species[math.random(1, #pool.species)]
                table.insert(children, breedChild(species))
        end
        for c=1,#children do
                local child = children[c]
                addToSpecies(child)
        end
       
        pool.generation = pool.generation + 1
       
        writeFile("backup." .. pool.generation .. "." .. "level.state")
end
       
function initializePool()
        pool = newPool()
 
        for i=1,Population do
                basic = basicGenome()
                addToSpecies(basic)
        end
 
        initializeRun()
end
 
function clearJoypad()
        controller = {}
        for b = 1,#ButtonNames do
                controller["P1 " .. ButtonNames[b]] = false
        end
        joypad.set2(controller)
end
 
function initializeRun()
        savestate.load(Savestate_object); -- Amarat
        rightmost = 0
        pool.currentFrame = 0
        timeout = TimeoutConstant
        clearJoypad()
       
        local species = pool.species[pool.currentSpecies]
        local genome = species.genomes[pool.currentGenome]
        generateNetwork(genome)
        evaluateCurrent()
end
 
function evaluateCurrent()
        local species = pool.species[pool.currentSpecies]
        local genome = species.genomes[pool.currentGenome]
 
        inputs = getInputs()
        controller = evaluateNetwork(genome.network, inputs)
       
        if controller["P1 Left"] and controller["P1 Right"] then
                controller["P1 Left"] = false
                controller["P1 Right"] = false
        end
        if controller["P1 Up"] and controller["P1 Down"] then
                controller["P1 Up"] = false
                controller["P1 Down"] = false
        end
 
        joypad.set2(controller) -- Amarat
end
 
if pool == nil then
        initializePool()
end
 
 
function nextGenome()
        pool.currentGenome = pool.currentGenome + 1
        if pool.currentGenome > #pool.species[pool.currentSpecies].genomes then
                pool.currentGenome = 1
                pool.currentSpecies = pool.currentSpecies+1
                if pool.currentSpecies > #pool.species then
                        newGeneration()
                        pool.currentSpecies = 1
                end
        end
end
 
function fitnessAlreadyMeasured()
        local species = pool.species[pool.currentSpecies]
        local genome = species.genomes[pool.currentGenome]
       
        return genome.fitness ~= 0
end
 
function displayGenome(genome)
        local network = genome.network
        local cells = {}
        local i = 1
        local cell = {}
        for dy=-BoxRadius,BoxRadius do
                for dx=-BoxRadius,BoxRadius do
                        cell = {}
                        cell.x = 50+5*dx
                        cell.y = 70+5*dy
                        cell.value = network.neurons[i].value
                        cells[i] = cell
                        i = i + 1
                end
        end
        local biasCell = {}
        biasCell.x = 80
        biasCell.y = 110
        biasCell.value = network.neurons[Inputs].value
        cells[Inputs] = biasCell
       
        for o = 1,Outputs do
                cell = {}
                cell.x = 220
                cell.y = 30 + 8 * o
                cell.value = network.neurons[MaxNodes + o].value
                cells[MaxNodes+o] = cell
                local color
                if cell.value > 0 then
                        color = 0x0000FFFF
                else
                        color = 0x000000FF
                end
                gui.drawText(224, 26+8*o, ButtonNames[o], color, 0xffffffff)
        end
       
        for n,neuron in pairs(network.neurons) do
                cell = {}
                if n > Inputs and n <= MaxNodes then
                        cell.x = 140
                        cell.y = 40
                        cell.value = neuron.value
                        cells[n] = cell
                end
        end
       
        for n=1,4 do
                for _,gene in pairs(genome.genes) do
                        if gene.enabled then
                                local c1 = cells[gene.into]
                                local c2 = cells[gene.out]
                                if gene.into > Inputs and gene.into <= MaxNodes then
                                        c1.x = 0.75*c1.x + 0.25*c2.x
                                        if c1.x >= c2.x then
                                                c1.x = c1.x - 40
                                        end
                                        if c1.x < 90 then
                                                c1.x = 90
                                        end
                                       
                                        if c1.x > 220 then
                                                c1.x = 220
                                        end
                                        c1.y = 0.75*c1.y + 0.25*c2.y
                                       
                                end
                                if gene.out > Inputs and gene.out <= MaxNodes then
                                        c2.x = 0.25*c1.x + 0.75*c2.x
                                        if c1.x >= c2.x then
                                                c2.x = c2.x + 40
                                        end
                                        if c2.x < 90 then
                                                c2.x = 90
                                        end
                                        if c2.x > 220 then
                                                c2.x = 220
                                        end
                                        c2.y = 0.25*c1.y + 0.75*c2.y
                                end
                        end
                end
        end
       
		-- Mini screen box
        gui.drawBox(50-BoxRadius*5-3,70-BoxRadius*5-3,50+BoxRadius*5+2,70+BoxRadius*5+2,0x000000FF, 0x80808080)
		
        for n,cell in pairs(cells) do
                if n > Inputs or cell.value ~= 0 then
                        local color = math.floor((cell.value+1)/2*256)
                        if color > 255 then color = 255 end
                        if color < 0 then color = 0 end
                        local opacity = 0xFF
                        if cell.value == 0 then
                                opacity = 0x50
                        end
                        color = color*0x1000000 + color*0x10000 + color*0x100 + opacity
						-- Cell box
                        gui.drawBox(cell.x-2,cell.y-2,cell.x+2,cell.y+2,opacity,color) -- Amarat: colours not edited
                end
        end
        for _,gene in pairs(genome.genes) do
                if gene.enabled then
                        local c1 = cells[gene.into]
                        local c2 = cells[gene.out]
                        local opacity = 0xA0
                        if c1.value == 0 then
                                opacity = 0x20
                        end
                       
                        local color = 0x80-math.floor(math.abs(sigmoid(gene.weight))*0x80)  -- Amarat: colours not edited
                        if gene.weight > 0 then
                                color = opacity + 0x8000 + 0x10000*color
                        else
                                color = opacity + 0x800000 + 0x100*color
                        end
                        gui.drawLine(c1.x+1, c1.y, c2.x-3, c2.y, color)
                end
        end
       
		-- Yoshi red line
        gui.drawBox(49,71,51,78,0x00000000, 0xFF000080)
       
    -- Without forms :(
    if OPTIONS.showMutationRates then
        local pos = 100
        for mutation,rate in pairs(genome.mutationRates) do
            gui.drawText(100, pos, mutation .. ": " .. rate, 0x000000FF, 0xffffffff)
            pos = pos + 8
        end
    end
end
 
function writeFile(filename)
        local file = io.open(filename, "w")
        file:write(pool.generation .. "\n")
        file:write(pool.maxFitness .. "\n")
        file:write(#pool.species .. "\n")
        for n,species in pairs(pool.species) do
                file:write(species.topFitness .. "\n")
                file:write(species.staleness .. "\n")
                file:write(#species.genomes .. "\n")
                for m,genome in pairs(species.genomes) do
                        file:write(genome.fitness .. "\n")
                        file:write(genome.maxneuron .. "\n")
                        for mutation,rate in pairs(genome.mutationRates) do
                                file:write(mutation .. "\n")
                                file:write(rate .. "\n")
                        end
                        file:write("done\n")
                       
                        file:write(#genome.genes .. "\n")
                        for l,gene in pairs(genome.genes) do
                                file:write(gene.into .. " ")
                                file:write(gene.out .. " ")
                                file:write(gene.weight .. " ")
                                file:write(gene.innovation .. " ")
                                if(gene.enabled) then
                                        file:write("1\n")
                                else
                                        file:write("0\n")
                                end
                        end
                end
        end
        file:close()
end
 
function savePool()
        local filename = "level.state"
        writeFile(filename)
end
 
function loadFile(filename)
        local file = io.open(filename, "r")
        pool = newPool()
        pool.generation = file:read("*number")
        pool.maxFitness = file:read("*number")
        --forms.settext(maxFitnessLabel, "Max Fitness: " .. math.floor(pool.maxFitness)) -- forms are not possible on Snes9x
        local numSpecies = file:read("*number")
        for s=1,numSpecies do
                local species = newSpecies()
                table.insert(pool.species, species)
                species.topFitness = file:read("*number")
                species.staleness = file:read("*number")
                local numGenomes = file:read("*number")
                for g=1,numGenomes do
                        local genome = newGenome()
                        table.insert(species.genomes, genome)
                        genome.fitness = file:read("*number")
                        genome.maxneuron = file:read("*number")
                        local line = file:read("*line")
                        while line ~= "done" do
                                genome.mutationRates[line] = file:read("*number")
                                line = file:read("*line")
                        end
                        local numGenes = file:read("*number")
                        for n=1,numGenes do
                                local gene = newGene()
                                table.insert(genome.genes, gene)
                                local enabled
                                gene.into, gene.out, gene.weight, gene.innovation, enabled = file:read("*number", "*number", "*number", "*number", "*number")
                                if enabled == 0 then
                                        gene.enabled = false
                                else
                                        gene.enabled = true
                                end
                               
                        end
                end
        end
        file:close()
       
        while fitnessAlreadyMeasured() do
                nextGenome()
        end
        initializeRun()
        pool.currentFrame = pool.currentFrame + 1
end
 
function loadPool()
        local filename = "level.state"
        loadFile(filename)
end
 
function playTop()
        local maxfitness = 0
        local maxs, maxg
        for s,species in pairs(pool.species) do
                for g,genome in pairs(species.genomes) do
                        if genome.fitness > maxfitness then
                                maxfitness = genome.fitness
                                maxs = s
                                maxg = g
                        end
                end
        end
       
        pool.currentSpecies = maxs
        pool.currentGenome = maxg
        pool.maxFitness = maxfitness
        --forms.settext(maxFitnessLabel, "Max Fitness: " .. math.floor(pool.maxFitness))
        initializeRun()
        pool.currentFrame = pool.currentFrame + 1
        return
end
 
function onExit()
        forms.destroy(form)
end
 
writeFile("temp.pool")
 
--event.onexit(onExit) -- Amarat: forms are not possible on Snes9x
 
--[[
form = forms.newform(200, 260, "Fitness")
maxFitnessLabel = forms.label(form, "Max Fitness: " .. math.floor(pool.maxFitness), 5, 8)
OPTIONS.showNetwork = forms.checkbox(form, "Show Map", 5, 30)
OPTIONS.showMutationRates = forms.checkbox(form, "Show M-Rates", 5, 52)
restartButton = forms.button(form, "Restart", initializePool, 5, 77)
saveButton = forms.button(form, "Save", savePool, 5, 102)
loadButton = forms.button(form, "Load", loadPool, 80, 102)
saveLoadFile = forms.textbox(form, Savestate_object .. ".pool", 170, 25, nil, 5, 148)
saveLoadLabel = forms.label(form, "Save/Load:", 5, 129)
playTopButton = forms.button(form, "Play Top", playTop, 5, 170)
OPTIONS.hideBanner = forms.checkbox(form, "Hide Banner", 5, 190)
--]]
 
 
emu.registerbefore(function()
    local _input = {}
    for key, value in pairs(joypad.table) do
        _input[string.sub(key, 4)] = value
    end
    joypad.set(1, _input)
end)
 
 function draw_tiles()
	if not OPTIONS.draw_tile_map_type and not OPTIONS.draw_tile_map_grid and not OPTIONS.draw_tile_map_screen then return end
 
	local x_origin, y_origin = screen_coordinates(0, 0)
	
	Text_opacity = 1.0
    
    local width = 256
	local height = 128
	local block_x, block_y
	local x_pos, y_pos
	local x_screen, y_screen
	local screen_number, screen_id
	local block_id
	local kind_low, kind_high
	for screen_region_y = 0, 7 do
		
		for screen_region_x = 0, 15 do
			
			screen_number = screen_region_y*16 + screen_region_x
			screen_id = memory.readbyte(RAM.screen_number_to_id + screen_number)
			
			for block_y = 0, 15 do
				y_pos = y_origin + 256*screen_region_y + 16*block_y
				
				
				for block_x = 0, 15 do
					x_pos = x_origin + 256*screen_region_x + 16*block_x
					x_screen, y_screen = screen_coordinates(x_pos, y_pos)
			        x_screen = x_screen + camera_x
			        y_screen = y_screen + camera_y
					
					block_id = 256*screen_id + 16*block_y + block_x
					
					if x_pos >= -16 and x_pos <= 256 + 16 and y_pos >= -16 and y_pos <= 224 + 16 then -- to not print the whole level, it's too laggy
						
						--local num_x, num_y, kind_low, kind_high, address_low, address_high = get_map16_value(x_game, y_game)
			
						kind_low = memory.readbyte(RAM.Map16_data + 2*block_id) -- 
						kind_high = memory.readbyte(RAM.Map16_data + 2*block_id + 1) --
						
						-- Tile type
						if OPTIONS.draw_tile_map_type then
							gui.drawText(x_pos + 5, y_pos + 1, fmt("%02x\n%02x", kind_high, kind_low), "#ffffff70")
						end
						
						-- Grid
						if OPTIONS.draw_tile_map_grid then
							
							local block_is_solid = false
							for i = 1, #SOLID_BLOCKS do
								if kind_high == SOLID_BLOCKS[i] then
									block_is_solid = true
									break
								end
							end
							if block_is_solid then
								draw_rectangle(x_pos, y_pos, 15, 15, "#00008bff", 0)
							else
								draw_rectangle(x_pos, y_pos, 15, 15, "#ffffff70", 0)
							end
						end
					end
				end
			end
			
			-- Screen
			if OPTIONS.draw_tile_map_screen then
				Text_opacity = 0.8
			
				x_pos = x_origin + 256*screen_region_x
				y_pos = y_origin + 256*screen_region_y
				
				draw_rectangle(x_pos, y_pos, 50, 8, "#ff000080", "#ff000080")
				
				screen_id = string.upper(fmt("%02x", screen_id))
				gui.drawText(x_pos + 2, y_pos + 1, fmt("Screen ID:%s", screen_id), "#ffffff")
			
				draw_rectangle(x_pos, y_pos, 255, 255, "#ff000080", 0)
			end
		end
	end	
	
 end
 
function draw_fitness_lines(max_fitness_backup)
	-- Current Fitness
	local line_screen_x,_ = screen_coordinates(baby_mario_x, 0)
	gui.drawLine(line_screen_x, 8, line_screen_x, 224, "#FF0000AA") -- red
	gui.drawText(line_screen_x - 7*4 - 1, 9, "Fitness", "#FF0000AA")
	
	-- Max fitness
	line_screen_x,_ = screen_coordinates(max_fitness_backup, 0)
	gui.drawLine(line_screen_x, 8, line_screen_x, 224, "#0000FFAA") -- blue	
	gui.drawText(line_screen_x - 11*4 - 1, 17, "Max fitness", "#0000FFAA")
 end
 
 gui.register(function()

	draw_tiles() 
	
	if OPTIONS.display_fitness_lines then
		getPositions()
		draw_fitness_lines(max_fitness_backup)
	end
	
 end)


max_fitness_backup = 0 -- TEST
while true do
	
        local backgroundColor = 0xFFFFFFD0
    -- Without forms :(
    if not OPTIONS.hideBanner then
        --gui.drawBox(0, 0, 300, 26, backgroundColor, backgroundColor)
    end
   
        local species = pool.species[pool.currentSpecies]
        local genome = species.genomes[pool.currentGenome]
       
    -- Without forms :(
    if OPTIONS.showNetwork then
        displayGenome(genome)
    end
       
        if pool.currentFrame%5 == 0 then
                evaluateCurrent()
        end
 
        joypad.set2(controller)
 
        --getPositions()
        if baby_mario_x > rightmost then
                rightmost = baby_mario_x
                timeout = TimeoutConstant
        end
       
        timeout = timeout - 1
		
        local timeoutBonus = pool.currentFrame / 4
        if timeout + timeoutBonus <= 0 then
				
                local fitness = rightmost

				if fitness > max_fitness_backup then -- Backup max fitness to print blue line properly
                        max_fitness_backup = fitness
                end
				
				fitness = rightmost - pool.currentFrame/2
				
				-- Beat level fitness bonus
				local game_mode = memory.readword(0x7E0118)
				if game_mode == 0x0010 then
					fitness = fitness + 1000
				end
				
                if fitness == 0 then
                        fitness = -1
                end
				--if memory.readbyte(0x7001B3) == 0x80 then -- $80: Riding Yoshi -- TEST
					
				--end
				--[[
				local invincibility_timer = memory.readword(RAM.invincibility_timer) -- TEST
				if invincibility_timer == 0xA0 then  -- TEST
					pre_damage_fitness = fitness - 1
				end
				if memory.readbyte(0x7001B3) == 0x80 then -- $80: Riding Yoshi -- TEST
					genome.fitness = fitness
				else
					genome.fitness = pre_damage_fitness
				end]]
				genome.fitness = fitness
			   
			   
                if fitness > pool.maxFitness then
                        pool.maxFitness = fitness
                        --forms.settext(maxFitnessLabel, "Max Fitness: " .. math.floor(pool.maxFitness))
                        writeFile("backup." .. pool.generation .. "." .. "level.state")
                end
               
                print("Generation " .. pool.generation .. " species " .. pool.currentSpecies .. " genome " .. pool.currentGenome .. " fitness: " .. fitness)
                pool.currentSpecies = 1
                pool.currentGenome = 1
                while fitnessAlreadyMeasured() do
                        nextGenome()
                end
		
				local invincibility_timer = memory.readword(RAM.invincibility_timer)
				if invincibility_timer ~= 0 and invincibility_timer < 80 then -- took damage, reset in the half of the invincibility timer
					--initializeRun() -- TEST
					--nextGenome() -- TEST
				end
				
                initializeRun()
        end
 
        local measured = 0
        local total = 0
        for _,species in pairs(pool.species) do
                for _,genome in pairs(species.genomes) do
                        total = total + 1
                        if genome.fitness ~= 0 then
                                measured = measured + 1
                        end
                end
        end
	
		--[[if OPTIONS.display_fitness_lines then
			draw_fitness_lines(max_fitness_backup)
		end]]
		
    -- Without forms :(
    if not OPTIONS.hideBanner then
		local temp_str = "Gen " .. pool.generation .. " species " .. pool.currentSpecies .. " genome " .. pool.currentGenome .. " (" .. math.floor(measured/total*100) .. "%)"
		local temp_str_backup = temp_str
		local x_temp = 1
        gui.drawText(x_temp, 0, temp_str) --, 0x000000FF, 0xffffffff)
		
		temp_str = "Fitness: " .. math.floor(rightmost - (pool.currentFrame) / 2 - (timeout + timeoutBonus)*2/3)
		x_temp = x_temp + 4*string.len(temp_str_backup) + 10
        --gui.drawText(1, 12, "Fitness: " .. math.floor(rightmost - (pool.currentFrame) / 2 - (timeout + timeoutBonus)*2/3), 0x000000FF, 0xffffffff)
        gui.drawText(x_temp, 0, temp_str) --, 0x000000FF, 0xffffffff)
		temp_str_backup = temp_str
		
		temp_str = "Max: " .. math.floor(pool.maxFitness)
		x_temp = x_temp + 4*string.len(temp_str_backup) + 5
        gui.drawText(x_temp, 0, temp_str) --, 0x000000FF, 0xffffffff)
    end
   
        pool.currentFrame = pool.currentFrame + 1
 
        emu.frameadvance();
end