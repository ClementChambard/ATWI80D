function ShowStartLevelDialog()

	if (needShowDialog == true) then
		if (gameInfo:getStage() == 1) and (gameInfo:getLevel() == 1) then
			Screen:pushLayer( GUI:getLayer("Dialog") )
			GUI:getLayer("Dialog"):getWidget("Dialog"):AcceptMessage( Message("Run", "Dlg_11") )
		elseif (gameInfo:getStage() == 2) and (gameInfo:getLevel() == 1) then
			Screen:pushLayer( GUI:getLayer("Dialog") )
			GUI:getLayer("Dialog"):getWidget("Dialog"):AcceptMessage( Message("Run", "Dlg_21") )
		elseif (gameInfo:getStage() == 3) and (gameInfo:getLevel() == 1) then
			Screen:pushLayer( GUI:getLayer("Dialog") )
			GUI:getLayer("Dialog"):getWidget("Dialog"):AcceptMessage( Message("Run", "Dlg_31") )
		elseif (gameInfo:getStage() == 4) and (gameInfo:getLevel() == 1) then
			Screen:pushLayer( GUI:getLayer("Dialog") )
			GUI:getLayer("Dialog"):getWidget("Dialog"):AcceptMessage( Message("Run", "Dlg_41") )
		elseif (gameInfo:getStage() == 5) and (gameInfo:getLevel() == 1) then
			Screen:pushLayer( GUI:getLayer("Dialog") )
			GUI:getLayer("Dialog"):getWidget("Dialog"):AcceptMessage( Message("Run", "Dlg_51") )
		elseif (gameInfo:getStage() == 6) and (gameInfo:getLevel() == 1) then
			Screen:pushLayer( GUI:getLayer("Dialog") )
			GUI:getLayer("Dialog"):getWidget("Dialog"):AcceptMessage( Message("Run", "Dlg_61") )
		elseif (gameInfo:getStage() == 7) and (gameInfo:getLevel() == 1) then
			Screen:pushLayer( GUI:getLayer("Dialog") )
			GUI:getLayer("Dialog"):getWidget("Dialog"):AcceptMessage( Message("Run", "Dlg_71") )
		elseif (gameInfo:getStage() == 1) and (gameInfo:getLevel() == 8) then
			Screen:pushLayer( GUI:getLayer("Dialog") )
			GUI:getLayer("Dialog"):getWidget("Dialog"):AcceptMessage( Message("Run", "Dlg_12") )
		elseif (gameInfo:getStage() == 2) and (gameInfo:getLevel() == 10) then
			Screen:pushLayer( GUI:getLayer("Dialog") )
			GUI:getLayer("Dialog"):getWidget("Dialog"):AcceptMessage( Message("Run", "Dlg_22") )
		elseif (gameInfo:getStage() == 3) and (gameInfo:getLevel() == 12) then
			Screen:pushLayer( GUI:getLayer("Dialog") )
			GUI:getLayer("Dialog"):getWidget("Dialog"):AcceptMessage( Message("Run", "Dlg_32") )
		elseif (gameInfo:getStage() == 4) and (gameInfo:getLevel() == 12) then
			Screen:pushLayer( GUI:getLayer("Dialog") )
			GUI:getLayer("Dialog"):getWidget("Dialog"):AcceptMessage( Message("Run", "Dlg_42") )
		elseif (gameInfo:getStage() == 5) and (gameInfo:getLevel() == 12) then
			Screen:pushLayer( GUI:getLayer("Dialog") )
			GUI:getLayer("Dialog"):getWidget("Dialog"):AcceptMessage( Message("Run", "Dlg_52") )
		elseif (gameInfo:getStage() == 6) and (gameInfo:getLevel() == 13) then
			Screen:pushLayer( GUI:getLayer("Dialog") )
			GUI:getLayer("Dialog"):getWidget("Dialog"):AcceptMessage( Message("Run", "Dlg_62") )
		elseif (gameInfo:getStage() == 7) and (gameInfo:getLevel() == 13) then
			Screen:pushLayer( GUI:getLayer("Dialog") )
			GUI:getLayer("Dialog"):getWidget("Dialog"):AcceptMessage( Message("Run", "Dlg_72") )
		elseif (gameInfo:getStage() == 7) and (gameInfo:getLevel() == 14) then
			Screen:pushLayer( GUI:getLayer("Dialog") )
			GUI:getLayer("Dialog"):getWidget("Dialog"):AcceptMessage( Message("Run", "Dlg_81") )
		else
			needShowDialog = false
			GUI:getLayer(gameLayer):getWidget("GameField"):AcceptMessage( Message("RunStartAW", 1) )
		end
	else
		needShowDialog = false
		GUI:getLayer(gameLayer):getWidget("GameField"):AcceptMessage( Message("RunStartAW", 1) )
	end
end

function StartGameByDialog()
	if (countryIntro == true) then
		param = VariableSet()
		param:setString("Layer1", countryIntroReturnLayer);
		param:setString("CrossHandler", "CountryIntroExitCross")
		kernel:addController(controlFactory:Create("CrossFade", param))
		Sound:FadeOutAllTracks(1.0)
	else
		MessageManager:putMessage(Message("StartGame"))
	end
end

function DialogSwitchToFrance()
	MessageManager:putMessage(Message("DialogSwitchToFrance"))
end
