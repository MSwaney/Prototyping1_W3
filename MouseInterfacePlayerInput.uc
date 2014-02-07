//--------------------------------------------------------------------------------------------
// Author:  Matthew Swaney
// Date:    01/26/2014
// Credit:  UDN tutorial
// Credit:  http://udn.epicgames.com/Three/DevelopmentKitGemsCreatingAMouseInterface.html
//
//Purpose: Mouse Interface
//--------------------------------------------------------------------------------------------
class MouseInterfacePlayerInput extends UTPlayerInput;

//Stored mouse posistion. Set to private write as we don't want other classes to modify it, but still all other classes to access it.
var IntPoint MousePosition;
//The amount of time accumulate between mouse toggles
var float mouseToggleTimer;

//--------------------------------------------------------------------------------------------

event PlayerInput(float DeltaTime)
{
  local MouseInterfaceHUD MouseInterfaceHUD;

  // Handle mouse movement
  // Check that we have the appropriate HUD class
  MouseInterfaceHUD = MouseInterfaceHUD(MyHUD);
  if (MouseInterfaceHUD != None)
  {
      // If we are not using ScaleForm, then read the mouse input directly
      // Add the aMouseX to the mouse position and clamp it within the viewport width
      MousePosition.X = Clamp(MousePosition.X + aMouseX, 0, MouseInterfaceHUD.SizeX);
      // Add the aMouseY to the mouse position and clamp it within the viewport height
      MousePosition.Y = Clamp(MousePosition.Y - aMouseY, 0, MouseInterfaceHUD.SizeY);
  }

  //Determine if the player has toggles the mouse cursor
  //Accumulate the time passed to prevent the flickr when the key is held for more than 1/60 second
  mouseToggleTimer += DeltaTime;
  if( mouseToggleTimer > 0.25f )
  {
	checkCursorToggle('M');
  }
  //Preserve the oringinal input handling of the parent class
  Super.PlayerInput(DeltaTime);
}

function SetMousePosition(int X, int Y)
{
  if (MyHUD != None)
  {
    MousePosition.X = Clamp(X, 0, MyHUD.SizeX);
    MousePosition.Y = Clamp(Y, 0, MyHUD.SizeY);
  }
}

function checkCursorToggle( name _KeyToCheck)
{
	local MouseInterfaceHUD myMouseHUD;
	local name key;

	//Ensure our parents HUD is valid
	if(myHUD != none)
	{
		//type cast the controller's generic HUD to get our custom HUD
		myMouseHUD = MouseInterfaceHUD(myHUD);
		if(myMouseHUD != none)
		{
		//Check for each of the keys pressed in the array
			foreach PressedKeys(key)
			{
				//Is the passed key matching the current key in the array?
				if(_KeyToCheck == key)
				{
					//Set the cursor boolean to the opposite of what it is now
					myMouseHUD.showCursor = !myMouseHUD.showCursor;

					//Reset the time so we prevent the flicker when the key is held for more than 1/60 second
					mouseToggleTimer = 0;
				}
			}
		}
	}
}

//--------------------------------------------------------------------------------------------
defaultproperties
{
}