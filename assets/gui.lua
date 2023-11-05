require "Dialog.lua"

-- Главное Меню

sucFromGameMenuCopy = false
needShowDialog = true
gameLayer = "StageLayer_1"
helpFromGame = 0
sucFromGame = false
sucFromMap = false
optionsFromGame = false
predStage = -1
newStage = -1
helpFromGame = false
countryIntro = false
countryIntroLayerName = ""
countryIntroDialogName = ""
countryIntroReturnLayer = ""
creditsCallingLayer = ""
finalCredits = false

-- показывает, что игровое меню вызвано в игровом экране
menuInGame = false

lastMusicVolume = 0
lastSoundVolume = 0
lastEnvironmentVolume = 0
lastFullscreen = false
lastCustomCursor = false
lastShowHints = false

optionsLayerName = "Options"

function PlayStageMusic(layerName)
	if (layerName == "StageLayer_1") then
		Sound:FadeInTrack("England1", 2.0, true)
	elseif (layerName == "StageLayer_2") then
		Sound:FadeInTrack("France1", 2.0, true)
	elseif (layerName == "StageLayer_3") then
		Sound:FadeInTrack("Egypt", 2.0, true)
	elseif (layerName == "StageLayer_4") then
		Sound:FadeInTrack("India", 2.0, true)
	elseif (layerName == "StageLayer_5") then
		Sound:FadeInTrack("China", 2.0, true)
	elseif (layerName == "StageLayer_6") then
		Sound:FadeInTrack("Japan", 2.0, true)
	elseif (layerName == "StageLayer_7") then
		Sound:FadeInTrack("USA", 2.0, true)
	end
end

function SaveOptions()
	
	-- Запоминаем опции
	lastMusicVolume = gameInfo:getMusicVolume()
	lastSoundVolume = gameInfo:getSoundVolume()
	lastEnvironmentVolume = gameInfo:getEnvironmentVolume()
	lastFullscreen = gameInfo:getFullscreen()
	lastCustomCursor = gameInfo:getCustomCursor()
	lastShowHints = gameInfo:getHintsEnabled()

end

function RestoreOptions()

	-- Восстанавливаем опции
	Sound:SetSoundVolume(lastSoundVolume)
	Sound:SetMusicVolume(lastMusicVolume)
	Sound:SetEnvironmentVolume(lastEnvironmentVolume)

	gameInfo:setMusicVolume(lastMusicVolume)
	gameInfo:setSoundVolume(lastSoundVolume)
	gameInfo:setEnvironmentVolume(lastEnvironmentVolume)
	gameInfo:setCustomCursor(lastCustomCursor)
	gameInfo:setHintsEnabled(lastShowHints)
	gameInfo:setFullscreen(lastFullscreen)

	-- Восстанавливаем значения на слоях
	local optionsName = "Options"

	local iBoolean = "0"
	if lastFullscreen then
		iBoolean = "1"
	end
	GUI:getLayer(optionsName):getWidget("Fullscreen"):AcceptMessage(Message("SetState", iBoolean))

	iBoolean = "0"
	if lastShowHints then
		iBoolean = "1"
	end
	GUI:getLayer(optionsName):getWidget("ATips"):AcceptMessage(Message("SetState", iBoolean))
	
	iBoolean = "0"
	if lastCustomCursor then
		iBoolean = "1"
	end
	GUI:getLayer(optionsName):getWidget("CustomCursor"):AcceptMessage(Message("SetState", iBoolean))

	GUI:getLayer(optionsName):getWidget("Music"):AcceptMessage(Message("SetPos", tostring(lastMusicVolume)))
	GUI:getLayer(optionsName):getWidget("Sound"):AcceptMessage(Message("SetPos", tostring(lastSoundVolume)))

end

function SetOptions()

	-- Устанавливаем опции (для чтения используется слой optionsLayerName)
	local state = GUI:getLayer(optionsLayerName):getWidget("Music"):QueryState(Message("GetPos"))
	local musVolume = 0+state:getData()

	state = GUI:getLayer(optionsLayerName):getWidget("Sound"):QueryState(Message("GetPos"))
	local sndVolume = 0+state:getData()

	state = GUI:getLayer(optionsLayerName):getWidget("SEnvironment"):QueryState(Message("GetPos"))
	local envVolume = 0+state:getData()

	state = GUI:getLayer(optionsLayerName):getWidget("Fullscreen"):QueryState(Message("GetState"))

	Sound:SetSoundVolume(sndVolume)
	Sound:SetMusicVolume(musVolume)
	Sound:SetEnvironmentVolume(envVolume)
	gameInfo:setMusicVolume(musVolume)
	gameInfo:setSoundVolume(sndVolume)
	gameInfo:setEnvironmentVolume(envVolume)

	if state:getData() == "1" and gameInfo:getFullscreen() == false then
		gameInfo:setFullscreen(true)
		SetFullscreenMode()
	end

	if state:getData() == "0" and gameInfo:getFullscreen() == true then
		gameInfo:setFullscreen(false)
		SetWindowedMode()
	end
	
	state = GUI:getLayer(optionsLayerName):getWidget("CustomCursor"):QueryState(Message("GetState"))
	if state:getData() == "1" then
		SetCustomCursor(true)
		gameInfo:setCustomCursor(true)
	else
		SetCustomCursor(false)
		gameInfo:setCustomCursor(false)
	end
	
	state = GUI:getLayer(optionsLayerName):getWidget("ATips"):QueryState(Message("GetState"))
	if state:getData() == "1" then
		gameInfo:setHintsEnabled(true)
	else
		gameInfo:setHintsEnabled(false)
	end


	-- Устанавливаем значения на слоях
	local optionsName = "Options"

	GUI:getLayer(optionsName):getWidget("Music"):AcceptMessage(Message("SetPos", tostring(musVolume)))
	GUI:getLayer(optionsName):getWidget("Sound"):AcceptMessage(Message("SetPos", tostring(sndVolume)))
	GUI:getLayer(optionsName):getWidget("SEnvironment"):AcceptMessage(Message("SetPos", tostring(envVolume)))

	local iBoolean = "0"
	if gameInfo:getFullscreen() then
		iBoolean = "1"
	end
	GUI:getLayer(optionsName):getWidget("Fullscreen"):AcceptMessage(Message("SetState", iBoolean))

	iBoolean = "0"
	if gameInfo:getHintsEnabled() then
		iBoolean = "1"
	end
	GUI:getLayer(optionsName):getWidget("ATips"):AcceptMessage(Message("SetState", iBoolean))
	
	iBoolean = "0"
	if gameInfo:getCustomCursor() then
		iBoolean = "1"
	end
	GUI:getLayer(optionsName):getWidget("CustomCursor"):AcceptMessage(Message("SetState", iBoolean))

end

function StartGame()

	Sound:FadeOutAllTracks(1.0)
--	gameInfo:setLives(3)
	      
	param = VariableSet()
	if (gameInfo:getStage() == 2) and (gameInfo:getLevel() == 1) and (needShowDialog) then
		GUI:getLayer("StageLayer_1"):getWidget("GameField"):AcceptMessage( Message("InitLevelView2") )
		GUI:getLayer("StageLayer_2"):getWidget("GameField"):AcceptMessage( Message("InitLevelView2") )
		param:setString("Layer1", "StageLayer_1")
		GUI:getLayer("StageLayer_1"):getWidget("GameField"):AcceptMessage( Message("DisableRain") )
	else
		GUI:getLayer("StageLayer_1"):getWidget("GameField"):AcceptMessage( Message("EnableRain") )
		param:setString("Layer1", gameLayer)
	end
	
--	param:setString("Layer1", gameLayer)
	param:setString("EndHandler", "InitGameField")
	param:setString("CrossHandler", "InitGameField2")

	kernel:addController(controlFactory:Create("CrossFade", param))

end

function InitGameField2()
	Sound:FadeOutAllTracks(1.0)
--	GUI:getLayer(gameLayer):getWidget("GameField"):AcceptMessage( Message("HideShowLevelList") )
	UploadResourceGroup("Game")
	UploadResourceGroup("Clouds")
	UploadResourceGroup("Bonus")
	GUI:getLayer(gameLayer):getWidget("GameField"):AcceptMessage( Message("InitLevelView") )
	
	if (gameInfo:getStage() == 2) and (gameInfo:getLevel() == 1) and (needShowDialog) then
		GUI:getLayer("StageLayer_1"):getWidget("Background"):AcceptMessage( Message("SoundOn") )
	else
		GUI:getLayer(gameLayer):getWidget("Background"):AcceptMessage( Message("SoundOn") )
	
	end

	GUI:getLayer("Bag"):getWidget("Bag"):AcceptMessage( Message("Release") )
--	GUI:getLayer("Bag"):getWidget("Bag"):AcceptMessage( Message("InitBagView") )
end

function InitGameField()
--	GUI:getLayer(gameLayer):getWidget("GameField"):AcceptMessage( Message("InitLevelView") )
--	GUI:getLayer(gameLayer):getWidget("GameField"):AcceptMessage( Message("Start") )
--	GUI:getLayer(gameLayer):getWidget("GameField"):AcceptMessage( Message("SetActive", 1) )
--	GUI:getLayer(gameLayer):getWidget("GameField"):AcceptMessage( Message("RunStartAW", 1) )

	MessageManager:putMessage(Message("ShowStartLevelDialog"))

--	GUI:getLayer(gameLayer):getWidget("GameField"):AcceptMessage( Message("FillLevelList", 1) )

	if (needShowDialog) then
		GUI:getLayer("StageLayer_1"):getWidget("GameField"):AcceptMessage(Message("StartLevelMusicBeforeDialog"))
	else
		GUI:getLayer("StageLayer_1"):getWidget("GameField"):AcceptMessage(Message("StartLevelMusic"))
	end
end

