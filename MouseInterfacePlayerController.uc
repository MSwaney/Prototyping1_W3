//--------------------------------------------------------------------------------------------
// Author:  Matthew Swaney
// Date:    01/26/2014
// Credit:  UDN tutorial
// Credit:  http://udn.epicgames.com/Three/DevelopmentKitGemsCreatingAMouseInterface.html
//
//Purpose: Mouse Interface
//--------------------------------------------------------------------------------------------
class MouseInterfacePlayerController extends UTPlayerController;

// Mouse event enum
enum EMouseEvent
{
  LeftMouseButton,
  RightMouseButton,
  MiddleMouseButton,
  ScrollWheelUp,
  ScrollWheelDown,
};

// Handle mouse inputs
function HandleMouseInput(EMouseEvent MouseEvent, EInputEvent InputEvent)
{
  local MouseInterfaceHUD MouseInterfaceHUD;

  // Type cast to get our HUD
  MouseInterfaceHUD = MouseInterfaceHUD(myHUD);

  if (MouseInterfaceHUD != None)
  {
	//Prevent the input from being recorded if its not showing
	if(MouseInterfaceHUD.showCursor)
	{
    // Detect what kind of input this is
    if (InputEvent == IE_Pressed)
    {
      // Handle pressed event
      switch (MouseEvent)
      {
        case LeftMouseButton:
     MouseInterfaceHUD.PendingLeftPressed = true;
     break;

   case RightMouseButton:
     MouseInterfaceHUD.PendingRightPressed = true;
     break;

   case MiddleMouseButton:
     MouseInterfaceHUD.PendingMiddlePressed = true;
     break;

   case ScrollWheelUp:
     MouseInterfaceHUD.PendingScrollUp = true;
     break;

   case ScrollWheelDown:
     MouseInterfaceHUD.PendingScrollDown = true;
     break;

   default:
     break;
      }
    }
    else if (InputEvent == IE_Released)
    {
      // Handle released event
      switch (MouseEvent)
      {
        case LeftMouseButton:
     MouseInterfaceHUD.PendingLeftReleased = true;
     break;

   case RightMouseButton:
     MouseInterfaceHUD.PendingRightReleased = true;
     break;

   case MiddleMouseButton:
     MouseInterfaceHUD.PendingMiddleReleased = true;
     break;

   default:
     break;
      }
      }
    }
  }
}

// Hook used for the left and right mouse button when pressed
exec function StartFire(optional byte FireModeNum)
{

	local MouseInterfaceHUD MouseInterfaceHUD;
	local bool bAllowFire;

	//Default to allowing weapon fire
	bAllowFire = true;

	//Type cast to get our HUD
	MouseInterfaceHUD = MouseInterfaceHUD(myHUD);
	if (MouseInterfaceHUD != none)
	{
		//Prevent the input from being recorded if its not showing
		if(MouseInterfaceHUD.showCursor)
		{
			bAllowFire = false;
		}
	}

  HandleMouseInput((FireModeNum == 0) ? LeftMouseButton : RightMouseButton, IE_Pressed);

  //Prevent weapon fire when mouse cursor is visible
  if(bAllowFire)
  {
  Super.StartFire(FireModeNum);
  }
}

// Hook used for the left and right mouse button when released
exec function StopFire(optional byte FireModeNum)
{
  HandleMouseInput((FireModeNum == 0) ? LeftMouseButton : RightMouseButton, IE_Released);
  Super.StopFire(FireModeNum);
}

// Called when the middle mouse button is pressed
exec function MiddleMousePressed()
{
  HandleMouseInput(MiddleMouseButton, IE_Pressed);
}

// Called when the middle mouse button is released
exec function MiddleMouseReleased()
{
  HandleMouseInput(MiddleMouseButton, IE_Released);
}

// Called when the middle mouse wheel is scrolled up
exec function MiddleMouseScrollUp()
{
  HandleMouseInput(ScrollWheelUp, IE_Pressed);
}

// Called when the middle mouse wheel is scrolled down
exec function MiddleMouseScrollDown()
{
  HandleMouseInput(ScrollWheelDown, IE_Pressed);
}

// Null this function (Now extended to allow for rotation when the player holds a particular button)
function UpdateRotation(float DeltaTime)
{
	local MouseInterfaceHUD MouseInterfaceHUD;

	//Ensure we have a valid HUD object
	if( myHUD != none)
	{
		//Type cast the controller's generic HUD to get our custom HUD
		MouseInterfaceHUD = MouseInterfaceHUD(myHUD);
		if(MouseInterfaceHUD != none)
		{
			if(MouseInterfaceHUD.showCursor == false)
			{
			super.UpdateRotation( DeltaTime );
			}
		}
	}
}

// Override this state because StartFire isn't called globally when in this function
auto state PlayerWaiting
{
  exec function StartFire(optional byte FireModeNum)
  {
    Global.StartFire(FireModeNum);
  }
}

defaultproperties
{   
  // Set the input class to the mouse interface player input
  InputClass=class'MouseInterfacePlayerInput'
}