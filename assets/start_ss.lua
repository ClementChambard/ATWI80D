--LoadResource("fonts.xml")

--LoadResource("GUI_Resource.xml")
LoadResource("Sound.xml")
LoadResource("Music.xml")

Sound:SetSoundVolume(60)
Sound:SetMusicVolume(100)

--LoadResource("DialogResource.xml")
LoadResource("GameResource.xml")
--LoadResource("SucResource.xml")
--LoadResource("MapResource.xml")
--LoadResource("MainMenuResource.xml")
--LoadResource("ChipsAnim.xml")

--LoadEffects("StatEffects.xml")
--LoadEffects("Flames.xml")

--LoadParticles("Candle.xml")
--LoadEffects("Candle.xml")

LoadParticles("RainParticleEffect.xml")
LoadEffects("EgyptFlame.xml")
LoadEffects("IndiaFlame.xml")
--LoadEffects("TimeBonus.xml")
LoadEffects("JapanWaterFall.xml")

LoadParticles("Sunset.xml")
LoadEffects("Sunset.xml")
LoadParticles("LondonPena.xml")
LoadEffects("LondonPena.xml")
LoadParticles("effects.xml")
LoadEffects("effects.xml")
--LoadParticles("MapArrows.xml")
--LoadEffects("MapArrows.xml")
--LoadParticles("BagEffects.xml")
--LoadEffects("BagEffects.xml")
--LoadParticles("MenuEffects.xml")
--LoadEffects("MenuEffects.xml")
--LoadParticles("TakeBonusEff.xml")
--LoadEffects("TakeBonusEff.xml")
--LoadParticles("StringEffects.xml")
--LoadEffects("StringEffects.xml")

LoadEffects("RainParticleEffect.xml")

LoadParticles("country_effects.xml")
LoadEffects("country_effects.xml")

GUI:LoadText("text.xml")

--GUI:LoadLayers("JuleBook_GUI.xml")
--GUI:LoadLayers("Menu_GUI.xml")
GUI:LoadLayers("Cross_GUI.xml")
--GUI:LoadLayers("Map_GUI.xml")
--GUI:LoadLayers("Suc_GUI.xml")
--GUI:LoadLayers("Stat_GUI.xml")
--GUI:LoadLayers("MenuInGame_GUI.xml")
--GUI:LoadLayers("Dialog_GUI.xml")
--GUI:LoadLayers("MainMenuGUI.xml")
GUI:LoadLayers("Gamefield_GUI_ss.xml")
--GUI:LoadLayers("Options_GUI.xml")
--GUI:LoadLayers("Hint_GUI.xml")

local sndVolume = gameInfo:getSoundVolume()
local musVolume = gameInfo:getMusicVolume()
local envVolume = gameInfo:getEnvironmentVolume()

Sound:SetSoundVolume(sndVolume)
Sound:SetMusicVolume(musVolume)
Sound:SetEnvironmentVolume(envVolume)

local iFullscreen = "0"
if gameInfo:getFullscreen() then
	iFullscreen = "1"
end

local iCCursor = "0"
if gameInfo:getCustomCursor() then
	iCCursor = "1"
end

GUI:getLayer("StageLayer_1"):getWidget("GameField"):AcceptMessage(Message("SetPreviewSSMode", 1))
gameInfo:setPreviewSSMode(true)

local message = gameInfo:RunFirstScreensaverBG()

param = VariableSet()
param:setString("Layer1", message:getData())
param:setString("CrossHandler", "UploadScreensaverBG")
kernel:addController(controlFactory:Create("CrossFade", param))	
Sound:FadeOutAllTracks(1.0)
PlayStageMusic(message:getData())