function ViewBackgroundCross()

	local name = ""
	if (predStage == 1) then
		name = "StageLayer_1"
	elseif (predStage == 2) then
		name = "StageLayer_2"
	elseif (predStage == 3) then
		name = "StageLayer_3"
	elseif (predStage == 4) then
		name = "StageLayer_4"
	elseif (predStage == 5) then
		name = "StageLayer_5"
	elseif (predStage == 6) then
		name = "StageLayer_6"
	elseif (predStage == 7) then
		name = "StageLayer_7"
	end
	
	ReleaseResourceGroup(name)
	
	if (newStage == 1) then
		name = "StageLayer_1"
		Sound:FadeInTrack("England", 2.0, true)
	elseif (newStage == 2) then
		name = "StageLayer_2"
		Sound:FadeInTrack("France", 2.0, true)
	elseif (newStage == 3) then
		name = "StageLayer_3"
		Sound:FadeInTrack("Egypt", 2.0, true)
	elseif (newStage == 4) then
		name = "StageLayer_4"
		Sound:FadeInTrack("India", 2.0, true)
	elseif (newStage == 5) then
		name = "StageLayer_5"
		Sound:FadeInTrack("China", 2.0, true)
	elseif (newStage == 6) then
		name = "StageLayer_6"
		Sound:FadeInTrack("Japan", 2.0, true)
	elseif (newStage == 7) then
		name = "StageLayer_7"
		Sound:FadeInTrack("USA", 2.0, true)
	end
	
	UploadResourceGroup("Game")
	UploadResourceGroup("Clouds")
	UploadResourceGroup("Bonus")
	UploadResourceGroup(name)
	
	predStage = newStage
end

function ViewBackground(stage)
	Sound:FadeOutAllTracks(1.0)

	newStage = stage

	local name = ""
	if (stage == 1) then
		name = "TestLayer_1"
	elseif (stage == 2) then
		name = "TestLayer_2"
	elseif (stage == 3) then
		name = "TestLayer_3"
	elseif (stage == 4) then
		name = "TestLayer_4"
	elseif (stage == 5) then
		name = "TestLayer_5"
	elseif (stage == 6) then
		name = "TestLayer_6"
	elseif (stage == 7) then
		name = "TestLayer_7"
	end
	
	GUI:getLayer(name):getWidget("1_BG"):AcceptMessage( Message("SetTimeEnabled", 1) )
	
	param = VariableSet()
	param:setString("Layer1", name)
	param:setString("CrossHandler", "ViewBackgroundCross")

	kernel:addController(controlFactory:Create("CrossFade", param))	
end

function RunNewLevel()
	resetSucFromGame()
	Sound:FadeOutAllTracks(1.0)

	UpdateGameLayerName()
	GUI:getLayer("Bag"):getWidget("Bag"):AcceptMessage( Message("InitBagView") )
	StartGame()
end

function UploadBagRes()
	UploadResourceGroup("BagRes")
	UploadResourceGroup("SmallArts")
	GUI:getLayer(gameLayer):getWidget("Background"):AcceptMessage( Message("SoundOff") )
end

function UploadBagResAfterDialog()
	UploadResourceGroup("BagRes")
	UploadResourceGroup("SmallArts")
	GUI:getLayer(gameLayer):getWidget("Background"):AcceptMessage( Message("SoundOff") )
	GUI:getLayer("Bag"):getWidget("Bag"):AcceptMessage( Message("InitNoteView2") )
end

function RunDialog(dlg)
	Screen:pushLayer( GUI:getLayer("Dialog") )
	GUI:getLayer("Dialog"):getWidget("Dialog"):AcceptMessage( Message("Run", dlg) )
end

function AddNewAbzac()
	GUI:getLayer("Bag"):getWidget("Bag"):AcceptMessage( Message("AddAbzacAfterLevel") )
end

function StartLondonMusic()
	Sound:FadeInTrack("England2", 2.0, true)
end

function ShowHeart()
	GUI:getLayer("Dialog"):getWidget("Dialog"):AcceptMessage( Message("ShowHeart") )
end

function ShowFeerverk()
	GUI:getLayer("Dialog"):getWidget("Dialog"):AcceptMessage( Message("ShowFeerverk") )
end

function HideFeerverk()
	GUI:getLayer("Dialog"):getWidget("Dialog"):AcceptMessage( Message("HideFeerverk") )
end

function ShowTheEnd()
	GUI:getLayer("Dialog"):getWidget("Dialog"):AcceptMessage( Message("ShowTheEnd") )
end

function StartFinalCredits()
	finalCredits = true
	GUI:getLayer(gameLayer):getWidget("GameField"):AcceptMessage( Message("HideRings") )
	Screen:pushLayer( GUI:getLayer("FinalCredits") )
	GUI:getLayer("FinalCredits"):getWidget("Credits"):AcceptMessage(Message("Reset", "4.0"))
end

function HideRings()
	GUI:getLayer(gameLayer):getWidget("GameField"):AcceptMessage( Message("HideRings") )
end

function DialogFunc(message)
	if message:is("DialogEnd") then
		Screen:popLayer();
	elseif message:is("Skip", "press") then
		GUI:getLayer("Dialog"):getWidget("Dialog"):AcceptMessage( Message("Skip") )
	elseif message:is("StartGame") then
		if (needShowDialog == true)and(gameInfo:getLevel() == 1)and(gameInfo:getStage() > 1) then
			needShowDialog = false
			param = VariableSet()
			param:setString("Layer1", "Bag")
			
			if (gameInfo:getLevel() == 1) then
				param:setString("CrossHandler", "UploadBagResAfterDialog")
				param:setString("EndHandler", "AddNewAbzac")
			else
				param:setString("CrossHandler", "UploadBagRes")
			end

			Sound:FadeOutAllTracks(1.0)
			Sound:FadeInTrack("Bag", 2.0, true)
			GUI:getLayer("Bag"):getWidget("Bag"):AcceptMessage( Message("ShowPanel") )
			kernel:addController(controlFactory:Create("CrossFade", param))
		else
			GUI:getLayer(gameLayer):getWidget("GameField"):AcceptMessage( Message("RunStartAW", 1) )
		end
	elseif message:is("DialogSwitchToFrance") then
		gameInfo:setStage(2)
		GUI:getLayer("StageLayer_2"):getWidget("GameField"):AcceptMessage( Message("InitLevelView") )
		param = VariableSet()
		param:setString("Layer1", "StageLayer_2")
		param:setString("Layer2", "Dialog")
		param:setString("CrossHandler", "FromLondonToFranceCross")
		
		kernel:addController(controlFactory:Create("CrossFade", param))

		GUI:getLayer("StageLayer_1"):getWidget("Background"):AcceptMessage( Message("SoundOff") )
		Sound:FadeOutAllTracks(1.0)

	elseif message:is("SkipDlg_21") then
		GUI:getLayer("StageLayer_1"):getWidget("GameField"):AcceptMessage( Message("EnableRain") )
		if (countryIntro == true) then
			param = VariableSet()
			param:setString("Layer1", countryIntroReturnLayer);
			param:setString("CrossHandler", "CountryIntroExitCross")
			kernel:addController(controlFactory:Create("CrossFade", param))
			Sound:FadeOutAllTracks(1.0)
		else
			gameInfo:setStage(2)
			UpdateGameLayerName()
			GUI:getLayer("StageLayer_2"):getWidget("GameField"):AcceptMessage( Message("InitLevelView") )

			needShowDialog = false

			param = VariableSet()
			param:setString("Layer1", "Bag")

			if (gameInfo:getLevel() == 1) then
				param:setString("CrossHandler", "UploadBagResAfterDialog")
				param:setString("EndHandler", "AddNewAbzac")
			else
				param:setString("CrossHandler", "UploadBagRes")
			end

			Sound:FadeOutAllTracks(1.0)
			Sound:FadeInTrack("Bag", 2.0, true)

			GUI:getLayer("Bag"):getWidget("Bag"):AcceptMessage( Message("ShowPanel") )
			kernel:addController(controlFactory:Create("CrossFade", param))

	--		param:setString("Layer1", "StageLayer_2")
	--		param:setString("Layer2", "Dialog")
	--		param:setString("EndHandler", "StartAw");

	--		kernel:addController(controlFactory:Create("CrossFade", param))
		end
	end
end

function FromLondonToFranceCross()
	Sound:FadeInTrack("France1", 2.0, true)
	GUI:getLayer("StageLayer_2"):getWidget("Background"):AcceptMessage( Message("SoundOn") )
end

function StartAw()
	GUI:getLayer(gameLayer):getWidget("GameField"):AcceptMessage( Message("RunStartAW", 1) )
end

function MGFunc(message)
	GUI:getLayer("MagicGame"):getWidget("TestWidget"):AcceptMessage( message )
end

function IntroFunc(message)
	if (message:is("SetMenuLayer")) then
		Screen:Clear()
		Screen:pushLayer( GUI:getLayer("MainMenu") )
		Screen:pushLayer( GUI:getLayer("JuleBook") )

		ReleaseResourceGroup("Intro")
		GUI:getLayer("JuleBook"):getWidget("JuleBook"):AcceptMessage( Message("Release") )
		UploadResourceGroup("Clouds")
		UploadResourceGroup("MainMenu")
		GUI:getLayer("MainMenu"):getWidget("MainMenu"):AcceptMessage( Message("ResetTimer") )
--		Sound:FadeInTrack("Menu", 2.0, true)
	elseif (message:is("PopLayer")) then
		Screen:popLayer()
		if (gameInfo:getNumberOfPlayers() == 0) then
			CreateFirstPlayer()
		end
	elseif (message:is("CrossToMenu")) then
		param = VariableSet()
		param:setString("Layer1", "MainMenu");
		param:setString("CrossHandler", "FromIntroToMenu")
		kernel:addController(controlFactory:Create("CrossFade", param))	
	end
end

function FromIntroToMenu()
	ReleaseResourceGroup("Intro")
	UploadResourceGroup("Clouds")
	GUI:getLayer("JuleBook"):getWidget("JuleBook"):AcceptMessage( Message("Release") )
end

function HelpFunc(message)
	if (message:is("Ok", "press")) then

		param = VariableSet()
		param:setInt("Type", 2)
		param:setString("EndHandler", "ReleaseHelp");
		param:setString("fadeLayer", "Cross5")
		kernel:addController(controlFactory:Create("FadePopSlider", param))		
	else
		GUI:getLayer("Help"):getWidget("Help"):AcceptMessage( message )
	end
end

function ReleaseHelp()
	ReleaseResourceGroup("Help");
	if (helpFromGame == false) then
		ReleaseResourceGroup("Bonus");
	end
end

