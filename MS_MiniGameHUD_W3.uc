//------------------------------------------------------------------------------------------------ 
// Author:  Matthew Swaney
// Date:    01/26/2014
// Credit:  Christopher Maxwell
// Credit:  https://dl.dropbox.com/s/zhq6e1zxh63rg2s/FSGDnBS_PT1_W3_00_MouseInterface_UT.wmv?&dl=1
// Credit:  https://dl.dropbox.com/s/zhq6e1zxh63rg2s/FSGDnBS_PT1_W3_00_MouseInterface_UT.wmv?&dl=1
// Credit:  UDN tutorial
// Credit:  http://udn.epicgames.com/Three/DevelopmentKitGemsCreatingAMouseInterface.html
//
//Purpose: Create a custom HUD for the Week 3 Assignment
//--------------------------------------------------------------------------------------------
class MS_MiniGameHUD_W3 extends MouseInterfaceHUD;

//-Variables--------------------------------------------------------------------------------------

var Font m_font;
var Texture2D m_texture;

//------------------------------------------------------------------------------------------------ 
function DrawHUD()
{
	super.DrawHUD();

	drawScore();
	myTexture(850, 15);
	DrawTimers();
}

//------------------------------------------------------------------------------------------------ 
event PostRender()
{
	super.PostRender();
}

//------------------------------------------------------------------------------------------------ 
function drawScore()
{
	local MS_MiniGameType_W3 rGame;

	rGame = MS_MiniGameType_W3(WorldInfo.Game);
	if(rGame != none)
	{	
		Canvas.SetPos(15, 65);
		Canvas.SetDrawColor(65, 105, 225);
		Canvas.DrawText("Score: " @ rGame.nScore);
		Canvas.Font = m_font;
	}


}
//------------------------------------------------------------------------------------------------ 
function myTexture(float x, float y)
{
	Canvas.SetPos(x , y);
	Canvas.SetDrawColor(255, 255, 255);
	Canvas.DrawTile(m_texture, m_texture.SizeX / 4, m_texture.SizeY / 4, 0, 0, m_texture.SizeX, m_texture.SizeY);
}

// Draw the Game Timer and Play Timer to the HUD-------------------------------------------
function DrawTimers()
{
	local WorldInfo rWorldInfo;
	local MS_MiniGameType_W3 rGame;
	local string rText;

	rWorldInfo = class'WorldInfo'.static.GetWorldInfo();
	if( rWorldInfo != none )
	{
		rGame = MS_MiniGameType_W3( rWorldInfo.Game );
		if(rGame != none )
		{
			// Play Timer
			rText = "Play Time: " @ rGame.m_playTimer;
			rText = Left(rText, InStr(rText, ".") + 2);
			Canvas.SetPos( 15, 15);
			Canvas.Font = m_font;
			if(rGame.m_playTimer < 15)
			{
				Canvas.SetDrawColor(255, 0, 0);
			}
			else
			{
				Canvas.SetDrawColor(65, 105, 225);
			}
			Canvas.DrawText( rText, , 0.5, 0.5);

			// Game Timer
			/*rText = "GameTimer: " @ rGame.m_gameTimer;
			rText = Left(rText, InStr(rText, ".") + 2);
			Canvas.SetPos( 15, 40);
			Canvas.Font = m_font;
			if( rGame.m_gameTimer < 5)
			{
				Canvas.SetDrawColor(255, 0, 0);
			} 
			else
			{
				Canvas.SetDrawColor(65, 105, 225);
			}
			Canvas.DrawText( rText, , 0.5, 0.5);*/
		}
	}
}

//------------------------------------------------------------------------------------------------
DefaultProperties
{
	m_font = Font'UI_Fonts.Fonts.UI_Fonts_Positec36'
	m_texture = Texture2D'UDKHUD.ut3_minimap_compass'
}
