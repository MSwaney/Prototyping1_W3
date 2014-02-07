//------------------------------------------------------------------------------------------------ 
// Author:  Matthew Swaney
// Date:    01/26/2014
// Credit:  Chris Maxwell - Week 2 Lecture
// Credit:  http://udn.epicgames.com/Three/CameraTechnicalGuide.html#Example%20All-In-One%20Camera
// 
// Purpose: Access the game types score member and increments it by out class members value. 
//------------------------------------------------------------------------------------------------ 
// extend UIAction if this action should be UI Kismet Action instead of a Level Kismet Action
class MS_KismetAct_IncreaseScore extends SequenceAction;

var() int scoreModAmouont;

event Activated()
{
	local MS_MiniGameType_W3 rGame;
	local WorldInfo rWorld;

	rWorld = GetWorldInfo();

	if(rWorld != none)
	{
		rGame = MS_MiniGameType_W3(rWorld.Game);
		if(rGame != none)
		{
			rGame.nScore += scoreModAmouont;
		}
	}
}

defaultproperties
{
	scoreModAmouont = 1
	
	bCallHandler = false

	ObjName="GameScoreIncrease"
	ObjCategory="Game"
}