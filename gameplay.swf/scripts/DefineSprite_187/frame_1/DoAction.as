function showInfo(login, look)
{
   delete this.onEnterFrame;
   if(!_root.camera.scene.red5 || showedUser == login)
   {
      return undefined;
   }
   rankingBar._visible = true;
   pointsBar._visible = false;
   showedUser = login;
   var _loc5_;
   var _loc3_;
   if(login == _root.camera.scene.char.avatar.loadLogin())
   {
      _loc5_ = _root.getUserInfo();
      name.text = _root.camera.scene.char.avatar.loadName();
      pointsBar.points.text = _loc5_.points;
      rankingBar.ranking._width = rankingClipWidth * (_loc5_.ranking / 100);
   }
   else
   {
      _loc3_ = _root.Users[login].char;
      name.text = _loc3_.charName;
      pointsBar.points.text = _loc3_.userInfo.points;
      rankingBar.ranking._width = rankingClipWidth * (_loc3_.userInfo.ranking / 100);
   }
   var _loc6_;
   if(!char_mc.loadingFinished)
   {
      _loc6_ = new MovieClipLoader();
      _loc6_.loadClip("char.swf",char_mc);
      this.createEmptyMovieClip("loadCheck",1);
      loadCheck.onEnterFrame = function()
      {
         if(char_mc.loadingFinished)
         {
            delete this.onEnterFrame;
            char_mc.avatar.setLook(look.split(","));
            char_mc.avatar.nextFrame();
            delete char_mc.onRollOver;
            delete char_mc.onPress;
            delete char_mc.onRelease;
            instructions.onEnterFrame = function()
            {
               this._alpha -= fadeSpeed;
               if(this._alpha <= 0)
               {
                  this._alpha = 0;
                  delete this.onEnterFrame;
               }
            };
            removeMovieClip(loadCheck);
         }
      };
   }
   else
   {
      char_mc.avatar.setLook(look.split(","));
      char_mc.avatar.setParts();
      instructions.onEnterFrame = function()
      {
         this._alpha -= fadeSpeed;
         if(this._alpha <= 0)
         {
            this._alpha = 0;
            delete this.onEnterFrame;
         }
      };
   }
}
function hideInfo()
{
   this.i = 0;
   this.onEnterFrame = function()
   {
      if(this.i++ > hideDelay * fps)
      {
         delete this.onEnterFrame;
         showedUser = "";
         instructions.onEnterFrame = function()
         {
            this._alpha += fadeSpeed;
            if(this._alpha > 100)
            {
               this._alpha = 100;
               delete this.onEnterFrame;
            }
         };
      }
   };
}
function switchBars()
{
   if(rankingBar._visible)
   {
      rankingBar._visible = false;
      pointsBar._visible = true;
   }
   else
   {
      rankingBar._visible = true;
      pointsBar._visible = false;
   }
}
stop();
var fadeSpeed = 10;
var switchTime = 2000;
var rankingClipWidth = 76;
var hideDelay = 2;
var fps = 31;
