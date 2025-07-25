VORPutils = {}
TriggerEvent("getUtils", function(utils)
    VORPutils = utils
	print = VORPutils.Print:initialize(print)
end)

function Notify(text)
	TriggerEvent("vorp:TipBottom", text, 4000)
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


local EditGroup = GetRandomIntInRange(0, 0xffffff)
local PlacePrompt
local EditAppearancePrompt
local EditDescriptionPrompt
local SceneGroup = GetRandomIntInRange(0, 0xffffff)
local Scenes = {}
local Identifier, CharIdentifier, Job, Group
local ActiveScene
local authorized = false
addMode = false
local placementSphereReady = false
local scene_target
local propObjects = {}
local playerCoords
local playerSceneCount = 0

PlayerSceneCountMaximum = Config.MaximumScenesPerPlayer
PlayerSceneTimeMaximum = Config.MaximumExpirationInHours


CreateThread(function()
    Wait(10 * 1000)
    TriggerServerEvent("rainbow_scene:GetPlayerSceneCountMaximum")
    TriggerServerEvent("rainbow_scene:GetPlayerSceneTimeMaximum")
end)


ResetActiveScene = function()
    ActiveScene = nil
end

---@param scene {id:any, charid:any}
---@return boolean
IsOwnerOfScene = function(scene)
	-- print("46 - IsOwnerOfScene - scene: "..dump(scene))
	-- print("47 - Identifier, CharIdentifier: "..dump(Identifier)..", "..dump(CharIdentifier))
    return tostring(scene.id) == tostring(Identifier) and tonumber(scene.charid) == tonumber(CharIdentifier)
end

SceneTarget = function()
    local Cam = GetGameplayCamCoord()
    local handle = Citizen.InvokeNative(0x377906D8A31E5586, Cam, GetCoordsFromCam(10.0, Cam), -1, PlayerPedId(), 4) -- StartExpensiveSynchronousShapeTestLosProbe
    local _, _, Coords, _, _ = GetShapeTestResult(handle)
    return Coords
end

GetCoordsFromCam = function(distance, coords)
    local rotation = GetGameplayCamRot()
    local adjustedRotation = vector3((math.pi / 180) * rotation.x, (math.pi / 180) * rotation.y, (math.pi / 180) * rotation.z)
    local direction = vector3(-math.sin(adjustedRotation[3]) * math.abs(math.cos(adjustedRotation[1])), math.cos(adjustedRotation[3]) * math.abs(math.cos(adjustedRotation[1])), math.sin(adjustedRotation[1]))
    return vector3(coords[1] + direction[1] * distance, coords[2] + direction[2] * distance, coords[3] + direction[3] * distance)
end

function DrawText3D(x, y, z, text, type, font, bg, scale)
    local onScreen, _x, _y = GetScreenCoordFromWorldCoord(x, y, z)
    local str = CreateVarString(10, "LITERAL_STRING", text)
    if onScreen then
        SetTextColor(Config.Colors[type][1], Config.Colors[type][2], Config.Colors[type][3], 215)
        SetTextScale(scale, scale)
        SetTextFontForCurrentCommand(font) -- 0,1,5,6, 9, 11, 12, 15, 18, 19, 20, 22, 24, 25, 28, 29
        SetTextCentre(1)
        DisplayText(str, _x, _y - 0.0)

        if bg > 0 then
            local factor = (string.len(text)) / 225

            DrawSprite("feeds", "hud_menu_4a", _x, _y + scale / 25, (scale + factor) - 0.28, scale / 10, 0.1,
                Config.Colors[bg][1], Config.Colors[bg][2], Config.Colors[bg][3], 190, 0)
        end
    end
end

function DrawText(text, x, y, fScale, fSize, rC, gC, bC, aC, tCentered, shadow)
	local str = CreateVarString(10, "LITERAL_STRING", text)
	SetTextScale(fScale, fSize)
	SetTextColor(rC, gC, bC, aC)
	SetTextCentre(tCentered)
	if shadow then SetTextDropshadow(1, 0, 0, 255); end
	Citizen.InvokeNative(0xADA9255D, 1)
	DisplayText(str, x, y)
