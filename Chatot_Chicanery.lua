-- modified version of /u/hourglasseye's script edited by Unknown_Warrior, original: https://www.reddit.com/r/pokemonrng/comments/1xnqys/5th_simple_lua_script_for_pid_advancement/?ref=share&ref_source=link
-- INSTRUCTIONS: Edit the "maxAdvances" in this lua, pick even numbers if you don't want issues restarting it. 
-- INSTRUCTIONS Ingame: place two Chatot next to each other with customised Chatter, start at the bottom one and let this run.

mdword=memory.readdwordunsigned

local maxAdvances = 50 -- how many advances you want the script to make

-- Detect Game Version
if mdword(0x02FFFE0C) == 0x45555043 then -- Game: Platinum
off = 0			-- Initial/Current Seed
elseif mdword(0x02FFFE0C) == 0x45414441 then -- game: Diamond
off = 0x5234	-- Initial/Current Seed
elseif mdword(0x02FFFE0C) == 0x45415041 then -- game: Pearl
off = 0x5234	-- Initial/Current Seed
else -- game: HGSS
off = 0x11A94	-- Initial/Current Seed
end

local pidAdvances = 0
local flip = 0
local prevflip = 0
local currseed
local errSide = 0

local function main()
	
	if errSide > 30 then -- Flips automatically if started with top, not recommended, restart if this happens and start at bottom
		flip = bit.bxor(flip,1)
		errSide = 0
	else
		if mdword(0x021BFB14+off) ~= currseed then
			flip = bit.bxor(flip,1)
			currseed = mdword(0x021BFB14+off)
		end
	end
		

	if pidAdvances <= maxAdvances then

			if flip == 1 then
				joypad.set(1, {up=1})
				errSide = errSide + 1
			elseif flip == 0 then
				joypad.set(1, {down=1})
				errSide = errSide + 1
			end
			
			if flip ~= prevflip then
				pidAdvances = pidAdvances + 1
				prevflip = flip
				errSide = 0
			end

		gui.text(1, -170, "Advances: " .. pidAdvances-1, "cyan")
	else
		gui.text(1, -170, "Advances: " .. pidAdvances-1 .. ", DONE!","cyan")
	end
end

gui.register(main)