function UpdateGameLayerName()
	stg = gameInfo:getStage()
	if (stg == 1) then
		gameLayer = "StageLayer_1"
	elseif (stg == 2) then
		gameLayer = "StageLayer_2"
	elseif (stg == 3) then
		gameLayer = "StageLayer_3"
	elseif (stg == 4) then
		gameLayer = "StageLayer_4"
	elseif (stg == 5) then
		gameLayer = "StageLayer_5"
	elseif (stg == 6) then
		gameLayer = "StageLayer_6"
	elseif (stg == 7) then
		if (gameInfo:getLevel() < 14) then
			gameLayer = "StageLayer_7"
		else
			gameLayer = "StageLayer_1"
		end
	end
end

function StartLevelMusic()
	
	GUI:getLayer(gameLayer):getWidget("GameField"):AcceptMessage(Message("StartLevelMusic"))

--	stg = gameInfo:getStage()
--	if (stg == 1) then
--		Sound:FadeInTrack("England", 2.0, true)
--	elseif (stg == 2) then
--		Sound:FadeInTrack("France", 2.0, true)
--	elseif (stg == 3) then
--		Sound:FadeInTrack("Egypt", 2.0, true)
--	elseif (stg == 4) then
--		Sound:FadeInTrack("India", 2.0, true)
--	elseif (stg == 5) then
--		Sound:FadeInTrack("China", 2.0, true)
--	elseif (stg == 6) then
--		Sound:FadeInTrack("Japan", 2.0, true)
--	elseif (stg == 7) then
--		Sound:FadeInTrack("USA", 2.0, true)
--	end
end

function MainMenuFunc(message)
	if message:is("start", "press") then
		param = VariableSet()
		param:setString("Layer1", "Map");
		param:setString("EndHandler", "MapEndHandler")
		param:setString("CrossHandler", "FromMainMenuCross")
		kernel:addController(controlFactory:Create("CrossFade", param))	
		Sound:FadeOutAllTracks(1.0)
	elseif message:is("options", "press") then
		creditsCallingLayer = "MainMenu"	
		SaveOptions()
		param = VariableSet()
		param:setString("Layer", "Options")
		kernel:addController(controlFactory:Create("FadePushSlider", param))		
		optionsFromGame = false
	elseif message:is("exit", "press") then
		if gameInfo:isScreensaverEnabled() then
			param = VariableSet()
			param:setInt("Type", 2)
			param:setString("Layer", "ExitConfirm")
			kernel:addController(controlFactory:Create("FadePushSlider", param))		
		else
			GUI:getLayer("ExitConfirmWithSS"):getWidget("EnableScreensaver"):AcceptMessage(Message("SetState", "0"))
			
			param = VariableSet()
			param:setInt("Type", 2)
			param:setString("Layer", "ExitConfirmWithSS")
			kernel:addController(controlFactory:Create("FadePushSlider", param))		
		end
	elseif message:is("profileButton", "press") then
		local state = GUI:getLayer("Profiles"):getWidget("Names"):AcceptMessage(Message("SetNeedHideHint", 0))
		GUI:getLayer("Profiles"):getWidget("Names"):AcceptMessage(Message("Set", gameInfo:getName()))
		param = VariableSet()
		param:setString("Layer", "Profiles")
		param:setInt("Type", 2)
		kernel:addController(controlFactory:Create("FadePushSlider", param))
	elseif message:is("help", "press") then
		UploadResourceGroup("Help");
		UploadResourceGroup("Bonus");
		helpFromGame = false;
		param = VariableSet()
		param:setInt("Type", 2)
		param:setString("Layer", "Help")
		param:setString("fadeLayer", "Cross5")
		kernel:addController(controlFactory:Create("FadePushSlider", param))		
	elseif message:is("ScreenSaver", "press") then
		gameInfo:SetSSOptionsToLayer()
		param = VariableSet()
		param:setString("Layer", "SSOptions")
		param:setString("EndHandler", "StoreSSOptions")
		param:setInt("Type", 1)
		kernel:addController(controlFactory:Create("FadePushSlider", param))
	elseif message:is("hiscores", "press") then
		GUI:getLayer("HiScores"):getWidget("HiScores"):AcceptMessage( Message("Start") )
		param = VariableSet()
		param:setString("Layer", "HiScores")
		param:setInt("Type", 2)
		kernel:addController(controlFactory:Create("FadePushSlider", param))		
	end
end

function StoreSSOptions()
	gameInfo:CopySSOptionsToBuff()
end

function HiScoresFunc(message)
	if message:is("Ok", "press") then
		GUI:getLayer("HiScores"):getWidget("HiScores"):AcceptMessage( Message("Finish") )
		param = VariableSet()
		param:setInt("Type", 2)
		kernel:addController(controlFactory:Create("FadePopSlider", param))
	end	
end

function FromMainMenuCross()
	GUI:getLayer("Bag"):getWidget("Bag"):AcceptMessage( Message("InitBagView") )
	GUI:getLayer("MainMenu"):getWidget("MainMenu"):AcceptMessage( Message("Pause") )
	GUI:getLayer("Map"):getWidget("Map"):AcceptMessage(Message("InitView"))
	Sound:FadeInTrack("Map", 2.0, true)

	ReleaseResourceGroup("IntroMenu")
	UploadResourceGroup("SmallArts")
end

function ToMainMenuCross()

	Sound:FadeOutAllTracks(1.0)
	Sound:FadeInTrack("Menu", 2.0, true)

	ReleaseResourceGroup("SmallArts")

	UploadResourceGroup("Clouds")
	UploadResourceGroup("IntroMenu")

	GUI:getLayer("MainMenu"):getWidget("MainMenu"):AcceptMessage( Message("Continue") )
end

function ContinueGame()
	GUI:getLayer(gameLayer):getWidget("GameField"):AcceptMessage( Message("SetActive", 1) )
	GUI:getLayer(gameLayer):getWidget("GameField"):AcceptMessage( Message("Continue") )
end

function MenuInGameFunc(message)

	if message:is("Resume", "press") then
--		sucFromGame = false
		param = VariableSet()
		if (menuInGame == true) then
			param:setString("EndHandler", "ContinueGame")
			GUI:getLayer(gameLayer):getWidget("Background"):AcceptMessage( Message("SoundOn") )
		end
		kernel:addController(controlFactory:Create("FadePopSlider", param))


--		GUI:getLayer("Dialog"):getWidget("Dialog"):AcceptMessage( Message("Reload") )
--		param:setString("Layer1", "Bag");
--		param:setString("CrossHandler", "MapToSuc");
--		param:setString("EndHandler", "RunDialogInBag");
--		kernel:addController(controlFactory:Create("CrossFade", param))	
	elseif message:is("Help", "press") then
		UploadResourceGroup("Help");
		helpFromGame = true;
		param = VariableSet()
		param:setInt("Type", 2)
		param:setString("Layer", "Help")
		param:setString("fadeLayer", "Cross5")
		kernel:addController(controlFactory:Create("FadePushSlider", param))		

	elseif message:is("A_Options", "press") then
		SaveOptions()
		param = VariableSet()
		param:setString("Layer", "Options")
		param:setInt("Type", 1)
		kernel:addController(controlFactory:Create("CrossSlider", param))
		optionsFromGame = true
	elseif message:is("MainMenu", "press") then

			exitGameLayer = "ExitGameNoLostLife"
			if (gameInfo:NeedDecLivesOnExit() == true) then
				exitGameLayer = "ExitGame"
			end

			param = VariableSet()
			param:setString("Layer", exitGameLayer)
			param:setInt("Type", 1)
			kernel:addController(controlFactory:Create("CrossSlider", param))


--		if (sucFromGame == true) then
--			exitGameLayer = "ExitGameNoLostLife"
--			if (gameInfo:NeedDecLivesOnExit() == true) then
--				exitGameLayer = "ExitGame"
--			end
--
--			param = VariableSet()
--			param:setString("Layer", exitGameLayer)
--			param:setInt("Type", 1)
--			kernel:addController(controlFactory:Create("CrossSlider", param))
--		else
--			sucFromGame = false
--			creditsFromGame = false
--
--			Sound:FadeOutAllTracks(1.0)
--			Sound:FadeInTrack("Menu", 3.0, true)
--
--			param = VariableSet()
--			param:setString("Layer1", "MainMenu");
--			param:setString("CrossHandler", "ExitGameCrossHandler")
--			kernel:addController(controlFactory:Create("CrossFade", param))
--		end

	end
end

function ExitGameFunc(message)

	if message:is("Yes", "press") then
	
		sucFromGame = false
		creditsFromGame = false
	
		Sound:FadeOutAllTracks(1.0)
		Sound:FadeInTrack("Menu", 3.0, true)

		param = VariableSet()
		param:setString("Layer1", "MainMenu");
		param:setString("CrossHandler", "ExitGameCrossHandler")
		kernel:addController(controlFactory:Create("CrossFade", param))
		
--		SetHiscoreActive(1)

	elseif message:is("No", "press") then

		param = VariableSet()
		param:setString("Layer", "MenuInGame")
		param:setInt("Type", 2)
		kernel:addController(controlFactory:Create("CrossSlider", param))

	end
end

function ExitGameCrossHandler()
	ReleaseResourceGroup("Game")
	ReleaseResourceGroup("Bonus")
	ReleaseResourceGroup("BagRes")
	UploadResourceGroup("Clouds")
	GUI:getLayer("MainMenu"):getWidget("MainMenu"):AcceptMessage( Message("Continue") )

	GUI:getLayer(gameLayer):getWidget("GameField"):AcceptMessage(Message("Reset"))

	gameInfo:WriteResultToHiScores()
--	gameInfo:ResetInfoToBeginLevel()
	
	if (gameInfo:NeedDecLivesOnExit() == true) then
		local lives = gameInfo:getLives()
		lives = lives - 1
		gameInfo:setLives(lives)
		if (lives < 1) then
			gameInfo:IncreaseDifficultyLevel()
			GameOverEndHandler()
		end
	end
	
	if (gameInfo:IsGameOver() == true) then
		gameInfo:setScore(0)
		gameInfo:setUID()
	end
	gameInfo:Save()
end

function GameOverEndHandler()
	GUI:getLayer("Map"):getWidget("Map"):AcceptMessage( Message("DestroyCountryProgress") )
	gameInfo:setLives(3)
	gameInfo:setScore(0)
	gameInfo:setUID()
	gameInfo:KillProgress()
end

