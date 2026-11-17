function loadVendorCart()
{
   var _loc2_;
   if(camera.scene.vendorCart && camera.scene.vendorCart._visible && _root._url.substr(0,_root._url.indexOf(":")) != "file" && _root._url.substr(0,_root._url.indexOf(".")) != "http://feta" && _root._url.substr(0,_root._url.indexOf(".")) != "http://localhost/pop/base")
   {
      _loc2_ = "scenes/island" + island + "/vendorCart.swf";
      camera.scene.vendorCart.loadMovie(_loc2_);
      camera.scene.adPrep();
   }
}
stop();
var scene = camera.scene;
var char = scene.char;
var avatar = char.avatar;
var FunBrain_so = SharedObject.MainSO;
CharacterAge = camera.scene.char.avatar.FunBrain_so.data.age;
CharacterGrade = CharacterAge - 5;
if(camera.scene.char.avatar.FunBrain_so.data.gender == 0)
{
   CharacterGender = "F";
}
else
{
   CharacterGender = "M";
}
CharacterLanguage = "en_us";
loadVendorCart();
_adController.getCampaigns(island);
var gIslandPositions = new Object();
gIslandPositions.Early = {x:1600,y:1255};
gIslandPositions.Shark = {x:2590,y:730};
gIslandPositions.Time = {x:2200,y:2330};
gIslandPositions.Carrot = {x:1300,y:936};
gIslandPositions.Super = {x:3500,y:1916};
gIslandPositions.Spy = {x:2700,y:2318};
gIslandPositions.Nabooti = {x:1800,y:1304};
gIslandPositions.BigNate = {x:1500,y:1162};
gIslandPositions.Astro = {x:2550,y:1142};
gIslandPositions.Counter = {x:3600,y:1732};
gIslandPositions.Reality = {x:2300,y:1092};
gIslandPositions.Myth = {x:3650,y:1110};
gIslandPositions.Trade = {x:3000,y:1572};
if(camera.scene.roomName == "Main Street" && island == "Time")
{
   var containerClip = camera.scene.bg.createEmptyMovieClip("wimpyKidBitmapContainer",camera.scene.bg.getNextHighestDepth());
   var loaderClip = camera.scene.createEmptyMovieClip("wimpyKidContainer",camera.scene.getNextHighestDepth());
   var wimpyLoader = new MovieClipLoader();
   var wimpyListener = new Object();
   wimpyListener.onLoadInit = function(target)
   {
      containerClip._x = loaderClip._x = gIslandPositions[_root.island].x;
      containerClip._y = loaderClip._y = gIslandPositions[_root.island].y;
      trace("wimpy kid loaded : " + target + " : " + target._x + ", " + target._y + " _root.island : " + _root.island);
      utils.ImageUtils.convertToTiledBitmap(loaderClip,containerClip,loaderClip._width,loaderClip._height,undefined,undefined,undefined,true);
      loaderClip._visible = true;
      loaderClip._alpha = 0;
   };
   wimpyListener.onLoadError = function(target)
   {
      trace("wimpy kid load error : " + target);
   };
   wimpyLoader.addListener(wimpyListener);
   wimpyLoader.loadClip("externalAssets/vendorCartGuideBook.swf",loaderClip);
}
