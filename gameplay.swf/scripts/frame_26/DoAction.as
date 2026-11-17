function checkForNotifier()
{
   if(_root.char.avatar.checkItem(NOTIFIER_ITEM,"Store"))
   {
      showNotifierIcon();
   }
}
function showNotifierIcon()
{
   gNotifierIcon = _root.navBar.createEmptyMovieClip("notifierIcon",_root.navBar.getNextHighestDepth());
   var _loc4_ = new MovieClipLoader();
   var _loc3_ = new Object();
   _loc3_.onLoadInit = Delegate.create(this,notifierIconLoaded);
   _loc3_.onLoadError = Delegate.create(this,notifierIconError);
   _loc4_.addListener(_loc3_);
   _loc4_.loadClip(NOTIFIER_ICON_PATH,gNotifierIcon);
}
function notifierIconLoaded(target)
{
   gNotifierIcon._x = 438;
   gNotifierIcon._y = 2;
   gNotifierIcon.click.onPress = Delegate.create(this,loadNotifier);
   gNotifierIcon.click.onRollOver = Delegate.create(this,notifierRollOver);
   if(_root.camera.scene.char.avatar.FunBrain_so.data.alvin_checkedNotifier)
   {
      gNotifierIcon.click.alert._visible = false;
   }
}
function notifierIconError()
{
   trace("alvin load error : " + arguments);
}
function loadNotifier()
{
   _root.trackCampaign("TheLorax","Notifier","Opened");
   _root.camera.scene.char.avatar.FunBrain_so.data.alvin_checkedNotifier = true;
   _root.camera.scene.char.avatar.FunBrain_so.data.flush();
   gNotifierIcon.click.alert._visible = false;
   _root.popup("The_Lorax/Notifier.swf");
}
function notifierRollOver()
{
   _root.useArrow();
}
function removeNotifier()
{
   gNotifierIcon.removeMovieClip();
   _root.camera.scene.checkNotifier();
}
function returnToGameHandler(pCounter)
{
   trace("GetAdCommand : return to game");
   unPauseGame(true);
}
function leaveGameHandler(pCounter)
{
   trace("leaveGameHandler : pCounter : " + pCounter);
   pauseGame(true);
   updateLatestGameplayBitmap();
}
trace("GetAdCommand : frame 26");
var NOTIFIER_ITEM = 2253;
var NOTIFIER_ICON_PATH = "scenes/Global/The_Lorax/assets/icon.swf";
var gNotifierIcon;
_root.char.avatar.updateIslandData("Store",Delegate.create(this,checkForNotifier));
stop();
if(camera.scene.home)
{
   camera.scene.nextFrame();
}
if(camera.scene.char.avatar.FunBrain_so.data.enteringNewIsland)
{
   trace("LSOWarningManager : using gameplay startup path.");
   sendSceneVisit();
   if(!camera.scene.char.avatar.FunBrain_so.data.doingLogin)
   {
      camera.scene.char.avatar.FunBrain_so.data.enteringNewIsland = false;
   }
   else
   {
      camera.scene.char.avatar.FunBrain_so.data.doingLogin = false;
   }
   _popModel.startup_path = "gameplay";
}
sceneIsVisible = true;
camera.scene.init2();
if(island != "Home")
{
   if(camera.scene.useScalePan == true)
   {
      if(char._x < camera.scene.leftLimit)
      {
         char._x = camera.scene.leftLimit;
      }
      else if(char._x * camera.scene.scaleFactor > camera.scene.rightLimit)
      {
         char._x = camera.scene.rightLimit * camera.scene.scaleFactor;
      }
   }
   else if(char._x < camera.scene.leftLimit)
   {
      char._x = camera.scene.leftLimit;
   }
   else if(char._x > camera.scene.rightLimit)
   {
      char._x = camera.scene.rightLimit;
   }
}