function LoseLifeFunc(message)
	if message:is("LoseLife", "press") then	
		param = VariableSet()
		param:setString("Layer1", gameLayer);
		param:setString("CrossHandler", "CrossLoseLife")
		param:setString("EndHandler", "AfterLoseLife")
		param:setString("FadeName", "Cross1")
		kernel:addController(controlFactory:Create("CrossFade", param))
	end
end

function GameOverFunc(message)
	if message:is("GameOver", "press") then
		gameInfo:KillProgress()
		Sound:FadeOutAllTracks(2.0);
		Sound:FadeInTrack("Map", 3.0, true);
		param = VariableSet()
		param:setString("Layer1", "Map");
		param:setString("EndHandler", "MapEndHandler")
		param:setString("CrossHandler", "GameOverCrossHandler")
		kernel:addController(controlFactory:Create("CrossFade", param))
	end
end

function GameOverCrossHandler()
	GUI:getLayer("Map"):getWidget("Map"):AcceptMessage(Message("InitView"))
	gameInfo:setLives(3)
	gameInfo:setScore(0)
	gameInfo:setUID()
end

function CrossLoseLife()
	GUI:getLayer(gameLayer):getWidget("GameField"):AcceptMessage( Message("InitLevelView") )
	GUI:getLayer(gameLayer):getWidget("GameField"):AcceptMessage( Message("StartLevelMusic") )
end

function AfterLoseLife()
	GUI:getLayer(gameLayer):getWidget("GameField"):AcceptMessage( Message("RunStartAW") )
end



-- Опции
function OptionsFunc(message)

	if message:is("Cancel", "press") then

		RestoreOptions()

		if (optionsFromGame == true) then
			param = VariableSet()
			param:setString("Layer", "MenuInGame")
			param:setInt("Type", 2)
			kernel:addController(controlFactory:Create("CrossSlider", param))
		else
			param = VariableSet()
			kernel:addController(controlFactory:Create("FadePopSlider", param))
		end	

	elseif message:is("Ok", "press") then

		SetOptions()

		if (optionsFromGame == true) then
			param = VariableSet()
			param:setString("Layer", "MenuInGame")
			param:setInt("Type", 2)
			kernel:addController(controlFactory:Create("CrossSlider", param))
		else
			param = VariableSet()
			kernel:addController(controlFactory:Create("FadePopSlider", param))
		end	
	
	elseif message:is("Music") then

		local musicVolume = message:getIntegerParam()
		gameInfo:setMusicVolume(musicVolume)
		Sound:SetMusicVolume(musicVolume)

	elseif message:is("Sound") then

		local soundVolume = message:getIntegerParam()
		gameInfo:setSoundVolume(soundVolume)
		Sound:SetSoundVolume(soundVolume)
	
		if message:is("Sound", "up") then
			Sound:PlaySample("Hint", 1.0)
		end

	elseif message:is("SEnvironment") then

		local envVolume = message:getIntegerParam()
		gameInfo:setEnvironmentVolume(envVolume)
		Sound:SetEnvironmentVolume(envVolume)

	elseif message:is("Credits", "press") then
		param = VariableSet()
		param:setString("Layer1", "Credits")
		param:setString("CrossHandler", "UploadCredits")
		kernel:addController(controlFactory:Create("CrossFade", param))
	end
end

function UploadCredits()
	UploadResourceGroup("StageLayer_1")
	UploadResourceGroup("Clouds")
	UploadResourceGroup("Game")
	GUI:getLayer("Credits"):getWidget("Background"):AcceptMessage( Message("SetTime", "0.0") )
	GUI:getLayer("Credits"):getWidget("Credits"):AcceptMessage(Message("Reset"))		
end

function CreditsFunc(message)
	if (message:is("Exit")) then
		if (finalCredits) then
			finalCredits = false
			local param = VariableSet()
			param:setString("Layer1", "Map")
			param:setString("EndHandler", "MapEndHandler")
			param:setString("CrossHandler", "ExitFinalCreditsCross")
			kernel:addController(controlFactory:Create("CrossFade", param))
		else
			local param = VariableSet()
			param:setString("Layer1", creditsCallingLayer)
			param:setString("Layer2", "Cross4")
			param:setString("Layer3", "Options")
			param:setString("CrossHandler", "ExitCreditsCross")
			kernel:addController(controlFactory:Create("CrossFade", param))
		end
	end
end

function ExitCreditsCross()
	if not(creditsCallingLayer == "StageLayer_1") then
		ReleaseResourceGroup("StageLayer_1")
	end
end

function ExitFinalCreditsCross()
	ReleaseResourceGroup("StageLayer_1")
	ReleaseResourceGroup("Bonus")
	ReleaseResourceGroup("Clouds")
	ReleaseResourceGroup("Game")
	MapCrossHandler()
end

function FromLoadScreenStart()
	GUI:getLayer("LoadScreen"):getWidget("LoadScreen"):AcceptMessage(Message("Release"))
	UploadGameIntro()
end

function FromLoadScreenStartNewPlayer()
	GUI:getLayer("LoadScreen"):getWidget("LoadScreen"):AcceptMessage(Message("Release"))
	UploadGameIntroNewPlayer()
end

function CreateFirstPlayer()
--	GUI:getLayer("FirstProfile"):getWidget("InfoText"):AcceptMessage(Message("SetString", "maximum 12 characters"))
	GUI:getLayer("FirstProfile"):getWidget("Name"):AcceptMessage(Message("Clear"))

	local panelWidget = GUI:getLayer("FirstProfile"):getWidget("Panel")
	panelWidget:setColor(Color(255, 255, 255, 0))

	local fadeWidget = GUI:getLayer("Fade3"):getWidget("Fade3")
	fadeWidget:setColor(Color(0, 0, 0, 0))

	local param = VariableSet()
	param:setWidget("Widget", panelWidget)
	param:setColor("To", Color(255, 255, 255, 255))
	kernel:addController(controlFactory:Create("Fader", param))

	param = VariableSet()
	param:setWidget("Widget", fadeWidget)
	param:setColor("To", Color(0, 0, 0, 150))
	kernel:addController(controlFactory:Create("Fader", param))

	Screen:pushLayer(GUI:getLayer("Fade3"))
	Screen:pushLayer(GUI:getLayer("FirstProfile"))
end

function LoadScreenFunc(message)
	if message:is("Start") then
		if (gameInfo:getNumberOfPlayers() == 0) then
			local param = VariableSet()
			param:setString("Layer1", "JuleBook")
			param:setString("CrossHandler", "FromLoadScreenStartNewPlayer")
			kernel:addController(controlFactory:Create("CrossFade", param))

--			local param = VariableSet()
--			param:setString("Layer1", "MainMenu")
--			param:setString("CrossHandler", "ToMainMenuCross")
--			param:setString("EndHandler", "CreateFirstPlayer")
--			kernel:addController(controlFactory:Create("CrossFade", param))
		else
			local param = VariableSet()
			param:setString("Layer1", "JuleBook")
			param:setString("CrossHandler", "FromLoadScreenStart")
			kernel:addController(controlFactory:Create("CrossFade", param))
		end
	end
end

addArtefact = 0

function HintFunc(message)
	if message:is("Ok", "press") then
		GUI:getLayer("Hint"):getWidget("Hint"):AcceptMessage( Message("Hide") )
	elseif message:is("PopLayer") then
		Screen:popLayer()
	end
end

function PreviewSSExit()
	GUI:getLayer("StageLayer_1"):getWidget("GameField"):AcceptMessage( Message("SetPreviewSSMode", 0) )
end

function GameFunc(message)

	if message:is("RunNextBackground") then
		param = VariableSet()
		param:setString("Layer1", message:getData())
		param:setString("CrossHandler", "UploadScreensaverBG")
		kernel:addController(controlFactory:Create("CrossFade", param))	
		Sound:FadeOutAllTracks(1.0)
		PlayStageMusic(message:getData())
	elseif message:is("PreviewSSExit") then
		if (gameInfo:isScreensaver()) then
			CloseApplication()
		else
			param = VariableSet()
			param:setString("Layer1", "MainMenu")
			param:setString("Layer2", "Cross4")
			param:setString("Layer3", "SSOptions")
			param:setString("CrossHandler", "PreviewSSExit")
			kernel:addController(controlFactory:Create("CrossFade", param))	
			gameInfo:setPreviewSSMode(false)
			Sound:FadeOutAllTracks(1.0)
			Sound:FadeInTrack("Menu", 2.0, true)
		end
	elseif message:is("Escape") then

	elseif message:is("Menu", "press") then
		creditsCallingLayer = gameLayer
			
		menuInGame = true
