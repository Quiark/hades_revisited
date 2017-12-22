local world_path = minetest.get_worldpath()
local org_file = world_path .. "/beds_spawns"
local file = world_path .. "/beds_spawns"
local bkwd = false

-- check for PA's beds mod spawns
local cf = io.open(world_path .. "/beds_player_spawns", "r")
if cf ~= nil then
	io.close(cf)
	file = world_path .. "/beds_player_spawns"
	bkwd = true
end

function rebeds.read_spawns()
	local spawns = rebeds.spawn
	local input = io.open(file, "r")
	if input and not bkwd then
		repeat
			local x = input:read("*n")
			if x == nil then
            			break
            		end
			local y = input:read("*n")
			local z = input:read("*n")
			local name = input:read("*l")
			spawns[name:sub(2)] = {x = x, y = y, z = z}
		until input:read(0) == nil
		io.close(input)
	elseif input and bkwd then
		rebeds.spawn = minetest.deserialize(input:read("*all"))
		input:close()
		rebeds.save_spawns()
		os.rename(file, file .. ".backup")
		file = org_file
	else
		spawns = {}
	end
end

function rebeds.save_spawns()
	if not rebeds.spawn then
		return
	end
	writing = true
	local output = io.open(org_file, "w")
	for i, v in pairs(rebeds.spawn) do
		output:write(v.x.." "..v.y.." "..v.z.." "..i.."\n")
	end
	io.close(output)
	writing = false
end

function rebeds.set_spawn(player, pos)
	local name = player:get_player_name()
	rebeds.spawn[name] = pos
	minetest.chat_send_player(name, "Spawn position set!")
end
