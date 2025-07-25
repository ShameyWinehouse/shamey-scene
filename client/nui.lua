UI = {}

UISceneType = false
UIAppearance = false
UIDescription = false
UIView = false


-- Make sure only talk keys are passed thru
Citizen.CreateThread(function()
    while true do
        local sleep = 500

		-- Viewing only (not editing)
        if UIView then
            sleep = 0
			
			if IsControlJustPressed(0, 0x156F7119) then -- INPUT_FRONTEND_CANCEL (Esc)
				UI:CloseView()
			end
			
            DisableAllControlActions(0)
			EnableControlAction(0, 0x4BC9DABB, true) -- Enable push-to-talk
			EnableControlAction(0, 0xF3830D8E, true) -- Enable J for jugular
			EnableControlAction(0, 0x156F7119, true) -- INPUT_FRONTEND_CANCEL (Esc)
        end

        Citizen.Wait(sleep)
    end
end)

function UI:Update(scenes, ActiveScene)
	if Config.Debug then print("6 - UI:Update - scenes, ActiveScene: "..dump(scenes)..", "..dump(ActiveScene)) end
    for index, scene in ipairs(scenes) do
        if ActiveScene and ActiveScene.autoid == scene.autoid then
			if UIAppearance then
				UI:Appearance(scene, scene.autoid)
			elseif UIView then
				UI:View(scene)
			end
        end
    end
end

function UI:SceneType()
	if Config.Debug then print("21 - UI:SceneType") end
	
	-- Check if they're at the maximum number of scenes
	if not CheckPlayerCanHaveNumberOfScenes(sceneCount) then
		Notify("You have the maximum number of scenes for your tier.")
		return
	end
	
    SendNUIMessage({
        type = 'sceneType',
        sceneTypeVisible = true,
		sceneType = 'prop',
    })
    SetNuiFocus(true, true)
	SetNuiFocusKeepInput(false)

    UISceneType = true
end

function UI:CloseSceneType()
    SendNUIMessage({
        type = 'sceneType',
        sceneTypeVisible = false,
    })
    SetNuiFocus(false, false)
	SetNuiFocusKeepInput(false)
    UISceneType = false
	ResetActiveScene()
end

function UI:Appearance(scene, index)
	if Config.Debug then print("21 - UI:Appearance - scene, index: "..dump(scene)..", "..dump(index)) end
	
	local descType = getDescType(scene)
	
	local descImgurl
	local descImgalt
	if descType == 'img' then
		local descImgTable = json.decode(scene.desc)
		descImgurl = descImgTable.imgUrl
		descImgalt = descImgTable.imgAlt
	end
	
    SendNUIMessage({
        type = 'appearance',
        visible = true,
        subtitle = '',
        config = Config,
        scene = scene,
        index = index,
		descType = getDescType(scene),
		descImgurl = descImgurl,
		descImgalt = descImgalt,
    })
    SetNuiFocus(true, true)
	SetNuiFocusKeepInput(false)

    UIAppearance = true
end

function UI:CloseAppearance()
    SendNUIMessage({
        type = 'appearance',
        visible = false,
        subtitle = '',
        config = Config,
        index = 0
    })
    SetNuiFocus(false, false)
	SetNuiFocusKeepInput(false)
    UIAppearance = false
    ResetActiveScene()
end

function UI:Description(scene, index)
	if Config.Debug then print("21 - UI:Description - scene, index: "..dump(scene)..", "..dump(index)) end
	
	local descType = getDescType(scene)
	
	local descImgurl
	local descImgalt
	if descType == 'img' then
		local descImgTable = json.decode(scene.desc)
		descImgurl = descImgTable.imgUrl
		descImgalt = descImgTable.imgAlt
	end
	
    SendNUIMessage({
        type = 'description',
        visible = true,
        subtitle = '',
        config = Config,
        scene = scene,
        index = index,
		descType = getDescType(scene),
		descImgurl = descImgurl,
		descImgalt = descImgalt,
    })
    SetNuiFocus(true, true)
	SetNuiFocusKeepInput(false)

    UIDescription = true
end

function UI:CloseDescription()
    SendNUIMessage({
        type = 'description',
        visible = false,
        subtitle = '',
        config = Config,
        index = 0
    })
    SetNuiFocus(false, false)
	SetNuiFocusKeepInput(false)
    UIDescription = false
    ResetActiveScene()
end

function UI:View(scene)
	if Config.Debug then print("51 - UI:View - scene: "..dump(scene)..", ") end
	
	local descType = getDescType(scene)
	
	local descImgurl
	local descImgalt
	if descType == 'img' then
		local descImgTable = json.decode(scene.desc)
		descImgurl = descImgTable.imgUrl
		descImgalt = descImgTable.imgAlt
	end
	
    SendNUIMessage({
        type = 'view',
        viewVisible = true,
        scene = scene,
		descType = getDescType(scene),
		descImgurl = descImgurl,
		descImgalt = descImgalt,
    })
	if Config.Debug then print(dump(getDescType(scene))) end
    SetNuiFocus(true, true)
	SetNuiFocusKeepInput(true)

    UIView = true
end

function UI:CloseView()
	if Config.Debug then print("63 - UI:CloseView") end
    SendNUIMessage({
        type = 'view',
        viewVisible = false,
    })
    SetNuiFocus(false, false)
	SetNuiFocusKeepInput(false)
    UIView = false
    ResetActiveScene()
end