--		sucFromGame = true
--		GUI:getLayer(gameLayer):getWidget("Background"):AcceptMessage( Message("SoundOff") )
		GUI:getLayer(gameLayer):getWidget("GameField"):AcceptMessage(Message("Pause"))
		GUI:getLayer(gameLayer):getWidget("GameField"):AcceptMessage( Message("SetActive", 0) )
		param = VariableSet()
		param:setString("Layer", "MenuInGame");
		kernel:addController(controlFactory:Create("FadePushSlider", param))
	elseif message:is("NextLevel") then

	elseif message:is("Load", "press") then
		needShowDialog = true
		GUI:getLayer(gameLayer):getWidget("GameField"):AcceptMessage(Message("RunLevel"))
	elseif message:is("down", "press") then
		GUI:getLayer(gameLayer):getWidget("LevelList"):AcceptMessage(Message("ScrollUp"))
	elseif message:is("up", "press") then
		GUI:getLayer(gameLayer):getWidget("LevelList"):AcceptMessage(Message("ScrollDown"))
	elseif message:is("PushBagLayer") then
		GUI:getLayer(gameLayer):getWidget("Background"):AcceptMessage( Message("SoundOff") )
		GUI:getLayer(gameLayer):getWidget("GameField"):AcceptMessage(Message("ResetBagFlying"))
		Screen:Clear()
		ReleaseResourceGroup(gameLayer)
		ReleaseResourceGroup("Game")
		ReleaseResourceGroup("Bonus")
		UploadResourceGroup("BagRes")
		UploadResourceGroup("SmallArts")
		GUI:getLayer("Bag"):getWidget("Bag"):AcceptMessage( Message("Upload") )
		Screen:pushLayer( GUI:getLayer("Bag") )
		GUI:getLayer("Bag"):getWidget("Bag"):AcceptMessage( Message("OpenBook") )
		GUI:getLayer("Bag"):getWidget("Bag"):AcceptMessage( Message("ShowPanel") )
		gameInfo:Save()
	elseif message:is("SetBagLayer") then
		GUI:getLayer(gameLayer):getWidget("Background"):AcceptMessage( Message("SoundOff") )
		GUI:getLayer(gameLayer):getWidget("GameField"):AcceptMessage(Message("ResetBagFlying"))
		Screen:Clear()
		ReleaseResourceGroup(gameLayer)
		UploadResourceGroup("BagRes")
		UploadResourceGroup("SmallArts")
		GUI:getLayer("Bag"):getWidget("Bag"):AcceptMessage( Message("Upload") )
		Screen:pushLayer( GUI:getLayer("Bag") )
		GUI:getLayer("Bag"):getWidget("Bag"):AcceptMessage( Message("OpenBook") )
		GUI:getLayer("Bag"):getWidget("Bag"):AcceptMessage( Message("ShowPanel") )
		gameInfo:Save()
	elseif message:is("SetMapLayer") then
		Sound:FadeOutAllTracks(1.0)
		Sound:FadeInTrack("Map", 2.0, true)
		GUI:getLayer(gameLayer):getWidget("Background"):AcceptMessage( Message("SoundOff") )
		Screen:Clear()
		UploadResourceGroup("Map")
		Screen:pushLayer( GUI:getLayer("Map") )
		GUI:getLayer("StageLayer_1"):getWidget("gameFrame"):AcceptMessage(Message("setScale", "1.0"));
		GUI:getLayer("StageLayer_2"):getWidget("gameFrame"):AcceptMessage(Message("setScale", "1.0"));
		GUI:getLayer("StageLayer_3"):getWidget("gameFrame"):AcceptMessage(Message("setScale", "1.0"));
		GUI:getLayer("StageLayer_4"):getWidget("gameFrame"):AcceptMessage(Message("setScale", "1.0"));
		GUI:getLayer("StageLayer_5"):getWidget("gameFrame"):AcceptMessage(Message("setScale", "1.0"));
		GUI:getLayer("StageLayer_6"):getWidget("gameFrame"):AcceptMessage(Message("setScale", "1.0"));
		GUI:getLayer("StageLayer_7"):getWidget("gameFrame"):AcceptMessage(Message("setScale", "1.0"));
	elseif message:is("SwitchToMapNewCountry") then
		Sound:FadeOutAllTracks(1.0)
		Sound:FadeInTrack("Map", 2.0, true)
		GUI:getLayer(gameLayer):getWidget("Background"):AcceptMessage( Message("SoundOff") )
		param = VariableSet()
		param:setString("Layer1", "Map");
		param:setString("EndHandler", "AddMarka");
		kernel:addController(controlFactory:Create("CrossFade", param))			
		Sound:FadeOutAllTracks(1.0)
		Sound:FadeInTrack("Menu", 2.0, true)
	elseif message:is("ShowLoseLife") then
		param = VariableSet()
		param:setString("Layer", "LoseLife")
		kernel:addController(controlFactory:Create("FadePushSlider", param))	
	elseif message:is("ShowGameOver") then
		needShowDialog = true
		param = VariableSet()
		param:setString("Layer", "GameOver")
		kernel:addController(controlFactory:Create("FadePushSlider", param))	
	elseif message:is("ShowStartLevelDialog") then
		ShowStartLevelDialog()	
	elseif message:is("CrossToBag") then
		Sound:FadeOutAllTracks(1.0)
		GUI:getLayer(gameLayer):getWidget("Background"):AcceptMessage( Message("SoundOff") )
		addArtefact = message:getIntegerParam()
		param = VariableSet()
		param:setString("Layer1", "Bag");
		param:setString("CrossHandler", "CompleteLevelCrossBagCross");
		param:setString("EndHandler", "CompleteLevelCrossBagEnd");
		kernel:addController(controlFactory:Create("CrossFade", param))			
	elseif message:is("ShowStatistics") then
		local statWidget = GUI:getLayer("Statistics"):getWidget("GameStatistics")
		statWidget:setColor(Color(255, 255, 255, 0))

		local fadeWidget = GUI:getLayer("Fade"):getWidget("Fade")
		fadeWidget:setColor(Color(0, 0, 0, 0))

		local param = VariableSet()
		param:setWidget("Widget", statWidget)
		param:setColor("To", Color(255, 255, 255, 255))
		kernel:addController(controlFactory:Create("Fader", param))

		param = VariableSet()
		param:setWidget("Widget", fadeWidget)
		param:setColor("To", Color(0, 0, 0, 128))
		kernel:addController(controlFactory:Create("Fader", param))

		Screen:pushLayer(GUI:getLayer("Fade"))
		Screen:pushLayer(GUI:getLayer("Statistics"))
		
		statWidget:AcceptMessage(Message("Start"))
	elseif message:is("RunFinalDialog") then
		Screen:pushLayer( GUI:getLayer("Dialog") )
		GUI:getLayer("Dialog"):getWidget("Dialog"):AcceptMessage( Message("Run", "Dlg_82") )
	else
		GUI:getLayer(gameLayer):getWidget("GameField"):AcceptMessage( message )
	end
end

function CompleteLevelCrossBagCross()
	GUI:getLayer("Bag"):getWidget("Bag"):AcceptMessage( Message("Upload") )
	UploadResourceGroup("BagRes")
	UploadResourceGroup("SmallArts")
	GUI:getLayer("Bag"):getWidget("Bag"):AcceptMessage( Message("OpenBook") )
	GUI:getLayer("Bag"):getWidget("Bag"):AcceptMessage( Message("ShowPanel") )
	Sound:FadeInTrack("Bag", 2.0, true)

	gameInfo:Save()
end

function CompleteLevelCrossBagEnd()
	GUI:getLayer("Bag"):getWidget("Bag"):AcceptMessage( Message("AddArtefact", addArtefact) )
end

function AddMarka()
	GUI:getLayer("Map"):getWidget("Map"):AcceptMessage(Message("AddMarka"))
	GUI:getLayer("Map"):getWidget("Map"):AcceptMessage(Message("ShowPanel"))
end

function ArtCutterFunc(message)
	GUI:getLayer(gameLayer):getWidget("GameField"):AcceptMessage( message )
end

function MapFunc(message)
	if message:is("continue", "press") then
		if (gameInfo:getLevel() == 1)and(sucFromGame == false)and(needShowDialog) then
			UpdateGameLayerName()
--			needShowDialog = true
			StartGame()
		elseif (gameInfo:getStage() == 7)and(gameInfo:getLevel() == 14) then
			UpdateGameLayerName()
			StartGame()
		else
			GUI:getLayer("Bag"):getWidget("Bag"):AcceptMessage(Message("InitBagView"))
			GUI:getLayer("Map"):getWidget("Map"):AcceptMessage(Message("HidePanel"))
			param = VariableSet()
			param:setString("Layer1", "Bag");
			param:setString("CrossHandler", "MapToSuc");
			kernel:addController(controlFactory:Create("CrossFade", param))	
			Sound:FadeOutAllTracks(1.0)
		end
	elseif message:is("menu", "press") then
		creditsCallingLayer = "Map"
		menuInGame = false
--		GUI:getLayer(gameLayer):getWidget("Background"):AcceptMessage( Message("SoundOff") )
--		GUI:getLayer(gameLayer):getWidget("GameField"):AcceptMessage(Message("Pause"))
--		GUI:getLayer(gameLayer):getWidget("GameField"):AcceptMessage( Message("SetActive", 0) )
		param = VariableSet()
		param:setString("Layer", "MenuInGame");
		kernel:addController(controlFactory:Create("FadePushSlider", param))

--		GUI:getLayer("Map"):getWidget("Map"):AcceptMessage(Message("HidePanel"))
--		param = VariableSet()
--		param:setString("Layer1", "MainMenu");
--		param:setString("CrossHandler", "ToMainMenuCross")
--		kernel:addController(controlFactory:Create("CrossFade", param))
--		Sound:FadeOutAllTracks(1.0)
	elseif message:is("MarkaWinLeftArrow", "press") then
		GUI:getLayer("Map"):getWidget("Map"):AcceptMessage(Message("MarkaWinLeftArrowPress"))
	elseif message:is("MarkaWinRightArrow", "press") then
		GUI:getLayer("Map"):getWidget("Map"):AcceptMessage(Message("MarkaWinRightArrowPress"))
	elseif message:is("MarkaWinOk", "press") then
		GUI:getLayer("Map"):getWidget("Map"):AcceptMessage(Message("MarkaWinOkPress"))
	elseif message:is("LeftArrow", "down") then
		GUI:getLayer("Map"):getWidget("Map"):AcceptMessage(Message("LeftArrowDown"))
	elseif message:is("RightArrow", "down") then
		GUI:getLayer("Map"):getWidget("Map"):AcceptMessage(Message("RightArrowDown"))
	elseif message:is("SwitchToBag") then
		Screen:pushLayer( GUI:getLayer("Bag") )
		GUI:getLayer("Map"):getWidget("Map"):AcceptMessage( Message("ResetBagFly") )
		GUI:getLayer("Bag"):getWidget("Bag"):AcceptMessage( Message("OpenBook") )
	elseif message:is("ShowHint") then
		Screen:pushLayer( GUI:getLayer("Hint") )
	elseif message:is("ShowCountryIntro") then
		GUI:getLayer("StageLayer_1"):getWidget("GameField"):AcceptMessage( Message("DisableRain") )
		GUI:getLayer("Dialog"):getWidget("Dialog"):AcceptMessage( Message("Reset") )
		countryIntro = true
		countryIntroLayerName = message:getVariables():getString("gameLayer");
		countryIntroDialogName = message:getVariables():getString("dialogName");
		param = VariableSet()
		param:setString("Layer1", countryIntroLayerName);
		param:setString("Layer2", "Dialog");
		param:setString("CrossHandler", "CountryIntroCross")
		kernel:addController(controlFactory:Create("CrossFade", param))
		Sound:FadeOutAllTracks(1.0)
		countryIntroReturnLayer = "Map"
	else
		GUI:getLayer("Map"):getWidget("Map"):AcceptMessage( message )
	end
end