end

function whenKeyJustPressed(key)
    if Citizen.InvokeNative(0x580417101DDB492F, 0, key) then
        return true
    else
        return false
    end
end

function PlayerData()
    CreateThread(function ()
        while true do
            TriggerServerEvent("rainbow_scene:getCharData")
            Wait(10 * 60 * 1000)
        end
    end)
end

function SceneDot()
    CreateThread(function()
        while true do
            local x, y, z
            if addMode then
                scene_target = SceneTarget()
                x, y, z = table.unpack(scene_target)
                Citizen.InvokeNative(0x2A32FAA57B937173, 0x50638AB9, x, y, z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.15, 0.15, 0.15, 93, 17, 100, 255, false, false, 2, false, false)
                
                placementSphereReady = true
                if Config.HotKeysEnabled then
                    local label = CreateVarString(10, 'LITERAL_STRING', '')
                    PromptSetActiveGroupThisFrame(EditGroup, label)
                end
            else
                placementSphereReady = false
                break
            end
            Wait(5)
        end
    end)
end

if Config.HotKeysEnabled then
    CreateThread(function()
        while true do
			local sleep = 500
			
            -- if whenKeyJustPressed(Config.HotKeys.Scene) then
                -- if addMode then
                    -- addMode = false
                -- elseif not addMode then
                    -- addMode = true
                    -- SceneDot()
                -- end
            -- end
			
			if addMode then
				sleep = 4
				if whenKeyJustPressed(Config.HotKeys.Place) then
					TriggerEvent("rainbow_scene:start")
				end
			end
			
			Wait(sleep)
        end
    end)
end

CreateThread(function()
	while true do
		Citizen.Wait(500)
		playerCoords = GetEntityCoords(PlayerPedId())
	end
end)

CreateThread(function()
	    local place = Config.Prompts.Place.title
    PlacePrompt = PromptRegisterBegin()
    PromptSetControlAction(PlacePrompt, Config.HotKeys.Place)
    place = CreateVarString(10, 'LITERAL_STRING', place)
    PromptSetText(PlacePrompt, place)
    PromptSetEnabled(PlacePrompt, 1)
    PromptSetVisible(PlacePrompt, 1)
    PromptSetStandardMode(PlacePrompt, 1)
    PromptSetGroup(PlacePrompt)
    PromptSetGroup(PlacePrompt, EditGroup)

    Citizen.InvokeNative(0xC5F428EE08FA7F2C, PlacePrompt, true)
    PromptRegisterEnd(PlacePrompt)


    local strAppearance = Config.Prompts.EditAppearance[1]
    EditAppearancePrompt = PromptRegisterBegin()
    PromptSetControlAction(EditAppearancePrompt, Config.Prompts.EditAppearance[2])
    strAppearance = CreateVarString(10, 'LITERAL_STRING', strAppearance)
    PromptSetText(EditAppearancePrompt, strAppearance)
    PromptSetEnabled(EditAppearancePrompt, 1)
    PromptSetVisible(EditAppearancePrompt, 1)
    PromptSetStandardMode(EditAppearancePrompt, 1)
    PromptSetGroup(EditAppearancePrompt, SceneGroup)
    Citizen.InvokeNative(0xC5F428EE08FA7F2C, EditAppearancePrompt, true)
    PromptRegisterEnd(EditAppearancePrompt)
	
	local strDescription = Config.Prompts.EditDescription[1]
    EditDescriptionPrompt = PromptRegisterBegin()
    PromptSetControlAction(EditDescriptionPrompt, Config.Prompts.EditDescription[2])
    strDescription = CreateVarString(10, 'LITERAL_STRING', strDescription)
    PromptSetText(EditDescriptionPrompt, strDescription)
    PromptSetEnabled(EditDescriptionPrompt, 1)
    PromptSetVisible(EditDescriptionPrompt, 1)
    PromptSetStandardMode(EditDescriptionPrompt, 1)
    PromptSetGroup(EditDescriptionPrompt, SceneGroup)
    Citizen.InvokeNative(0xC5F428EE08FA7F2C, EditDescriptionPrompt, true)
    PromptRegisterEnd(EditDescriptionPrompt)
	
	TriggerServerEvent("rainbow_scene:getscenes")
end)

