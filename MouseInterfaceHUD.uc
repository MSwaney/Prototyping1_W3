//--------------------------------------------------------------------------------------------
// Author:  Matthew Swaney
// Date:    01/26/2014
// Credit:  UDN tutorial
// Credit:  http://udn.epicgames.com/Three/DevelopmentKitGemsCreatingAMouseInterface.html
//
//Purpose: Mouse Interface
//--------------------------------------------------------------------------------------------
class MouseInterfaceHUD extends HUD;

//True to show the curser, false to hide it
var bool showCursor;

// The texture which represents the cursor on the screen
var const Texture2D CursorTexture;
// The color of the cursor
var const Color CursorColor;
// Pending left mouse button pressed event
var bool PendingLeftPressed;
// Pending left mouse button released event
var bool PendingLeftReleased;
// Pending right mouse button pressed event
var bool PendingRightPressed;
// Pending right mouse button released event
var bool PendingRightReleased;
// Pending middle mouse button pressed event
var bool PendingMiddlePressed;
// Pending middle mouse button released event
var bool PendingMiddleReleased;
// Pending mouse wheel scroll up event
var bool PendingScrollUp;
// Pending mouse wheel scroll down event
var bool PendingScrollDown;
// Cached mouse world origin
var Vector CachedMouseWorldOrigin;
// Cached mouse world direction
var Vector CachedMouseWorldDirection;
// Last mouse interaction interface
var MouseInterfaceInteractionInterface LastMouseInteractionInterface;

//--------------------------------------------------------------------------------------------
event PostRender()
{
  local MouseInterfacePlayerInput MouseInterfacePlayerInput;
  local MouseInterfaceInteractionInterface MouseInteractionInterface;
  local Vector HitLocation, HitNormal;

  Super.PostRender();

  // Ensure that we aren't using ScaleForm and that we have a valid cursor
  if (showCursor)
  {
    // Ensure that we have a valid PlayerOwner
    if (PlayerOwner != None && CursorTexture != None)
    {
      // Cast to get the MouseInterfacePlayerInput
      MouseInterfacePlayerInput = MouseInterfacePlayerInput(PlayerOwner.PlayerInput);

      // If we're not using scale form and we have a valid cursor texture, render it
      if (MouseInterfacePlayerInput != None)
      {
        // Set the canvas position to the mouse position
        Canvas.SetPos(MouseInterfacePlayerInput.MousePosition.X, MouseInterfacePlayerInput.MousePosition.Y);
        // Set the cursor color
        Canvas.DrawColor = CursorColor;
        // Draw the texture on the screen
        Canvas.DrawTile(CursorTexture, CursorTexture.SizeX, CursorTexture.SizeY, 0.f, 0.f, CursorTexture.SizeX, CursorTexture.SizeY,, true);
      }
    }
  }

  // Get the current mouse interaction interface
  MouseInteractionInterface = GetMouseActor(HitLocation, HitNormal);

  // Handle mouse over and mouse out
  // Did we previously had a mouse interaction interface?
  if (LastMouseInteractionInterface != None)
  {
    // If the last mouse interaction interface differs to the current mouse interaction
    if (LastMouseInteractionInterface != MouseInteractionInterface)
    {
      // Call the mouse out function
      LastMouseInteractionInterface.MouseOut(CachedMouseWorldOrigin, CachedMouseWorldDirection);
      // Assign the new mouse interaction interface
      LastMouseInteractionInterface = MouseInteractionInterface; 

      // If the last mouse interaction interface is not none
      if (LastMouseInteractionInterface != None)
      {
        // Call the mouse over function
        LastMouseInteractionInterface.MouseOver(CachedMouseWorldOrigin, CachedMouseWorldDirection); // Call mouse over
      }
    }
  }
  else if (MouseInteractionInterface != None)
  {
    // Assign the new mouse interaction interface
    LastMouseInteractionInterface = MouseInteractionInterface; 
    // Call the mouse over function
    LastMouseInteractionInterface.MouseOver(CachedMouseWorldOrigin, CachedMouseWorldDirection); 
  }

  if (LastMouseInteractionInterface != None)
  {
    // Handle left mouse button
    if (PendingLeftPressed)
    {
      if (PendingLeftReleased)
      {
        // This is a left click, so discard
        PendingLeftPressed = false;
        PendingLeftReleased = false;
      }
      else
      {
        // Left is pressed
        PendingLeftPressed = false;
        LastMouseInteractionInterface.MouseLeftPressed(CachedMouseWorldOrigin, CachedMouseWorldDirection, HitLocation, HitNormal);
      }
    }
    else if (PendingLeftReleased)
    {
      // Left is released
      PendingLeftReleased = false;
      LastMouseInteractionInterface.MouseLeftReleased(CachedMouseWorldOrigin, CachedMouseWorldDirection);
    }

    // Handle right mouse button
    if (PendingRightPressed)
    {
      if (PendingRightReleased)
      {
        // This is a right click, so discard
        PendingRightPressed = false;
        PendingRightReleased = false;
      }
      else
      {
        // Right is pressed
        PendingRightPressed = false;
        LastMouseInteractionInterface.MouseRightPressed(CachedMouseWorldOrigin, CachedMouseWorldDirection, HitLocation, HitNormal);
      }
    }
    else if (PendingRightReleased)
    {
      // Right is released
      PendingRightReleased = false;
      LastMouseInteractionInterface.MouseRightReleased(CachedMouseWorldOrigin, CachedMouseWorldDirection);
    }

    // Handle middle mouse button
    if (PendingMiddlePressed)
    {
      if (PendingMiddleReleased)
      {
        // This is a middle click, so discard 
        PendingMiddlePressed = false;
        PendingMiddleReleased = false;
      }
      else
      {
        // Middle is pressed
        PendingMiddlePressed = false;
        LastMouseInteractionInterface.MouseMiddlePressed(CachedMouseWorldOrigin, CachedMouseWorldDirection, HitLocation, HitNormal);
      }
    }
    else if (PendingMiddleReleased)
    {
      PendingMiddleReleased = false;
      LastMouseInteractionInterface.MouseMiddleReleased(CachedMouseWorldOrigin, CachedMouseWorldDirection);
    }

    // Handle middle mouse button scroll up
    if (PendingScrollUp)
    {
      PendingScrollUp = false;
      LastMouseInteractionInterface.MouseScrollUp(CachedMouseWorldOrigin, CachedMouseWorldDirection);
    }

    // Handle middle mouse button scroll down
    if (PendingScrollDown)
    {
      PendingScrollDown = false;
      LastMouseInteractionInterface.MouseScrollDown(CachedMouseWorldOrigin, CachedMouseWorldDirection);
    }
  }
}