function CountryIntroCross()
	UploadResourceGroup("Clouds")
	UploadResourceGroup("Game")
	GUI:getLayer(countryIntroLayerName):getWidget("GameField"):AcceptMessage( Message("SetCountryIntroMode", 1) )
	GUI:getLayer(countryIntroLayerName):getWidget("Background"):AcceptMessage( Message("SoundOn") )
	GUI:getLayer(countryIntroLayerName):getWidget("Background"):AcceptMessage( Message("StoreTime") )
	GUI:getLayer(countryIntroLayerName):getWidget("Background"):AcceptMessage( Message("SetTime", "0") )
	GUI:getLayer("Dialog"):getWidget("Dialog"):AcceptMessage( Message("Run", countryIntroDialogName) )
	PlayStageMusic(countryIntroLayerName)
end

function CountryIntroExitCross()
	Sound:FadeOutAllTracks(1.0)
	countryIntro = false
	if (countryIntroReturnLayer == "Map") then
		ReleaseResourceGroup("Clouds")
		ReleaseResourceGroup("Game")
	end
	GUI:getLayer(countryIntroLayerName):getWidget("GameField"):AcceptMessage( Message("SetCountryIntroMode", 0) )
	GUI:getLayer(countryIntroLayerName):getWidget("Background"):AcceptMessage( Message("RestoreTime") )
	GUI:getLayer(countryIntroLayerName):getWidget("Background"):AcceptMessage( Message("SoundOff") )
	
	if (countryIntroReturnLayer == "Bag") then
		Sound:FadeInTrack("Bag", 2.0, true)
		GUI:getLayer("Bag"):getWidget("Bag"):AcceptMessage( Message("ReturnFromIntro") )
	else
		Sound:FadeInTrack("Map", 2.0, true)
	end
end

function MapToSuc()
	UploadResourceGroup("Game")
	UploadResourceGroup("Clouds")
	UploadResourceGroup("Bonus")
	UploadResourceGroup("BagRes")
	GUI:getLayer("Bag"):getWidget("Bag"):AcceptMessage( Message("UpdateArtLights") )
	GUI:getLayer("Bag"):getWidget("Bag"):AcceptMessage( Message("ShowPanel") )
	GUI:getLayer("Bag"):getWidget("Bag"):AcceptMessage( Message("Upload") )
	Sound:FadeInTrack("Bag", 3.0, true)	
end

function RunDialogInBag()
	GUI:getLayer("Bag"):getWidget("Bag"):AcceptMessage( Message("RunDialog") )
end

function setSucFromGame()
	GUI:getLayer("Bag"):getWidget("Bag"):AcceptMessage( Message("SetBackButton") )
	sucFromGame = true
end

function resetSucFromGame()
	GUI:getLayer("Bag"):getWidget("Bag"):AcceptMessage( Message("SetPlayButton") )
	sucFromGame = false
end

function setSucFromMap()
	sucFromMap = false
end

function resetSucFromMap()
	sucFromMap = false
end

function MapCrossHandler()
	ReleaseResourceGroup("Game")
	ReleaseResourceGroup("Clouds")
	ReleaseResourceGroup("Bonus")
	ReleaseResourceGroup("BagRes")
	UploadResourceGroup("SmallArts")	
--	if (sucFromGame == false) then
		Sound:FadeOutAllTracks(1.0)
		Sound:FadeInTrack("Map", 2.0, true)
--	end
	GUI:getLayer("Map"):getWidget("Map"):AcceptMessage(Message("InitView"))
end

function ShowMapHint()
	GUI:getLayer("Map"):getWidget("Map"):AcceptMessage( Message("ShowHint") )
end

function SucFunc(message)
	if message:is("ViewMap", "press") then
		param = VariableSet()
		param:setString("Layer1", "Map");
		param:setString("EndHandler", "ShowMapHint")
		param:setString("CrossHandler", "MapCrossHandler")
		kernel:addController(controlFactory:Create("CrossFade", param))	
		GUI:getLayer("Bag"):getWidget("Bag"):AcceptMessage( Message("HidePanel") )
	elseif message:is("Start", "press") then
		GUI:getLayer("Bag"):getWidget("Bag"):AcceptMessage( Message("HidePanel") )
		UpdateGameLayerName()
		if (sucFromGame == true) then
			GUI:getLayer("Bag"):getWidget("Bag"):AcceptMessage(Message("CloseBook", "BackToGame"))
			GUI:getLayer("Bag"):getWidget("Bag"):AcceptMessage(Message("HideArtLine"))
		else
			if (gameInfo:getLevel() > 1) then
				needShowDialog = true
			end
			StartGame();	
		end
	elseif message:is("Menu", "press") then
		creditsCallingLayer = "Bag"
		menuInGame = false
--		GUI:getLayer(gameLayer):getWidget("Background"):AcceptMessage( Message("SoundOff") )
--		GUI:getLayer(gameLayer):getWidget("GameField"):AcceptMessage(Message("Pause"))
--		GUI:getLayer(gameLayer):getWidget("GameField"):AcceptMessage( Message("SetActive", 0) )
		param = VariableSet()
		param:setString("Layer", "MenuInGame");
		kernel:addController(controlFactory:Create("FadePushSlider", param))

--		param = VariableSet()
--		param:setString("Layer1", "MainMenu");
--		param:setString("CrossHandler", "ToMainMenuCross")
--		kernel:addController(controlFactory:Create("CrossFade", param))			
--		GUI:getLayer("Bag"):getWidget("Bag"):AcceptMessage( Message("HidePanel") )
--		Sound:FadeOutAllTracks(1.0)
	elseif message:is("back", "press") then
		resetSucFromMap()
		GUI:getLayer("Bag"):getWidget("Bag"):AcceptMessage(Message("CloseBook", "BackToMap"))
		GUI:getLayer("Bag"):getWidget("Bag"):AcceptMessage(Message("HideArtLine"))
	elseif message:is("BackToGame") then
		resetSucFromGame()
		Screen:Clear()
		GUI:getLayer("Bag"):getWidget("Bag"):AcceptMessage( Message("Release") )
		ReleaseResourceGroup("BagRes")
		ReleaseResourceGroup("SmallArts")
		UploadResourceGroup(gameLayer)
		UploadResourceGroup("Game")
		UploadResourceGroup("Bonus")
		Screen:pushLayer( GUI:getLayer(gameLayer) );

		GUI:getLayer(gameLayer):getWidget("GameField"):AcceptMessage(Message("ReturnFromSuc"))	
		Sound:FadeOutAllTracks(1.0)
		GUI:getLayer(gameLayer):getWidget("Background"):AcceptMessage( Message("SoundOn") )
		GUI:getLayer(gameLayer):getWidget("GameField"):AcceptMessage(Message("StartLevelMusicAfterBag"))
	elseif message:is("BackToMap") then
		Screen:popLayer()
		GUI:getLayer("Map"):getWidget("Map"):AcceptMessage(Message("ReturnFromBag"))
	elseif message:is("ShowDialog") then
		Screen:pushLayer( GUI:getLayer("Dialog") );
		GUI:getLayer("Dialog"):getWidget("Dialog"):AcceptMessage( Message("Run", message:getData()) )
	elseif message:is("RunDialog") then
		GUI:getLayer("Bag"):getWidget("Bag"):AcceptMessage(Message("RunDialog"))
	elseif message:is("ShowCountryIntro") then
		GUI:getLayer("Dialog"):getWidget("Dialog"):AcceptMessage( Message("Reset") )
		countryIntro = true
		countryIntroLayerName = message:getVariables():getString("gameLayer");
		countryIntroDialogName = message:getVariables():getString("dialogName");
		param = VariableSet()
		param:setString("Layer1", countryIntroLayerName);
		param:setString("Layer2", "Dialog");
		param:setString("CrossHandler", "CountryIntroCross")
		kernel:addController(controlFactory:Create("CrossFade", param))
		Sound:FadeOutAllTracks(1.0)
		countryIntroReturnLayer = "Bag"
	else
		GUI:getLayer("Bag"):getWidget("Bag"):AcceptMessage(message)
	end
end

function MapEndHandler()
	if (gameInfo:isNeedShowFinalTextOnMap()) then

		local panelWidget = GUI:getLayer("CycleCompletedLayer"):getWidget("Panel")
		panelWidget:setColor(Color(255, 255, 255, 0))

		local fadeWidget = GUI:getLayer("Fade3"):getWidget("Fade3")
		fadeWidget:setColor(Color(0, 0, 0, 0))

		local param = VariableSet()
		param:setWidget("Widget", panelWidget)
		param:setColor("To", Color(255, 255, 255, 255))
		kernel:addController(controlFactory:Create("Fader", param))

		param = VariableSet()
		param:setWidget("Widget", fadeWidget)
		param:setColor("To", Color(0, 0, 0, 150))
		kernel:addController(controlFactory:Create("Fader", param))

		Screen:pushLayer(GUI:getLayer("Fade3"))
		Screen:pushLayer(GUI:getLayer("CycleCompletedLayer"))		
	end

	GUI:getLayer("Map"):getWidget("Map"):AcceptMessage(Message("InitLighting"))
	
end

function CycleCompletedFunc(message)
	if message:is("Ok", "press") then
		local panelWidget = GUI:getLayer("CycleCompletedLayer"):getWidget("Panel")
		local fadeWidget = GUI:getLayer("Fade3"):getWidget("Fade3")

		param = VariableSet()
		param:setWidget("Widget", panelWidget)
		param:setColor("To", Color(255, 255, 255, 0))
		param:setBool("PopLayer", true)
		kernel:addController(controlFactory:Create("Fader", param))

		param = VariableSet()
		param:setWidget("Widget", fadeWidget)
		param:setColor("To", Color(0, 0, 0, 0))
		param:setBool("PopLayer", true)
		param:setString("EndHandler", "RunNextCycleOnMap")
		kernel:addController(controlFactory:Create("Fader", param))
	end
end

function RunNextCycleOnMap()
	gameInfo:setNeedShowFinalTextOnMap(false)
	GUI:getLayer("Map"):getWidget("Map"):AcceptMessage( Message("RunNextCycle") )
end

function StatFunc(message)
	if message:is("Ok", "press") then
		if (gameInfo:IsGameOver() == true) then
			Sound:FadeOutAllTracks(1.0)
			Sound:FadeInTrack("Menu", 3.0, true)
			param = VariableSet()
			param:setString("Layer1", "Menu")
			kernel:addController(controlFactory:Create("CrossFade", param))
		else