CreateThread(function()
	Wait(5000)
    while true do
        local sleep = 500
        local x, y, z
        if addMode == true and placementSphereReady == true then
            x, y, z = table.unpack(scene_target)
        end
        if playerCoords and Scenes[1] ~= nil then
            local closest = {
                dist = 99999999
            }
            for i, _ in pairs(Scenes) do
                local cc = playerCoords
                local edist = Config.EditDistance
                if addMode == true and placementSphereReady == true then
                    cc = {
                        x = x,
                        y = y,
                        z = z
                    }
                    edist = 0.1
                end
                local sc = json.decode(Scenes[i].coords)

				-- If player is in viewable range of the scene
                local dist = #(vector3(cc.x, cc.y, cc.z) - vector3(sc.x, sc.y, sc.z))
                if dist < Config.ViewDistance then
                    sleep = 4
                    if Config.AllowAnyoneToEdit then
                        if (dist < edist) and dist <= closest.dist then
                            closest = {
                                dist = dist
                            }

                            local label = CreateVarString(10, 'LITERAL_STRING', Scenes[i].text)
                            PromptSetActiveGroupThisFrame(SceneGroup, label)
                            if Citizen.InvokeNative(0xC92AC953F0A982AE, EditAppearancePrompt) then
                                local id = Scenes[i].autoid
                                UI:Appearance(Scenes[i], id)
                                ActiveScene = Scenes[i]
                            end
                        end
                    elseif Config.JobLock then
                        for _,v in pairs(Config.JobLock) do
                            if Job == v then
                                authorized = true
                                break
                            end
                        end
                        if authorized then
                            if (dist < edist) and dist <= closest.dist then
                                closest = {
                                    dist = dist
                                }

                                local label = CreateVarString(10, 'LITERAL_STRING', Scenes[i].text)
                                PromptSetActiveGroupThisFrame(SceneGroup, label)
                                if Citizen.InvokeNative(0xC92AC953F0A982AE, EditAppearancePrompt) then
                                    local id = Scenes[i].autoid
                                    UI:Appearance(Scenes[i], id)
                                    ActiveScene = Scenes[i]
                                end
                            end
                        end
                    elseif Config.AdminOnly then
                        for _,v in pairs(Config.AdminLock) do
                            if Group == v then
                                authorized = true
                                break
                            end
                        end
                        if authorized then
                            if (dist < edist) and dist <= closest.dist then
                                closest = {
                                    dist = dist
                                }
                                local label = CreateVarString(10, 'LITERAL_STRING', Scenes[i].text)
                                PromptSetActiveGroupThisFrame(SceneGroup, label)
                                if Citizen.InvokeNative(0xC92AC953F0A982AE, EditAppearancePrompt) then
                                    local id = Scenes[i].autoid
                                    UI:Appearance(Scenes[i], id)
                                    ActiveScene = Scenes[i]
                                end
                            end
                        end
                    else
						-- OWNER OF SCENE
						-- print("278 - else")
						-- print("278 - Scenes[i]: "..dump(Scenes[i]))
                        if IsOwnerOfScene(Scenes[i]) then
							-- print("281 - dist, closest.dist: "..dump(dist)..", "..dump(edist))
                            if (dist < edist) and dist <= closest.dist then
                                closest = {
                                    dist = dist
                                }

								if not isAnyUiOpen() then
									local label = CreateVarString(10, 'LITERAL_STRING', Scenes[i].text)
									PromptSetActiveGroupThisFrame(SceneGroup, label)
									if Citizen.InvokeNative(0xC92AC953F0A982AE, EditAppearancePrompt) then -- UiPromptHasStandardModeCompleted
										local id = Scenes[i].autoid
										UI:Appearance(Scenes[i], id)
										ActiveScene = Scenes[i]
									end
									if Citizen.InvokeNative(0xC92AC953F0A982AE, EditDescriptionPrompt) then -- UiPromptHasStandardModeCompleted
										local id = Scenes[i].autoid
										UI:Description(Scenes[i], id)
										ActiveScene = Scenes[i]
									end
								end
                            end
                        end
                    end
					
                    local outtext = Scenes[i].text
                    if Config.TextAsterisk then
                         outtext = "*" .. Scenes[i].text .. "*"
                    end
					
					drawFrame(Scenes[i], sc, outtext, dist, closest)
                end
            end
        end
        Wait(sleep)
    end
end)

