LoadResource("fonts.xml")

LoadResource("GUI_Resource.xml")
LoadResource("Sound.xml")
LoadResource("Music.xml")

Sound:SetSoundVolume(100)
Sound:SetMusicVolume(20)

LoadResource("DialogResource.xml")
LoadResource("GameResource.xml")
LoadResource("SucResource.xml")
LoadResource("MapResource.xml")
LoadResource("MainMenuResource.xml")
LoadResource("ChipsAnim.xml")

LoadParticles("Candle.xml")
LoadEffects("Candle.xml")

LoadParticles("RainParticleEffect.xml")
LoadEffects("EgyptFlame.xml")
LoadEffects("IndiaFlame.xml")
LoadEffects("TimeBonus.xml")

LoadParticles("Sunset.xml")
LoadEffects("Sunset.xml")
LoadParticles("LondonPena.xml")
LoadEffects("LondonPena.xml")
LoadParticles("effects.xml")
LoadEffects("effects.xml")
LoadParticles("MapArrows.xml")
LoadEffects("MapArrows.xml")
LoadParticles("BagEffects.xml")
LoadEffects("BagEffects.xml")
LoadParticles("MenuEffects.xml")
LoadEffects("MenuEffects.xml")
LoadParticles("TakeBonusEff.xml")
LoadEffects("TakeBonusEff.xml")
LoadParticles("StringEffects.xml")
LoadEffects("StringEffects.xml")

LoadEffects("RainParticleEffect.xml")

LoadParticles("country_effects.xml")
LoadEffects("country_effects.xml")

--LoadParticles("fakel_eff.xml")
--LoadEffects("fakel_eff.xml")

LoadParticles("StatEffects.xml")
LoadEffects("StatEffects.xml")

--LoadParticles("StringEffects.xml")
--LoadEffects("StringEffects.xml")

GUI:LoadText("text.xml")

GUI:LoadLayers("JuleBook_GUI.xml")
GUI:LoadLayers("Menu_GUI.xml")
GUI:LoadLayers("Map_GUI.xml")
GUI:LoadLayers("Suc_GUI.xml")
GUI:LoadLayers("Stat_GUI.xml")
GUI:LoadLayers("MenuInGame_GUI.xml")
GUI:LoadLayers("TestLayer.xml")
GUI:LoadLayers("Dialog_GUI.xml")
GUI:LoadLayers("MainMenuGUI.xml")
GUI:LoadLayers("Gamefield_GUI.xml")
GUI:LoadLayers("Options_GUI.xml")
--GUI:LoadLayers("Screensaver_GUI.xml")
GUI:LoadLayers("Hint_GUI.xml")

--gameInfo:setLives(3)
--GUI:getLayer("Game"):getWidget("GameField"):AcceptMessage( Message("InitLevelView") )
--GUI:getLayer("Game"):getWidget("GameField"):AcceptMessage( Message("Start") )
--GUI:getLayer("Game"):getWidget("GameField"):AcceptMessage( Message("SetActive", 1) )

--Screen:pushLayer( GUI:getLayer("Statistics") )
--Screen:pushLayer( GUI:getLayer("Game") )
--Sound:FadeInTrack("Menu", 2.0, true)

--Screen:pushLayer( GUI:getLayer("Map") )

local sndVolume = gameInfo:getSoundVolume()
local musVolume = gameInfo:getMusicVolume()

Sound:SetSoundVolume(sndVolume)
Sound:SetMusicVolume(musVolume)

local iFullscreen = "0"
if gameInfo:getFullscreen() then
	iFullscreen = "1"
end

local iCCursor = "0"
if gameInfo:getCustomCursor() then
	iCCursor = "1"
end

GUI:getLayer("Map"):getWidget("Map"):AcceptMessage(Message("InitVars"))
GUI:getLayer("MainMenu"):getWidget("MainMenu"):AcceptMessage(Message("Init"))


function UploadGameIntro()
	UploadResourceGroup("BagRes");
	UploadResourceGroup("Intro");
	UploadResourceGroup("MainMenu");
	UploadResourceGroup("Clouds");
	GUI:getLayer("JuleBook"):getWidget("JuleBook"):AcceptMessage( Message("StartIntro") )
end

