//------------------------------------------------------------------------------------------------ 
// Author:  Matthew Swaney
// Date:    01/26/2014
// Credit:  Chris Maxwell
// Credit:  http://udn.epicgames.com/Three/CameraTechnicalGuide.html#Example%20All-In-One%20Camera
// 
// Purpose: Checks the game types score number variable against a class member value for a win or lose condition.
//------------------------------------------------------------------------------------------------ 
class MS_KismetCond_CheckScore extends SequenceCondition;

enum ScoreCheckOuts
{
	SCO_Win,    // 0
	SCO_Lose,   // 1
};
var int scoreToReach;

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
			if(rGame.nScore >= scoreToReach)
			{
				OutputLinks[SCO_Win].bHasImpulse = true;
			}
			else
			{
				OutputLinks[SCO_Lose].bHasImpulse = true;

			}
		}
	}
}

defaultproperties
{
	ObjName="GameScoreCheck"
	ObjCategory="Game"

	scoreToReach = 10

	OutputLinks.empty
	OutputLinks(0) = (LinkDesc = "Win")     // SCO_Win
	OutputLinks(1) = (LinkDesc = "Lose")    // SCO_Lose
}