function MouseInterfaceInteractionInterface GetMouseActor(optional out Vector HitLocation, optional out Vector HitNormal)
{
  local MouseInterfaceInteractionInterface MouseInteractionInterface;
  local MouseInterfacePlayerInput MouseInterfacePlayerInput;
  local Vector2D MousePosition;
  local Actor HitActor;

  // Ensure that we have a valid canvas and player owner
  if (Canvas == None || PlayerOwner == None)
  {
    return None;
  }

  // Type cast to get the new player input
  MouseInterfacePlayerInput = MouseInterfacePlayerInput(PlayerOwner.PlayerInput);

  // Ensure that the player input is valid
  if (MouseInterfacePlayerInput == None)
  {
    return None;
  }

  // We stored the mouse position as an IntPoint, but it's needed as a Vector2D
  MousePosition.X = MouseInterfacePlayerInput.MousePosition.X;
  MousePosition.Y = MouseInterfacePlayerInput.MousePosition.Y;
  // Deproject the mouse position and store it in the cached vectors
  Canvas.DeProject(MousePosition, CachedMouseWorldOrigin, CachedMouseWorldDirection);

  // Perform a trace actor interator. An interator is used so that we get the top most mouse interaction
  // interface. This covers cases when other traceable objects (such as static meshes) are above mouse
  // interaction interfaces.
  ForEach TraceActors(class'Actor', HitActor, HitLocation, HitNormal, CachedMouseWorldOrigin + CachedMouseWorldDirection * 65536.f, CachedMouseWorldOrigin,,, TRACEFLAG_Bullet)
  {
    // Type cast to see if the HitActor implements that mouse interaction interface
    MouseInteractionInterface = MouseInterfaceInteractionInterface(HitActor);
    if (MouseInteractionInterface != None)
    {
      return MouseInteractionInterface;
    }
  }

  return None;
}

function Vector GetMouseWorldLocation()
{
  local MouseInterfacePlayerInput MouseInterfacePlayerInput;
  local Vector2D MousePosition;
  local Vector MouseWorldOrigin, MouseWorldDirection, HitLocation, HitNormal;

  // Ensure that we have a valid canvas and player owner
  if (Canvas == None || PlayerOwner == None)
  {
    return Vect(0, 0, 0);
  }

  // Type cast to get the new player input
  MouseInterfacePlayerInput = MouseInterfacePlayerInput(PlayerOwner.PlayerInput);

  // Ensure that the player input is valid
  if (MouseInterfacePlayerInput == None)
  {
    return Vect(0, 0, 0);
  }

  // We stored the mouse position as an IntPoint, but it's needed as a Vector2D
  MousePosition.X = MouseInterfacePlayerInput.MousePosition.X;
  MousePosition.Y = MouseInterfacePlayerInput.MousePosition.Y;
  // Deproject the mouse position and store it in the cached vectors
  Canvas.DeProject(MousePosition, MouseWorldOrigin, MouseWorldDirection);

  // Perform a trace to get the actual mouse world location.
  Trace(HitLocation, HitNormal, MouseWorldOrigin + MouseWorldDirection * 65536.f, MouseWorldOrigin , true,,, TRACEFLAG_Bullet);
  return HitLocation;
}

//-------------------------------------------------------------------------------------
defaultproperties
{
  // Set to false if you wish to use Unreal's player input to retrieve the mouse coordinates
  //UsingScaleForm=true
  CursorColor=(R=255,G=255,B=255,A=255)
  CursorTexture=Texture2D'EngineResources.Cursors.Arrow'
  showCursor = true;
}