function SetShowHints()
	if gameInfo:getHintsEnabled() then
		GUI:getLayer("Options"):getWidget("ATips"):AcceptMessage(Message("SetState", "1"))
	else
		GUI:getLayer("Options"):getWidget("ATips"):AcceptMessage(Message("SetState", "0"))
	end
end

if not gameInfo:NoPlayers() then

	local namesWidget = GUI:getLayer("Profiles"):getWidget("Names")
	local numOfPlayers = gameInfo:getNumberOfPlayers()-1
	for i = 0, numOfPlayers do
		local playerName = gameInfo:getPlayerName(i)
		namesWidget:AcceptMessage(Message("Add", playerName))
	end

	namesWidget:AcceptMessage(Message("Select", gameInfo:getName()))
	GUI:getLayer("MainMenu"):getWidget("profileButton"):AcceptMessage(Message("SetProfile", gameInfo:getName()))
	SetShowHints()
end

GUI:getLayer("Options"):getWidget("Music"):AcceptMessage(Message("SetPos", tostring(musVolume)))
GUI:getLayer("Options"):getWidget("Sound"):AcceptMessage(Message("SetPos", tostring(sndVolume)))
GUI:getLayer("Options"):getWidget("Fullscreen"):AcceptMessage(Message("SetState", iFullscreen))
GUI:getLayer("Options"):getWidget("CustomCursor"):AcceptMessage(Message("SetState", iCCursor))

if (false) then
	GUI:getLayer("TestLayer"):getWidget("GameField"):AcceptMessage( Message("InitLevelView") )
	GUI:getLayer("TestLayer"):getWidget("GameField"):AcceptMessage( Message("Start") )
	GUI:getLayer("TestLayer"):getWidget("GameField"):AcceptMessage( Message("SetActive", 1) )
	GUI:getLayer("TestLayer"):getWidget("GameField"):AcceptMessage( Message("FillLevelList", 1) )
	Screen:pushLayer( GUI:getLayer("TestLayer") )
else
	Sound:FadeInTrack("Menu", 2.0, true)

	stage = gameInfo:getStage()
	gameInfo:setStage(1)
	GUI:getLayer("StageLayer_1"):getWidget("GameField"):AcceptMessage( Message("FillLevelList", 1) )
	GUI:getLayer("StageLayer_1"):getWidget("GameField"):AcceptMessage( Message("HideShowLevelList") )
	gameInfo:setStage(2)
	GUI:getLayer("StageLayer_2"):getWidget("GameField"):AcceptMessage( Message("FillLevelList", 1) )
	GUI:getLayer("StageLayer_2"):getWidget("GameField"):AcceptMessage( Message("HideShowLevelList") )
	gameInfo:setStage(3)
	GUI:getLayer("StageLayer_3"):getWidget("GameField"):AcceptMessage( Message("FillLevelList", 1) )
	GUI:getLayer("StageLayer_3"):getWidget("GameField"):AcceptMessage( Message("HideShowLevelList") )
	gameInfo:setStage(4)
	GUI:getLayer("StageLayer_4"):getWidget("GameField"):AcceptMessage( Message("FillLevelList", 1) )
	GUI:getLayer("StageLayer_4"):getWidget("GameField"):AcceptMessage( Message("HideShowLevelList") )
	gameInfo:setStage(5)
	GUI:getLayer("StageLayer_5"):getWidget("GameField"):AcceptMessage( Message("FillLevelList", 1) )
	GUI:getLayer("StageLayer_5"):getWidget("GameField"):AcceptMessage( Message("HideShowLevelList") )
	gameInfo:setStage(6)
	GUI:getLayer("StageLayer_6"):getWidget("GameField"):AcceptMessage( Message("FillLevelList", 1) )
	GUI:getLayer("StageLayer_6"):getWidget("GameField"):AcceptMessage( Message("HideShowLevelList") )
	gameInfo:setStage(7)
	GUI:getLayer("StageLayer_7"):getWidget("GameField"):AcceptMessage( Message("FillLevelList", 1) )
	GUI:getLayer("StageLayer_7"):getWidget("GameField"):AcceptMessage( Message("HideShowLevelList") )
	gameInfo:setStage(stage)

	GUI:getLayer("Bag"):getWidget("Bag"):AcceptMessage( Message("InitNoteView") )