function getDescType(scene)
	if Config.Debug then print("124 - getDescType: "..dump(scene)) end
	if not scene.desc then return nil end
	if string.starts(scene.desc, "{") then
		return "img"
	else
		return "plain"
	end
end

function string.starts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

RegisterNUICallback('create', function(args, cb)
	if Config.Debug then print("create, scenetarget: ", dump(SceneTarget())) end

    local expirationTime = tonumber(args.expiration)
    if Config.Debug then print("expirationTime, PlayerSceneTimeMaximum", expirationTime, PlayerSceneTimeMaximum) end
    -- Check that they can do the expiration that they set
    if expirationTime > PlayerSceneTimeMaximum then
    -- if expirationTime > 0 then
        Notify("You chose an expiration time longer than allowed by your tier. The expiration has been lowered to 24 hrs.")
        expirationTime = Config.MaximumExpirationInHours
    end
	
	if args.sceneType == 'text' then
		TriggerServerEvent("rainbow_scene:addTextScene", args.sceneText, '', SceneTarget(), expirationTime)
	else
		TriggerServerEvent("rainbow_scene:addObjectScene", args.object, '', SceneTarget(), expirationTime)
	end
	
	UI:CloseSceneType()
	addMode = false
	cb('ok')
end)

RegisterNUICallback('closeAppearance', function(args, cb)
	if Config.Debug then print("closeAppearance") end
    UI:CloseAppearance()
	cb('ok')
end)

RegisterNUICallback('closeDescription', function(args, cb)
	if Config.Debug then print("closeDescription") end
    UI:CloseDescription()
	cb('ok')
end)

RegisterNUICallback('closeView', function(args, cb)
	if Config.Debug then print("closeView") end
    UI:CloseView()
	cb('ok')
end)

RegisterNUICallback('closeAll', function(args, cb)
	if Config.Debug then print("closeAll") end
	if addMode then
		UI:CloseSceneType()
	end
	if UIAppearance then
		UI:CloseAppearance()
	end
	if UIDescription then
		UI:CloseDescription()
	end
	if UIView then
		UI:CloseView()
	end
	cb('ok')
end)


RegisterNUICallback('editscene', function(args, cb)
	if Config.Debug then print("editscene") end
    TriggerServerEvent("rainbow_scene:edit", args.index)
    UI:CloseAppearance()
    cb('ok')
end)

RegisterNUICallback('deletescene', function(args, cb)
    TriggerServerEvent("rainbow_scene:delete", args.index)
    UI:CloseAppearance()
    cb('ok')
end)

RegisterNUICallback('updatecolor', function(args, cb)
    TriggerServerEvent("rainbow_scene:color", args.index, args.color)
    cb('ok')
end)

RegisterNUICallback('updatebackgroundcolor', function(args, cb)
    TriggerServerEvent("rainbow_scene:background", args.index, args.color)
    cb('ok')
end)

RegisterNUICallback('updatefont', function(args, cb)
	if Config.Debug then print("updatefont - args, cb: "..dump(args)..", "..dump(cb)) end
    TriggerServerEvent("rainbow_scene:font", args.index, args.font)
    cb('ok')
end)

RegisterNUICallback('updatescale', function(args, cb)
    TriggerServerEvent("rainbow_scene:scale", args.index, args.scale)
    cb('ok')
end)

RegisterNUICallback('updatetext', function(args, cb)
	if Config.Debug then print("updatetext - args, cb: "..dump(args)..", "..dump(cb)) end
    TriggerServerEvent("rainbow_scene:edited", args.text, args.index)
    cb('ok')
end)

RegisterNUICallback('updatedesc', function(args, cb)
	if Config.Debug then print("updatedesc - args, cb: "..dump(args)..", "..dump(cb)) end
	
	if args.type == "plain" then
	
		TriggerServerEvent("rainbow_scene:editeddesc-typetext", args.desc, args.index)
		
	elseif args.type == "img" then
		
		TriggerServerEvent("rainbow_scene:editeddesc-typeimage", args.descImgurl, args.descImgalt, args.index)
		
	end
	
	UI:CloseDescription()
	
    cb('ok')
end)

RegisterNUICallback('moveup', function(args, cb)
    TriggerServerEvent("rainbow_scene:moveup", args.index, args.coords, args.distance)
    cb('ok')
end)

RegisterNUICallback('movedown', function(args, cb)
    TriggerServerEvent("rainbow_scene:movedown", args.index, args.coords, args.distance)
    cb('ok')
end)

RegisterNUICallback('moveleft', function(args, cb)
    TriggerServerEvent("rainbow_scene:moveleft", args.index, args.coords, args.distance)
    cb('ok')
end)

RegisterNUICallback('moveright', function(args, cb)
    TriggerServerEvent("rainbow_scene:moveright", args.index, args.coords, args.distance)
    cb('ok')
end)

RegisterNUICallback('moveforward', function(args, cb)
    TriggerServerEvent("rainbow_scene:moveforward", args.index, args.coords, args.distance)
    cb('ok')
end)

RegisterNUICallback('movebackward', function(args, cb)
    TriggerServerEvent("rainbow_scene:movebackward", args.index, args.coords, args.distance)
    cb('ok')
end)

RegisterNUICallback('rotateleft', function(args, cb)
    TriggerServerEvent("rainbow_scene:rotateleft", args.index, args.propheading, args.distance)
    cb('ok')
end)

RegisterNUICallback('rotateright', function(args, cb)
    TriggerServerEvent("rainbow_scene:rotateright", args.index, args.propheading, args.distance)
    cb('ok')
end)