function drawFrame(scene, sc, outtext, dist, closest)
	
	-- If it's a text scene, draw the text for this frame
	if scene.scene_type == 'text' then
		DrawText3D(sc.x, sc.y, sc.z, outtext, scene.color, scene.font, scene.bg, scene.scale)
	end
	
	-- Prompt for description if one exists
	if scene.desc ~= nil and scene.desc ~= "" and not UIView then
		if (dist < Config.DescriptionDistance) and dist <= closest.dist then
			-- Show the "press Enter" text
			DrawText("Press [Enter] for scene details", 0.5, 0.9, 0.3, 0.3, 255, 255, 255, 255, true, true)
			
			if whenKeyJustPressed(0xC7B5340A) then
				UI:View(scene)
			end
		end
	end
	
end

-- Occasionally update object's locations
CreateThread(function()
	Wait(6000)
    while true do
        local sleep = 3000

		if playerCoords and Scenes[1] ~= nil then

			if UISceneType or UIAppearance then
				sleep = 50
			end
			
            for i, _ in pairs(Scenes) do
				
				local scene = Scenes[i]

				if scene.scene_type == 'prop' then
					
					local sc = json.decode(scene.coords)
					
					-- Make sure we start updating faster if we're nearby
					local dist = #(playerCoords - vector3(sc.x, sc.y, sc.z))
					-- if Config.Debug then print("380 - dist: "..dump(dist)) end
					if dist < 50.0 then
						sleep = 50
					end
					
					-- It's a prop scene
					-- Do we already know about this prop object?
					if propObjects[scene.autoid] then
						
						local obj = propObjects[scene.autoid]
						local cfxObj = obj:GetObj()
						
						-- Check if the coords need to be updated
						local cfxObjCoords = GetEntityCoords(cfxObj, true, true)
						local sceneVector = vector3(sc.x, sc.y, sc.z)
						if cfxObjCoords ~= sceneVector then
							Citizen.InvokeNative(0x239A3351AC1DA385, cfxObj, sc.x, sc.y, sc.z, false, false, false) -- SetEntityCoordsNoOffset
							if Config.Debug then print("changing coords", dump(cfxObjCoords), dump(sceneVector)) end
						end
						
						local cfxObjHeading = GetEntityHeading(cfxObj)
						-- if Config.Debug then print("propheading: ", dump(scene.propheading), dump(tonumber(scene.propheading)), dump(ToFloat(tonumber(scene.propheading)))) end
						local sceneHeading = tonumber(scene.propheading)
						local differenceHeading = math.abs(cfxObjHeading - sceneHeading)
						if differenceHeading > 0.5 then
							Citizen.InvokeNative(0xCF2B9C0645C4651B, cfxObj, sceneHeading) -- SetEntityHeading
							if Config.Debug then print("changing heading", dump(cfxObjHeading), dump(sceneHeading)) end
						end
						
					else
						-- Create the object and add to array
						local obj = VORPutils.Objects:Create(scene.prop, sc.x, sc.y, sc.z, 0, false, 'standard')
						obj:Invincible(true)
						if Config.Debug then print(dump(obj)) end
						propObjects[scene.autoid] = obj
						if Config.Debug then print(dump(propObjects)) end
					end
				
				end
			end
			
		end
		
		Citizen.Wait(sleep)
	end
end)

function isAnyUiOpen()
	return UISceneType or UIAppearance or UIDescription or UIView
end