--	Screen:pushLayer( GUI:getLayer("Map") )
--	Screen:pushLayer( GUI:getLayer("Dialog") )
--	GUI:getLayer("Dialog"):getWidget("Dialog"):AcceptMessage( Message("Run", "Dlg_11") )

--	UploadResourceGroup("Map")
--	Screen:pushLayer( GUI:getLayer("Map") )

--	GUI:getLayer("MainMenu"):getWidget("MainMenu"):AcceptMessage( Message("Pause") )
--	Screen:pushLayer( GUI:getLayer("ArtCutter") )

	if (false) then
		UploadResourceGroup("Game");
		UploadResourceGroup("BagRes");
		UpdateGameLayerName()
		Screen:pushLayer( GUI:getLayer("MainMenu") )
		GUI:getLayer("MainMenu"):getWidget("MainMenu"):AcceptMessage( Message("Pause") )
		StartGame()
	end
	
--	UpdateGameLayerName()
--	GUI:getLayer(gameLayer):getWidget("GameField"):AcceptMessage(Message("HideShowLevelList"))
	
--	UploadResourceGroup("Clouds")
--	UploadResourceGroup("MainMenu")
--	Screen:pushLayer( GUI:getLayer("MainMenu") )

--	UploadResourceGroup("Game")
--	Screen:pushLayer( GUI:getLayer("Help") )

--	Screen:pushLayer( GUI:getLayer("HiScores") )

--	param = VariableSet()
--	param:setFloat("TimeScale", 1.0)
--	param:setFloat("TimeScale2", 1.0)
--	param:setString("Layer1", "JuleBook")
--	param:setString("CrossHandler", "UploadGameIntro")
--	kernel:addController(controlFactory:Create("CrossFade", param))

--	UploadResourceGroup("Clouds")
--	UploadResourceGroup("MainMenu")
--	UploadResourceGroup("BagRes");
--	UploadResourceGroup("Intro");
--	Screen:pushLayer( GUI:getLayer("JuleBook") )
--	GUI:getLayer("JuleBook"):getWidget("JuleBook"):AcceptMessage( Message("StartIntro") )

--	GUI:getLayer("JuleBook"):getWidget("JuleBook"):AcceptMessage( Message("StartIntroForNewPlayer") )

--	UploadResourceGroup("Game")
--	Screen:pushLayer( GUI:getLayer("Statistics") )
--	GUI:getLayer("Statistics"):getWidget("GameStatistics"):AcceptMessage(Message("Start"))
	
--	UploadResourceGroup("Clouds")
--	GUI:getLayer("ScreensaverBG_Start"):getWidget("Screensaver"):AcceptMessage(Message("Enable"))
--	Screen:pushLayer( GUI:getLayer("ScreensaverBG_Start") )

--	UploadResourceGroup("BagRes")
--	Screen:pushLayer( GUI:getLayer("Bag") )

--	UploadResourceGroup("Game")
--	UploadResourceGroup("StageLayer_4")
--	UploadResourceGroup("Clouds")
--	Screen:pushLayer( GUI:getLayer("TestEgypt"))
--	Screen:pushLayer( GUI:getLayer("Hint") )
--	GUI:getLayer("Hint"):getWidget("Hint"):AcceptMessage(Message("Show", "msg_1"))

	Screen:pushLayer( GUI:getLayer("LoadScreen") )
	GUI:getLayer("LoadScreen"):getWidget("LoadScreen"):AcceptMessage(Message("SetMode", "2"))

--	UploadResourceGroup("Game")
--	gameInfo:setStage(1)
--	gameInfo:setLevel(4)
--	UploadResourceGroup("StageLayer_1")
--	UploadResourceGroup("Clouds")
--	StartGame()

--	UploadResourceGroup("StageLayer_1")
--	UploadResourceGroup("Clouds")
--	Screen:pushLayer( GUI:getLayer("Credits") )
	GUI:getLayer("Credits"):getWidget("Credits"):AcceptMessage(Message("Reset"))
	

--	Screen:pushLayer( GUI:getLayer("Statistics") )
--	Screen:pushLayer( GUI:getLayer("TestLayer_1") )
--	Screen:pushLayer( GUI:getLayer("MagicGame") )

--	Screen:pushLayer( GUI:getLayer("ExitGameNoLostLife") )
end
