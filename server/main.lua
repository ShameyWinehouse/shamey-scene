VORPutils = {}
TriggerEvent("getUtils", function(utils)
    VORPutils = utils
	print = VORPutils.Print:initialize(print)
end)
TriggerEvent("getCore",function(core)
	VorpCore = core
end)

local function Notify(text, _source)
	TriggerClientEvent("vorp:TipBottom", _source, text, 2000)
end

local function isPlayers(datas, _source)
	local User = VorpCore.getUser(_source)
	local Character = User.getUsedCharacter
	return tostring(datas[nr].id) == Character.identifier and tonumber(datas[nr].charid) == Character.charIdentifier
end

local function getPlayerInfo(_source)
	local User
    local Character
    local identi
    local charid

	User = VorpCore.getUser(_source)
	Character = User.getUsedCharacter
	identi = Character.identifier
	charid = Character.charIdentifier

    return {
        User = User,
        Character = Character,
        identi = identi,
        charid = charid
    }
end

function dump(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. dump(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
end


RegisterServerEvent("rainbow_scene:GetPlayerSceneCountMaximum", function()
	local _source = source

	-- Get the player's Discord Roles via Badger API
	local playersDiscordRoles = exports.Badger_Discord_API:GetDiscordRoles(_source)

	local highestRoleSceneCount = -1

	-- Find the role of theirs with the highest scene count maximum
	if not (playersDiscordRoles == false) then
		for i = 1, #playersDiscordRoles do
			for roleID, numberOfScenes in pairs(Config.MaximumScenesByDiscordRole) do
				if Config.Debug then print("playersDiscordRoles[i], roleID, numberOfScenes", playersDiscordRoles[i], roleID, numberOfScenes) end
				if exports.Badger_Discord_API:CheckEqual(playersDiscordRoles[i], roleID) then 
					if highestRoleSceneCount < tonumber(numberOfScenes) then 
						highestRoleSceneCount = numberOfScenes
					end 
				end
			end
		end
	end

	local PlayerSceneCountMaximum = Config.MaximumScenesPerPlayer
	if highestRoleSceneCount ~= -1 then
		PlayerSceneCountMaximum = highestRoleSceneCount
	end

	TriggerClientEvent("rainbow_scene:ReturnPlayerSceneCountMaximum", _source, PlayerSceneCountMaximum)

end)

RegisterServerEvent("rainbow_scene:GetPlayerSceneTimeMaximum", function()
	local _source = source

	-- Get the player's Discord Roles via Badger API
	local playersDiscordRoles = exports.Badger_Discord_API:GetDiscordRoles(_source)

	local highestRoleSceneTime = -1

	-- Find the role of theirs with the highest scene count maximum
	if not (playersDiscordRoles == false) then
		for i = 1, #playersDiscordRoles do
			for roleID, timeLimit in pairs(Config.MaximumExpirationInHoursByDiscordRole) do
				if Config.Debug then print("playersDiscordRoles[i], roleID, timeLimit", playersDiscordRoles[i], roleID, timeLimit) end
				if exports.Badger_Discord_API:CheckEqual(playersDiscordRoles[i], roleID) then 
					if highestRoleSceneTime < tonumber(timeLimit) then 
						highestRoleSceneTime = timeLimit
					end 
				end
			end
		end
	end

	local PlayerSceneTimeMaximum = Config.MaximumExpirationInHours
	if highestRoleSceneTime ~= -1 then
		PlayerSceneTimeMaximum = highestRoleSceneTime
	end

	TriggerClientEvent("rainbow_scene:ReturnPlayerSceneTimeMaximum", _source, PlayerSceneTimeMaximum)

end)



-- Every 30 minutes, check for expired scenes to delete
CreateThread(function()
	while true do
        local sleep = 30 * 60 * 1000 -- 30 mins
		
		-- Delete expired scenes
		MySQL.Async.execute('DELETE FROM scenes WHERE (TIMESTAMPADD(MINUTE, `timelength`, `createddate`)) <= NOW();', 
			{}, function(rowsChanged)
				print('Deleting all expired Scenes', rowsChanged .. ' rows were deleted from the scenes table.')
		end)
		
		Wait(sleep)
	end
end)


AddEventHandler('onResourceStart', function(resource)
    if Config.RestartDelete == true then
		MySQL.Async.execute('DELETE FROM scenes', {}, function(rowsChanged)
			print('Deleting all Scenes', rowsChanged .. ' rows were deleted from the scenes table.')
		end)
    end


	local raw_store = LoadResourceFile(GetCurrentResourceName(), "./store.json")
	if Config.Debug then print("85 - onResourceStart - raw_store: "..dump(raw_store)) end
	local data_store = json.decode(raw_store)

	if data_store.created_table == false then
		-- Setup server table
		MySQL.query([[
			CREATE TABLE IF NOT EXISTS `scenes` (
				`autoid` INT(20) NOT NULL AUTO_INCREMENT,
				`id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
				`charid` INT(30) NOT NULL DEFAULT '0',
				`text` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
				`desc` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
				`coords` JSON,
				`prop` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL,
				`propheading` JSON,
				`font` INT(30) NOT NULL DEFAULT '0',
				`color` INT(30) NOT NULL DEFAULT '0',
				`bg` INT(30) NOT NULL DEFAULT '0',
				`scale` DOUBLE NOT NULL DEFAULT '0',
				`createddate` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
				`timelength` INT NOT NULL DEFAULT '180',
				PRIMARY KEY (`autoid`),
				CONSTRAINT `FK_bccscenes_users` FOREIGN KEY (`id`) REFERENCES `users` (`identifier`) ON DELETE CASCADE ON UPDATE CASCADE,
				INDEX `autoid` (`autoid`),
				INDEX `id` (`id`),
				INDEX `charid` (`charid`)
			) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

		]])

		print("Created Scenes Table")
		data_store.created_table = true
		SaveResourceFile(GetCurrentResourceName(), "./store.json", json.encode(data_store))
	end

end)

local function refreshClientScenes()
    local result = MySQL.query.await('SELECT * FROM scenes')
    if not result then
        print("ERROR: Failed to update pages!", dump(result))
    else
        TriggerClientEvent("rainbow_scene:sendscenes", -1, result)
    end
end

RegisterServerEvent("rainbow_scene:addTextScene", function(text, desc, coords, expiration)
	local _source = source
	print("133 - rainbow_scene:addTextScene - text,coords: "..dump(text)..", "..dump(coords))
    
	local timeLength = getTimeLengthInMinutesFromHours(tonumber(expiration))
	
    local _text = sanitizeSceneText(tostring(text))
	local _desc = sanitizeSceneDesc(tostring(desc))

    local player = getPlayerInfo(_source)
    local identi = player.identi
    local charid = player.charid
		
	local result = MySQL.insert.await('INSERT INTO scenes (`id`, `charid`, `scene_type`, `text`, `desc`, `coords`, `font`, `color`, `bg`, `scale`, `timelength`) VALUES (@id, @charid, @sceneType, @text, @desc, @coords, @font, @color, @bg, @scale, @timelength)', {["@id"] = identi, ["@charid"] = charid, ["@sceneType"] = 'text', ["@text"] = _text, ["@desc"] = _desc, ["@coords"] = json.encode({x=coords.x, y=coords.y, z=coords.z}), ["@font"] = Config.Defaults.Font, ["@color"] = Config.Defaults.Color, ["@bg"] =  Config.Defaults.BackgroundColor, ["@scale"] = Config.StartingScale, ["@timelength"] = timeLength })
	if not result then
		print("ERROR: Failed to update pages!", dump(result))
	else
		refreshClientScenes()
	end

end)

function sanitizeSceneText(_text)
	if string.len(_text) > 50 then
		_text = string.sub(_text,1,50)
	end
	return _text
end

function sanitizeSceneDesc(_text)
	if string.len(_text) > 500 then
		_text = string.sub(_text,1,500)
	end
	return _text
end

RegisterServerEvent("rainbow_scene:addObjectScene", function(prop, desc, coords, expiration)
	local _source = source
	print("154 - rainbow_scene:addObjectScene - prop,coords: "..dump(prop)..", "..dump(coords))
    
	-- User picks expiration time in hours, but in database, it's stored as minutes
	local timeLength = getTimeLengthInMinutesFromHours(tonumber(expiration))
	
    local _prop = tostring(prop)
	local _desc = sanitizeSceneDesc(tostring(desc))

    local player = getPlayerInfo(_source)
    local identi = player.identi
    local charid = player.charid
		
	local result = MySQL.insert.await('INSERT INTO scenes (`id`, `charid`, `scene_type`, `desc`, `coords`, `prop`, `propheading`, `font`, `color`, `bg`, `scale`, `timelength`) VALUES (@id, @charid, @sceneType, @desc, @coords, @prop, @propheading, @font, @color, @bg, @scale, @timelength)', {["@id"] = identi, ["@charid"] = charid, ["@sceneType"] = 'prop', ["@desc"] = _desc, ["@coords"] = json.encode({x=coords.x, y=coords.y, z=coords.z}), ["@prop"] = _prop, ["@propheading"] = '180.0', ["@font"] = Config.Defaults.Font, ["@color"] = Config.Defaults.Color, ["@bg"] =  Config.Defaults.BackgroundColor, ["@scale"] = Config.StartingScale, ["@timelength"] = timeLength })
	if not result then
		print("ERROR: Failed to update pages!", dump(result))
	else
		refreshClientScenes()
	end

end)


function getTimeLengthInMinutesFromHours(expiration)
	local _expiration = expiration
	return _expiration * 60
end

RegisterServerEvent("rainbow_scene:getscenes", function(text)
	local _source = source

	refreshClientScenes()

end)

RegisterServerEvent("rainbow_scene:delete", function(nr)
	local _source = source

	local player = getPlayerInfo(_source)
	local identi = player.identi
	local charid = player.charid
	
	if Config.AllowAnyoneToDelete then
		local result = MySQL.query.await('DELETE FROM scenes WHERE autoid = @autoid', {["@autoid"] = nr})
		if not result then
			print("ERROR: Failed to update pages!", dump(result))
		else
			TriggerClientEvent("rainbow_scene:removescene", -1, nr)
			refreshClientScenes()
		end
	else
		local result = MySQL.query.await('DELETE FROM scenes WHERE id = @id AND charid = @charid AND autoid = @autoid', {["@id"] = identi, ["@charid"] = charid, ["@autoid"] = nr})
		if not result then
			print("ERROR: Failed to update pages!", dump(result))
		else
			TriggerClientEvent("rainbow_scene:removescene", -1, nr)
			refreshClientScenes()
		end
	end

end)

RegisterServerEvent("rainbow_scene:getCharData", function()
    local id
    local charid
    local job
    local group
    local _source = source

	local User = VorpCore.getUser(_source)
	local Character = User.getUsedCharacter

	id = Character.identifier
	charid = Character.charIdentifier
	job = Character.job
	group = Character.group

    TriggerClientEvent("rainbow_scene:retrieveCharData", _source, id, charid, job, group)
end)

RegisterServerEvent("rainbow_scene:edit", function(nr)
	if Config.Debug then print("230 - rainbow_scene:edit - nr: "..dump(nr)) end
	local _source = source

	local edata = LoadResourceFile(GetCurrentResourceName(), "./scenes.json")
	local datas = json.decode(edata)

	if isPlayers(datas, _source) then
		TriggerClientEvent("rainbow_scene:client_edit", _source, nr)
		return
	else
		Notify(Config.Texts.NoAuth, _source)
	end

end)

RegisterServerEvent("rainbow_scene:color", function(nr, color)
	local _source = source

	local player = getPlayerInfo(_source)
	local identi = player.identi
	local charid = player.charid

	local result = MySQL.update.await('UPDATE scenes SET `color` = @color WHERE id = @id AND charid = @charid AND autoid = @autoid', {["@id"] = identi, ["@charid"] = charid, ["@autoid"] = nr, ["@color"] = color})
	if not result then
		print("ERROR: Failed to update pages!", dump(result))
	else
		refreshClientScenes()
	end

end)

RegisterServerEvent("rainbow_scene:background", function(nr, color)
	local _source = source

	local player = getPlayerInfo(_source)
	local identi = player.identi
	local charid = player.charid

	local result = MySQL.update.await('UPDATE scenes SET `bg` = @bg WHERE id = @id AND charid = @charid AND autoid = @autoid', {["@id"] = identi, ["@charid"] = charid, ["@autoid"] = nr, ["@bg"] = color})
	if not result then
		print("ERROR: Failed to update pages!", dump(result))
	else
		refreshClientScenes()
	end

end)

RegisterServerEvent("rainbow_scene:font", function(nr, font)
	local _source = source

	local player = getPlayerInfo(_source)
	local identi = player.identi
	local charid = player.charid

	local result = MySQL.update.await('UPDATE scenes SET `font` = @font WHERE id = @id AND charid = @charid AND autoid = @autoid', {["@id"] = identi, ["@charid"] = charid, ["@autoid"] = nr, ["@font"] = font})
	if not result then
		print("ERROR: Failed to update pages!", dump(result))
	else
		refreshClientScenes()
	end

end)

RegisterServerEvent("rainbow_scene:edited", function(text,nr)
	if Config.Debug then print("353 - rainbow_scene:edited - text,nr: "..dump(text)..", "..dump(nr)) end
	local _source = source
    local _text = tostring(text)

	local player = getPlayerInfo(_source)
	local identi = player.identi
	local charid = player.charid

	local result = MySQL.update.await('UPDATE scenes SET `text` = @text WHERE id = @id AND charid = @charid AND autoid = @autoid', {["@id"] = identi, ["@charid"] = charid, ["@autoid"] = nr, ["@text"] = _text})
	if not result then
		print("ERROR: Failed to update pages!", dump(result))
	else
		refreshClientScenes()
	end

end)

RegisterServerEvent("rainbow_scene:editeddesc-typetext", function(desc,nr)
	if Config.Debug then print("378 - rainbow_scene:editeddesc - text,nr: "..dump(text)..", "..dump(nr)) end
	local _source = source
    local _desc = sanitizeSceneDesc(tostring(desc))

	local player = getPlayerInfo(_source)
	local identi = player.identi
	local charid = player.charid

	local result = MySQL.update.await('UPDATE scenes SET `desc` = @desc WHERE id = @id AND charid = @charid AND autoid = @autoid', {["@id"] = identi, ["@charid"] = charid, ["@autoid"] = nr, ["@desc"] = _desc})
	if not result then
		print("ERROR: Failed to update pages!", dump(result))
	else
		refreshClientScenes()
	end

end)

RegisterServerEvent("rainbow_scene:editeddesc-typeimage", function(_imgUrl, _imgAlt, nr)
	if Config.Debug then print("378 - rainbow_scene:editeddesc - _imgUrl,_imgAlt,nr: "..dump(_imgUrl), dump(_imgAlt)..", "..dump(nr)) end
	local _source = source
    local _imgTable = {
		imgUrl = _imgUrl,
		imgAlt = _imgAlt,
	}
	local _json = json.encode(_imgTable)

	local player = getPlayerInfo(_source)
	local identi = player.identi
	local charid = player.charid

	local result = MySQL.update.await('UPDATE scenes SET `desc` = @json WHERE id = @id AND charid = @charid AND autoid = @autoid', {["@id"] = identi, ["@charid"] = charid, ["@autoid"] = nr, ["@json"] = _json})
	if not result then
		print("ERROR: Failed to update pages!", dump(result))
	else
		refreshClientScenes()
	end

end)

RegisterServerEvent("rainbow_scene:scale", function(nr, scale)
    local _source = source

	local player = getPlayerInfo(_source)
	local identi = player.identi
	local charid = player.charid

	local result = MySQL.update.await('UPDATE scenes SET `scale` = @scale WHERE id = @id AND charid = @charid AND autoid = @autoid', {["@id"] = identi, ["@charid"] = charid, ["@autoid"] = nr, ["@scale"] = scale})
	if not result then
		print("ERROR: Failed to update pages!", dump(result))
	else
		refreshClientScenes()
	end

end)

RegisterServerEvent("rainbow_scene:moveup", function(nr, coords, distance)
	local _source = source

	local player = getPlayerInfo(_source)
	local identi = player.identi
	local charid = player.charid

	coords = json.decode(coords)
	coords.z = coords.z + distance
	local result = MySQL.update.await('UPDATE scenes SET `coords` = @coords WHERE id = @id AND charid = @charid AND autoid = @autoid', {["@id"] = identi, ["@charid"] = charid, ["@autoid"] = nr, ["@coords"] = json.encode(coords)})
	if not result then
		print("ERROR: Failed to update pages!", dump(result))
	else
		refreshClientScenes()
	end

end)

RegisterServerEvent("rainbow_scene:movedown", function(nr, coords, distance)
	local _source = source

	local player = getPlayerInfo(_source)
	local identi = player.identi
	local charid = player.charid
	coords = json.decode(coords)
	coords.z = coords.z - distance
	local result = MySQL.update.await('UPDATE scenes SET `coords` = @coords WHERE id = @id AND charid = @charid AND autoid = @autoid', {["@id"] = identi, ["@charid"] = charid, ["@autoid"] = nr, ["@coords"] = json.encode(coords)})
	if not result then
		print("ERROR: Failed to update pages!", dump(result))
	else
		refreshClientScenes()
	end

end)

RegisterServerEvent("rainbow_scene:moveleft", function(nr, coords, distance)
	local _source = source

	local player = getPlayerInfo(_source)
	local identi = player.identi
	local charid = player.charid
	coords = json.decode(coords)
	coords.x = coords.x + distance
	local result = MySQL.update.await('UPDATE scenes SET `coords` = @coords WHERE id = @id AND charid = @charid AND autoid = @autoid', {["@id"] = identi, ["@charid"] = charid, ["@autoid"] = nr, ["@coords"] = json.encode(coords)})
	if not result then
		print("ERROR: Failed to update pages!", dump(result))
	else
		refreshClientScenes()
	end

end)

RegisterServerEvent("rainbow_scene:moveright", function(nr, coords, distance)
	local _source = source

	local player = getPlayerInfo(_source)
	local identi = player.identi
	local charid = player.charid

	coords = json.decode(coords)
	coords.x = coords.x - distance
	local result = MySQL.update.await('UPDATE scenes SET `coords` = @coords WHERE id = @id AND charid = @charid AND autoid = @autoid', {["@id"] = identi, ["@charid"] = charid, ["@autoid"] = nr, ["@coords"] = json.encode(coords)})
	if not result then
		print("ERROR: Failed to update pages!", dump(result))
	else
		refreshClientScenes()
	end

end)

RegisterServerEvent("rainbow_scene:moveforward", function(nr, coords, distance)
	local _source = source

	local player = getPlayerInfo(_source)
	local identi = player.identi
	local charid = player.charid

	coords = json.decode(coords)
	coords.y = coords.y - distance
	local result = MySQL.update.await('UPDATE scenes SET `coords` = @coords WHERE id = @id AND charid = @charid AND autoid = @autoid', {["@id"] = identi, ["@charid"] = charid, ["@autoid"] = nr, ["@coords"] = json.encode(coords)})
	if not result then
		print("ERROR: Failed to update pages!", dump(result))
	else
		refreshClientScenes()
	end

end)

RegisterServerEvent("rainbow_scene:movebackward", function(nr, coords, distance)
	local _source = source

	local player = getPlayerInfo(_source)
	local identi = player.identi
	local charid = player.charid
	
	coords = json.decode(coords)
	coords.y = coords.y + distance
	local result = MySQL.update.await('UPDATE scenes SET `coords` = @coords WHERE id = @id AND charid = @charid AND autoid = @autoid', {["@id"] = identi, ["@charid"] = charid, ["@autoid"] = nr, ["@coords"] = json.encode(coords)})
	if not result then
		print("ERROR: Failed to update pages!", dump(result))
	else
		refreshClientScenes()
	end

end)

local yawMin = 0.0
local yawMax = 359.0

RegisterServerEvent("rainbow_scene:rotateleft", function(nr, propheading, distance)
	local _source = source

	local player = getPlayerInfo(_source)
	local identi = player.identi
	local charid = player.charid
	
	if propheading then
		propheading = propheading - 5.0
		if propheading <= yawMin then
			propheading = yawMin
		end
	else
		propheading = 180.0
	end
	
	-- Force float
	propheading = propheading + 0.0
	
	local result = MySQL.update.await('UPDATE scenes SET `propheading` = @propheading WHERE id = @id AND charid = @charid AND autoid = @autoid', {["@id"] = identi, ["@charid"] = charid, ["@autoid"] = nr, ["@propheading"] = tostring(propheading)})
	if not result then
		print("ERROR: Failed to update pages!", dump(result))
	else
		refreshClientScenes()
	end

end)

RegisterServerEvent("rainbow_scene:rotateright", function(nr, propheading, distance)
	local _source = source

	local player = getPlayerInfo(_source)
	local identi = player.identi
	local charid = player.charid
	
	if propheading then
		propheading = propheading + 5.0
		if propheading >= yawMax then
			propheading = yawMax
		end
	else
		propheading = 180.0
	end
	
	-- Force float
	propheading = propheading + 0.0
	
	local result = MySQL.update.await('UPDATE scenes SET `propheading` = @propheading WHERE id = @id AND charid = @charid AND autoid = @autoid', {["@id"] = identi, ["@charid"] = charid, ["@autoid"] = nr, ["@propheading"] = tostring(propheading)})
	if not result then
		print("ERROR: Failed to update pages!", dump(result))
	else
		refreshClientScenes()
	end

end)

RegisterServerEvent("rainbow_scene:GetSceneCount", function(nr, propheading, distance)
	local _source = source

	local player = getPlayerInfo(_source)
	local identi = player.identi
	local charid = player.charid
	
	local sceneCount = 0
	local result = MySQL.query.await('SELECT autoid FROM scenes WHERE id = @id', {["@id"] = identi,})
    if result then
		sceneCount = #result
	end
	
	TriggerClientEvent("rainbow_scene:UpdateSceneCount", _source, sceneCount)

end)