RegisterCommand('scene', function(source, args, raw)
	if Config.Debug then print("313 - scene - source, args, raw: "..dump(source)..", "..dump(args)..", "..dump(raw)) end
    if addMode then
        addMode = false
    elseif not addMode then
        addMode = true
        SceneDot()
    end
end)

RegisterNetEvent('rainbow_scene:sendscenes', function(scenes)
    Scenes = scenes
    UI:Update(scenes, ActiveScene)
end)

RegisterNetEvent('rainbow_scene:removescene', function(nr)
	if Config.Debug then print('rainbow_scene:removescene',nr) end
	if Config.Debug then print('Scenes', dump(Scenes)) end
	if Config.Debug then print('scenebyautoid', findSceneByAutoid(nr)) end
	if findSceneByAutoid(nr) then
		-- If it was a prop scene and we knew about an object for it
		if Config.Debug then print('propObjects', dump(propObjects)) end
		if propObjects[nr] then
			local obj = propObjects[nr]
			obj:Remove()
			if Config.Debug then print('removed obj') end
		end
	end
end)

function findSceneByAutoid(autoid)
	for k,v in pairs(Scenes) do
		if v.autoid == autoid then
			return v
		end
	end
end

RegisterNetEvent('rainbow_scene:client_edit', function(nr)
	if Config.Debug then print("341 - rainbow_scene:client_edit - nr: "..dump(nr)) end
    local scenetext = ""
    CreateThread(function()
        AddTextEntry('FMMC_MPM_NA', Config.Texts.AddDetails)
        DisplayOnscreenKeyboard(0, "FMMC_MPM_NA", "", "", "", "", "", 50)
        while (UpdateOnscreenKeyboard() == 0) do
            DisableAllControlActions(0);
            Wait(5);
        end
        if (GetOnscreenKeyboardResult()) then
            scenetext = GetOnscreenKeyboardResult()

            TriggerServerEvent("rainbow_scene:edited", scenetext, nr)
            CancelOnscreenKeyboard()
        end
    end)
end)

RegisterNetEvent('rainbow_scene:start', function()
	
	-- See how many scenes they have
	TriggerServerEvent("rainbow_scene:GetSceneCount")
	Wait(100)
	if not CheckPlayerCanHaveNumberOfScenes(sceneCount) then
		Notify("You have the maximum number of scenes for your tier.")
		addMode = false
		return
	end
	
	-- Make sure they actually placed it somewhere with the sphere
	local sceneTarget = SceneTarget()
	if sceneTarget.x == 0.0 and sceneTarget.y == 0.0 then
		Notify("Please use the sphere to place the scene near you.")
		return
	end
	
	UI:SceneType()
end)

RegisterNetEvent("rainbow_scene:UpdateSceneCount", function(_sceneCount)
	sceneCount = _sceneCount
end)

RegisterNetEvent('rainbow_scene:retrieveCharData', function(identifier, charIdentifier, job, group)

    Group = group
    Job = job
    Identifier = identifier
    CharIdentifier = charIdentifier
end)


function CheckPlayerCanHaveNumberOfScenes(numberOfScenes)

    if numberOfScenes >= PlayerSceneCountMaximum then
        return false
    else
        return true
    end

end


RegisterNetEvent("rainbow_scene:ReturnPlayerSceneCountMaximum")
AddEventHandler("rainbow_scene:ReturnPlayerSceneCountMaximum", function(sceneCountMaximum)
    PlayerSceneCountMaximum = sceneCountMaximum
end)

RegisterNetEvent("rainbow_scene:ReturnPlayerSceneTimeMaximum")
AddEventHandler("rainbow_scene:ReturnPlayerSceneTimeMaximum", function(sceneTimeMaximum)
    PlayerSceneTimeMaximum = sceneTimeMaximum
end)



RegisterNetEvent("vorp:SelectedCharacter")
AddEventHandler("vorp:SelectedCharacter", function()
	Wait(10000)
	PlayerData()
end)

AddEventHandler('onResourceStart', function(resource)
	Wait(1000)
	PlayerData()
end)

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName ~= GetCurrentResourceName() then
        return
    end
    for _,v in pairs(propObjects) do
		v:Remove()
	end
end)