--			Sound:FadeOutAllTracks(3.0)
--			Sound:FadeInTrack("Map", 3.0, true)
			
--			IncrementTip()
			param = VariableSet()
--			param:setString("Layer1", "Map")
--			param:setString("Layer1", "Bag")
--			param:setString("CrossHandler", "StatCrossHandler")
--			kernel:addController(controlFactory:Create("CrossFade", param))
			Screen:popLayer()
			Screen:popLayer()
			GUI:getLayer(gameLayer):getWidget("GameField"):AcceptMessage( Message("RunArtefactCollecting") )
			
		end
	else 
		GUI:getLayer(gameLayer):getWidget("GameField"):AcceptMessage( message )
	end
end

function StatCrossHandler()
	gameInfo:WriteResultToHiScores()
	if (gameInfo:IsGameOver() == true) then
		gameInfo:setScore(0)
		gameInfo:setUID()
	end
	gameInfo:Save()
	GUI:getLayer("Map"):getWidget("Map"):AcceptMessage( Message("ShowPanel") )	
end

function ProfileFunc(message)

	if message:is("Names", "DoubleClick") then
		local state = GUI:getLayer("Profiles"):getWidget("Names"):AcceptMessage(Message("SetNeedHideHint", 1))
		Sound:PlaySample("ButtonClick", 1.0)
		GUI:getLayer("Map"):getWidget("Map"):AcceptMessage(Message("InitVars"))
	end

	if message:is("Cancel", "press") then

		param = VariableSet()
		param:setInt("Type", 2)
		kernel:addController(controlFactory:Create("FadePopSlider", param))
		
		--optionsWidget:AddEffect("WindowShow")

	elseif message:is("Ok", "press") or message:is("Names", "DoubleClick") then
	
--		GUI:getLayer("Menu"):getWidget("1_MenuEffect"):AcceptMessage(Message("HideSaverTip"))
--		GUI:getLayer("Menu"):getWidget("1_MenuEffect"):AcceptMessage(Message("EndGemEffects"))

		param = VariableSet()
		param:setInt("Type", 2)
		kernel:addController(controlFactory:Create("FadePopSlider", param))

		local state = GUI:getLayer("Profiles"):getWidget("Names"):QueryState(Message("CurrentItem"))
		local playerName = state:getData()

		gameInfo:setActivePlayer(playerName)
		SetShowHints()
		GUI:getLayer("MainMenu"):getWidget("profileButton"):AcceptMessage(Message("SetProfile", playerName))
		GUI:getLayer("Map"):getWidget("Map"):AcceptMessage(Message("InitVars"))

		--optionsWidget:AddEffect("WindowShow")
	elseif message:is("0_Up", "press") then
		local namesWidget = GUI:getLayer("Profiles"):getWidget("Names")
		namesWidget:AcceptMessage(Message("ScrollDown"))
	elseif message:is("0_Down", "press") then
		local namesWidget = GUI:getLayer("Profiles"):getWidget("Names")
		namesWidget:AcceptMessage(Message("ScrollUp"))
	elseif message:is("New", "press") then

--    		GUI:getLayer("NewProfile"):getWidget("InfoText"):AcceptMessage(Message("SetString", "maximum 12 characters"))
		GUI:getLayer("NewProfile"):getWidget("Name"):AcceptMessage(Message("Clear"))

		local panelWidget = GUI:getLayer("NewProfile"):getWidget("Panel")
		panelWidget:setColor(Color(255, 255, 255, 0))

		local fadeWidget = GUI:getLayer("Fade3"):getWidget("Fade3")
		fadeWidget:setColor(Color(0, 0, 0, 0))

		local param = VariableSet()
		param:setWidget("Widget", panelWidget)
		param:setColor("To", Color(255, 255, 255, 255))
		kernel:addController(controlFactory:Create("Fader", param))

		param = VariableSet()
		param:setWidget("Widget", fadeWidget)
		param:setColor("To", Color(0, 0, 0, 150))
		kernel:addController(controlFactory:Create("Fader", param))

		Screen:pushLayer(GUI:getLayer("Fade3"))
		Screen:pushLayer(GUI:getLayer("NewProfile"))

	elseif message:is("Delete", "press") then
		
		local needDeletePlayer = true
		local needCheckActive = true
		
		local state = GUI:getLayer("Profiles"):getWidget("Names"):QueryState(Message("CurrentItem"))
		local playerName = state:getData()

		if gameInfo:getNumberOfPlayers() == 1 then
			local panelWidget = GUI:getLayer("LastNoDelete"):getWidget("Panel")
			panelWidget:setColor(Color(255, 255, 255, 0))
	
			local fadeWidget = GUI:getLayer("Fade3"):getWidget("Fade3")
			fadeWidget:setColor(Color(0, 0, 0, 0))
	
			local param = VariableSet()
			param:setWidget("Widget", panelWidget)
			param:setColor("To", Color(255, 255, 255, 255))
			kernel:addController(controlFactory:Create("Fader", param))
	
			param = VariableSet()
			param:setWidget("Widget", fadeWidget)
			param:setColor("To", Color(0, 0, 0, 150))
			kernel:addController(controlFactory:Create("Fader", param))
	
			Screen:pushLayer(GUI:getLayer("Fade3"))
			Screen:pushLayer(GUI:getLayer("LastNoDelete"))
			
			needDeletePlayer = false
			needCheckActive = false
		end

		if needCheckActive and (gameInfo:getName() == playerName) then

			local panelWidget = GUI:getLayer("ActiveNoDelete"):getWidget("Panel")
			panelWidget:setColor(Color(255, 255, 255, 0))
	
			local fadeWidget = GUI:getLayer("Fade3"):getWidget("Fade3")
			fadeWidget:setColor(Color(0, 0, 0, 0))
	
			local param = VariableSet()
			param:setWidget("Widget", panelWidget)
			param:setColor("To", Color(255, 255, 255, 255))
			kernel:addController(controlFactory:Create("Fader", param))
	
			param = VariableSet()
			param:setWidget("Widget", fadeWidget)
			param:setColor("To", Color(0, 0, 0, 150))
			kernel:addController(controlFactory:Create("Fader", param))
	
			Screen:pushLayer(GUI:getLayer("Fade3"))
			Screen:pushLayer(GUI:getLayer("ActiveNoDelete"))
			
			needDeletePlayer = false
		end

		if needDeletePlayer then

			GUI:getLayer("DeletePlayerConfirm"):getWidget("PlayerName"):AcceptMessage(Message("SetString", playerName))

			local panelWidget = GUI:getLayer("DeletePlayerConfirm"):getWidget("Panel")
			panelWidget:setColor(Color(255, 255, 255, 0))
	
			local fadeWidget = GUI:getLayer("Fade3"):getWidget("Fade3")
			fadeWidget:setColor(Color(0, 0, 0, 0))
	
			local param = VariableSet()
			param:setWidget("Widget", panelWidget)
			param:setColor("To", Color(255, 255, 255, 255))
			kernel:addController(controlFactory:Create("Fader", param))
	
			param = VariableSet()
			param:setWidget("Widget", fadeWidget)
			param:setColor("To", Color(0, 0, 0, 150))
			kernel:addController(controlFactory:Create("Fader", param))
	
			Screen:pushLayer(GUI:getLayer("Fade3"))
			Screen:pushLayer(GUI:getLayer("DeletePlayerConfirm"))
		
		end

	end


end

function NewProfileFunc(message)

	if message:is("Cancel", "press") then

		local panelWidget = GUI:getLayer("NewProfile"):getWidget("Panel")
		local fadeWidget = GUI:getLayer("Fade3"):getWidget("Fade3")

		param = VariableSet()
		param:setWidget("Widget", panelWidget)
		param:setColor("To", Color(255, 255, 255, 0))
		param:setBool("PopLayer", true)
		kernel:addController(controlFactory:Create("Fader", param))

		param = VariableSet()
		param:setWidget("Widget", fadeWidget)
		param:setColor("To", Color(0, 0, 0, 0))
		param:setBool("PopLayer", true)
		kernel:addController(controlFactory:Create("Fader", param))

		--optionsWidget:AddEffect("WindowShow")

	elseif message:is("Ok", "press") then

		state = GUI:getLayer("NewProfile"):getWidget("Name"):QueryState(Message("Text"))
		local profileName = state:getData()

		if not (profileName == "") then

			needShowDialog = true
			if gameInfo:isPlayerExist(profileName) then
                		GUI:getLayer("NewProfile"):getWidget("InfoText"):AcceptMessage(Message("SetString", "player already exist!"))
                	else
				GUI:getLayer("MainMenu"):getWidget("profileButton"):AcceptMessage(Message("SetProfile", profileName))
--				local prologueCaption = profileName.."!"
--				GUI:getLayer("History"):getWidget("Prologue"):AcceptMessage(Message("SetString", prologueCaption))
				GUI:getLayer("MainMenu"):getWidget("profileButton"):AcceptMessage(Message("SetProfile", profileName))
				GUI:getLayer("Profiles"):getWidget("Names"):AcceptMessage(Message("Add", profileName))
				gameInfo:AddNewPlayer(profileName)
				GUI:getLayer("Map"):getWidget("Map"):AcceptMessage(Message("InitVars"))
				SetShowHints()
				
				GUI:getLayer("Bag"):getWidget("Bag"):AcceptMessage(Message("InitNoteView", profileName))

	               		--historyButton = GUI:getLayer("History"):getWidget("Next")
	        	       	--historyButton:AcceptMessage(Message("SetText", "Next"))

--				param = VariableSet()
--				param:setString("CrossHandler", "HistoryUpload")
--				param:setString("Layer1", "History")
--				param:setString("EndHandler", "HistoryReset")
--				kernel:addController(controlFactory:Create("CrossFade", param))


--				local panelWidget = GUI:getLayer("NewProfile"):getWidget("Panel")
--				local fadeWidget = GUI:getLayer("Fade3"):getWidget("Fade3")

--				param = VariableSet()
--				param:setWidget("Widget", panelWidget)
--				param:setColor("To", Color(255, 255, 255, 0))
--				param:setBool("PopLayer", true)
--				kernel:addController(controlFactory:Create("Fader", param))

--				param = VariableSet()
--				param:setWidget("Widget", fadeWidget)
--				param:setColor("To", Color(0, 0, 0, 0))
--				param:setBool("PopLayer", true)
--				kernel:addController(controlFactory:Create("Fader", param))

				param = VariableSet()
