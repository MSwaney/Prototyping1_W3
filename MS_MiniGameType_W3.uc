// Author:  Matthew Swaney
// Date:    01/26/2014
// Credit:  Christopher Maxwell
// Credit:  https://dl.dropbox.com/s/zhq6e1zxh63rg2s/FSGDnBS_PT1_W3_00_MouseInterface_UT.wmv?&dl=1
// Credit:  https://dl.dropbox.com/s/zhq6e1zxh63rg2s/FSGDnBS_PT1_W3_00_MouseInterface_UT.wmv?&dl=1
// Credit:  UDN tutorial
// Credit:  http://udn.epicgames.com/Three/DevelopmentKitGemsCreatingAMouseInterface.html
//
//Purpose: Create a custom Game Type for the Week 3 Assignment
//--------------------------------------------------------------------------------------------
class MS_MiniGameType_W3 extends UTGame;

//-Variables--------------------------------------------------------------------------------------  
var int nScore;
var float m_playTimer;
var bool eventFireA;
var bool eventFireB;

//------------------------------------------------------------------------------------------------ 
function PostBeginPlay()
{
	super.PostBeginPlay();
}

//------------------------------------------------------------------------------------------------ 
function tick(float deltaTime)
{
	m_playTimer -= deltaTime;
	if(m_playTimer < 0)
	{
		m_playTimer = 0;
	}
}

//------------------------------------------------------------------------------------------------ 
DefaultProperties
{
	HUDType=class'Swaney_Matthew_W3_src.MS_MiniGameHUD_W3'

	// The "body"
	DefaultPawnClass = class'Swaney_Matthew_W3_src.MS_Pawn_W3'

	// The "brain"
	PlayerControllerClass = class'MouseInterfacePlayerController'

	// Disable the Scaleform (flash) hud in tshe UTGame. See: GenericPlayerInitialization
	bUseClassicHUD = true

	nScore = 0

	m_playTimer = 90;

	eventFireA = false;
	eventFireB = false;
}