--				param:setFloat("TimeScale", 1.0)
--				param:setFloat("TimeScale2", 0.5)
				param:setString("Layer1", "JuleBook")
				param:setString("EndHandler", "StartIntro")
				param:setString("CrossHandler", "UploadIntro")
				Sound:FadeOutAllTracks(1.0)

				kernel:addController(controlFactory:Create("CrossFade", param))

			end

		end
	end
end

function FirstProfileFunc(message)

	if message:is("Ok", "press") then

		state = GUI:getLayer("FirstProfile"):getWidget("Name"):QueryState(Message("Text"))
		local profileName = state:getData()

		if not (profileName == "") then

			local panelWidget = GUI:getLayer("FirstProfile"):getWidget("Panel")
			local fadeWidget = GUI:getLayer("Fade3"):getWidget("Fade3")

			param = VariableSet()
			param:setWidget("Widget", panelWidget)
			param:setColor("To", Color(255, 255, 255, 0))
			param:setBool("PopLayer", true)
			kernel:addController(controlFactory:Create("Fader", param))

			param = VariableSet()
			param:setWidget("Widget", fadeWidget)
			param:setColor("To", Color(0, 0, 0, 0))
			param:setBool("PopLayer", true)
			kernel:addController(controlFactory:Create("Fader", param))
	
			GUI:getLayer("MainMenu"):getWidget("profileButton"):AcceptMessage(Message("SetProfile", profileName))
			GUI:getLayer("MainMenu"):getWidget("profileButton"):AcceptMessage(Message("SetProfile", profileName))
			GUI:getLayer("Profiles"):getWidget("Names"):AcceptMessage(Message("Add", profileName))
			gameInfo:AddNewPlayer(profileName)
			GUI:getLayer("Map"):getWidget("Map"):AcceptMessage(Message("InitVars"))
			SetShowHints()
				
			GUI:getLayer("Bag"):getWidget("Bag"):AcceptMessage(Message("InitNoteView", profileName))
		end
	end
end

function UploadIntro()
	UploadResourceGroup("Intro");
	UploadResourceGroup("IntroMenu");
	GUI:getLayer("JuleBook"):getWidget("JuleBook"):AcceptMessage( Message("Upload") )
	GUI:getLayer("JuleBook"):getWidget("JuleBook"):AcceptMessage( Message("StartIntroForNewPlayer") )
end

function StartIntro()
end


function ActiveDeleteMessageFunc(message)

	if message:is("Ok", "press") then

		local panelWidget = GUI:getLayer("ActiveNoDelete"):getWidget("Panel")
		local fadeWidget = GUI:getLayer("Fade3"):getWidget("Fade3")

		param = VariableSet()
		param:setWidget("Widget", panelWidget)
		param:setColor("To", Color(255, 255, 255, 0))
		param:setBool("PopLayer", true)
		kernel:addController(controlFactory:Create("Fader", param))

		param = VariableSet()
		param:setWidget("Widget", fadeWidget)
		param:setColor("To", Color(0, 0, 0, 0))
		param:setBool("PopLayer", true)
		kernel:addController(controlFactory:Create("Fader", param))

	end

end

function LastDeleteMessageFunc(message)

	if message:is("Ok", "press") then

		local panelWidget = GUI:getLayer("LastNoDelete"):getWidget("Panel")
		local fadeWidget = GUI:getLayer("Fade3"):getWidget("Fade3")

		param = VariableSet()
		param:setWidget("Widget", panelWidget)
		param:setColor("To", Color(255, 255, 255, 0))
		param:setBool("PopLayer", true)
		kernel:addController(controlFactory:Create("Fader", param))

		param = VariableSet()
		param:setWidget("Widget", fadeWidget)
		param:setColor("To", Color(0, 0, 0, 0))
		param:setBool("PopLayer", true)
		kernel:addController(controlFactory:Create("Fader", param))

	end

end

function NoBackgroundsSelectedFunc(message)

	if message:is("Ok", "press") then

		local panelWidget = GUI:getLayer("NoBackgroundsSelected"):getWidget("Panel")
		local fadeWidget = GUI:getLayer("Fade3"):getWidget("Fade3")

		param = VariableSet()
		param:setWidget("Widget", panelWidget)
		param:setColor("To", Color(255, 255, 255, 0))
		param:setBool("PopLayer", true)
		kernel:addController(controlFactory:Create("Fader", param))

		param = VariableSet()
		param:setWidget("Widget", fadeWidget)
		param:setColor("To", Color(0, 0, 0, 0))
		param:setBool("PopLayer", true)
		kernel:addController(controlFactory:Create("Fader", param))

	end

end

function DeletePlayerFunc(message)

	if message:is("No", "press") then

		local panelWidget = GUI:getLayer("DeletePlayerConfirm"):getWidget("Panel")
		local fadeWidget = GUI:getLayer("Fade3"):getWidget("Fade3")

		param = VariableSet()
		param:setWidget("Widget", panelWidget)
		param:setColor("To", Color(255, 255, 255, 0))
		param:setBool("PopLayer", true)
		kernel:addController(controlFactory:Create("Fader", param))

		param = VariableSet()
		param:setWidget("Widget", fadeWidget)
		param:setColor("To", Color(0, 0, 0, 0))
		param:setBool("PopLayer", true)
		kernel:addController(controlFactory:Create("Fader", param))

	elseif message:is("Yes", "press") then

		local panelWidget = GUI:getLayer("DeletePlayerConfirm"):getWidget("Panel")
		local fadeWidget = GUI:getLayer("Fade3"):getWidget("Fade3")
		
		local state = GUI:getLayer("Profiles"):getWidget("Names"):QueryState(Message("CurrentItem"))
		local playerName = state:getData()

		if ( not(gameInfo:getName() == playerName) and not(gameInfo:getNumberOfPlayers() == 1)  ) then
			gameInfo:DeletePlayer(playerName)
			GUI:getLayer("Profiles"):getWidget("Names"):AcceptMessage(Message("Delete", playerName))
		end

		param = VariableSet()
		param:setWidget("Widget", panelWidget)
		param:setColor("To", Color(255, 255, 255, 0))
		param:setBool("PopLayer", true)
		kernel:addController(controlFactory:Create("Fader", param))

		param = VariableSet()
		param:setWidget("Widget", fadeWidget)
		param:setColor("To", Color(0, 0, 0, 0))
		param:setBool("PopLayer", true)
		kernel:addController(controlFactory:Create("Fader", param))
	end
end

function ExitConfirmFunc(message)

	if message:is("No", "press") then

		param = VariableSet()
		param:setInt("Type", 2)
		kernel:addController(controlFactory:Create("FadePopSlider", param))		

	elseif message:is("Yes", "press") then
		CloseApplication()
	end
end

function ExitConfirmWithSSFunc(message)

	if message:is("No", "press") then

		local state = GUI:getLayer("ExitConfirmWithSS"):getWidget("EnableScreensaver"):QueryState(Message("GetState"))
		if (state:getData() == "1") then
			gameInfo:EnableScreensaver()
		else
--			gameInfo:DisableScreensaver()
		end

		param = VariableSet()
		param:setInt("Type", 2)
		kernel:addController(controlFactory:Create("FadePopSlider", param))		

	elseif message:is("Yes", "press") then
		local state = GUI:getLayer("ExitConfirmWithSS"):getWidget("EnableScreensaver"):QueryState(Message("GetState"))
		if (state:getData() == "1") then
			gameInfo:EnableScreensaver()
		else
--			gameInfo:DisableScreensaver()
		end

		CloseApplication()
	end
end

function SSOptionsFunc(message)

	if message:is("Ok", "press") then
		gameInfo:ReadSSOptionsFromLayer()
		gameInfo:UpdateInstallSSInfo()
		param = VariableSet()
		param:setInt("Type", 1)
		kernel:addController(controlFactory:Create("FadePopSlider", param))
	end

	if message:is("Cancel", "press") then
		gameInfo:CopySSOptionsFromBuff()
		gameInfo:SetSSOptionsToLayer()
		param = VariableSet()
		param:setInt("Type", 1)
		kernel:addController(controlFactory:Create("FadePopSlider", param))
	end

	if message:is("Preview", "press") then
		gameInfo:ReadSSOptionsFromLayer()

		if (gameInfo:isAnyBackgroundSelected()) then
			GUI:getLayer("StageLayer_1"):getWidget("GameField"):AcceptMessage(Message("SetPreviewSSMode", 1))
			gameInfo:setPreviewSSMode(true)
			gameInfo:RunFirstScreensaverBG()
		else
			local panelWidget = GUI:getLayer("NoBackgroundsSelected"):getWidget("Panel")
			panelWidget:setColor(Color(255, 255, 255, 0))
	
			local fadeWidget = GUI:getLayer("Fade3"):getWidget("Fade3")
			fadeWidget:setColor(Color(0, 0, 0, 0))
	
			local param = VariableSet()
			param:setWidget("Widget", panelWidget)
			param:setColor("To", Color(255, 255, 255, 255))
			kernel:addController(controlFactory:Create("Fader", param))
	
			param = VariableSet()
			param:setWidget("Widget", fadeWidget)
			param:setColor("To", Color(0, 0, 0, 150))
			kernel:addController(controlFactory:Create("Fader", param))
	
			Screen:pushLayer(GUI:getLayer("Fade3"))
			Screen:pushLayer(GUI:getLayer("NoBackgroundsSelected"))
		end
	end

	if message:is("RunNextBackground") then
		param = VariableSet()
		param:setString("Layer1", message:getData())
		param:setString("CrossHandler", "UploadScreensaverBG")
		kernel:addController(controlFactory:Create("CrossFade", param))	
		Sound:FadeOutAllTracks(1.0)
		PlayStageMusic(message:getData())
	end
end

function UploadScreensaverBG()
	gameInfo:ResetRain()
	gameInfo:UploadScreensaverBG()
	UploadResourceGroup("Game")
	UploadResourceGroup("Clouds")
end

function ScreensaverFunc(message)
	if message:is("RunNextBackground") then
		param = VariableSet()
		param:setString("Layer1", message:getData())
		param:setString("CrossHandler", "UploadScreensaverBG")
		kernel:addController(controlFactory:Create("CrossFade", param))
	elseif message:is("ShutDown") then
		CloseApplication()
	end

end