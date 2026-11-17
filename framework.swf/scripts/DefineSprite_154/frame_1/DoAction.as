function init()
{
   _inited = true;
   _debugId = random(99999);
   trace("[friendIcon.as " + _debugId + "] init().. friendElem:" + friendElem);
   loadChar();
   com.poptropica.sections.friendsHub.FriendsModel.getInstance().addEventListener("numFriendsChanged",Delegate.create(this,onNumFriendsChanged));
   com.poptropica.sections.friendsHub.FriendsModel.getInstance().addEventListener("playerLookChanged",Delegate.create(this,onPlayerLookChanged));
   com.poptropica.sections.friendsHub.FriendsModel.getInstance().addEventListener("commonRoomFriendAdded",Delegate.create(this,onCommonRoomFriendAdded));
   com.poptropica.sections.friendsHub.FriendsModel.getInstance().addEventListener("popQuizAdded",Delegate.create(this,onPopQuizAdded));
   _numFriends = 0;
   drawNumFriends();
   if(!isSwfLocal())
   {
      getNumFriends();
   }
   else
   {
      com.greensock.TweenMax.delayedCall(4,com.poptropica.sections.friendsHub.FriendsModel.getInstance().dispatchCommonRoomFriendAdded,null,com.poptropica.sections.friendsHub.FriendsModel.getInstance());
   }
}
function isSwfLocal()
{
   return _root._url.indexOf("file://") != -1;
}
function loadChar()
{
   var _loc1_ = new MovieClipLoader();
   _charLoadContainer = attachMovie("charLoadContainer","mcCharLoadContainer",1000);
   _charLoadContainer._visible = false;
   _loc1_.loadClip("char.swf",_charLoadContainer.stats_char);
   onEnterFrame = checkCharLoaded;
}
function checkCharLoaded()
{
   if(_charLoadContainer.stats_char.loadingFinished)
   {
      _charLoadContainer.stats_char.createBackPlayer();
      _charLoadContainer.stats_char.avatar.setParts();
      _charLoadContainer.stats_char._alpha = 100;
      this.onEnterFrame = checkTimeToDrawBitmap;
      _frameCounter = 10;
   }
}
function checkTimeToDrawBitmap()
{
   _frameCounter--;
   var _loc3_;
   var _loc2_;
   if(_frameCounter == 0)
   {
      _loc3_ = new flash.display.BitmapData(75,70,true,16777215);
      _loc2_ = new flash.geom.Matrix();
      _loc2_.scale(0.6,0.6);
      _loc3_.draw(_charLoadContainer,_loc2_);
      friendElem.char_container.attachBitmap(_loc3_,2);
      _charLoadContainer.removeMovieClip();
      placeHolder._visible = false;
      delete this.onEnterFrame;
   }
}
function onNumFriendsChanged()
{
   trace("[friendIcon.as " + _debugId + "] onNumFriendsChanged");
   getNumFriends();
}
function onPlayerLookChanged()
{
   trace("[friendIcon.as " + _debugId + "] onPlayerLookChanged");
   loadChar();
}
function getNumFriends()
{
   if(_debugId == undefined)
   {
      return undefined;
   }
   if(!com.poptropica.models.PopModel.getInstance().isRegistered)
   {
      return undefined;
   }
   trace("[friendIcon.as " + _debugId + "] getNumFriends");
   friendElem.mcNumFriends._visible = true;
   friendElem.mcNumFriends.tf.text = ". . .";
   var _loc2_ = new LoadVars();
   com.poptropica.sections.friendsHub.FriendsModel.getInstance().populateLoadVarsBase(_loc2_);
   if(_loc2_.login != undefined)
   {
      _phpResults = new LoadVars();
      _phpResults.onLoad = Delegate.create(this,onPhpComplete);
      _loc2_.sendAndLoad(com.poptropica.sections.friendsHub.FriendsModel.getInstance().serverCallPrefix + "/friends/get_friend_count.php",_phpResults,"POST");
   }
}
function onPopQuizAdded()
{
   com.greensock.TweenMax.to(friendElem,0.1,{_xscale:100,_yscale:100,onComplete:popQuizAnimComplete,onCompleteScope:this,colorTransform:{tint:16777113,tintAmount:0.8}});
}
function popQuizAnimComplete()
{
   com.greensock.TweenMax.to(friendElem,0.5,{_xscale:100,_yscale:100,colorTransform:{tint:16777113,tintAmount:0}});
}
function onPhpComplete(success)
{
   trace("[friendIcon.as " + _debugId + "] onPhpComplete. success:" + success);
   for(var _loc1_ in _phpResults)
   {
      trace(_loc1_ + "          [friendIcon.as " + _debugId + "] ::::::::::::::::: " + _phpResults[_loc1_]);
   }
   if(_phpResults.n_friends != undefined)
   {
      _numFriends = _phpResults.n_friends;
      if(success)
      {
         drawNumFriends();
         com.poptropica.sections.friendsHub.FriendsModel.getInstance().dispatchNumFriendsLoaded(_numFriends);
      }
      else
      {
         friendElem.mcNumFriends._visible = true;
         friendElem.mcNumFriends.tf.text = "ERR";
      }
   }
}
function drawNumFriends()
{
   friendElem.mcNumFriends.tf.text = _numFriends;
   vis = _numFriends != 0 && _numFriends != undefined;
   friendElem.mcNumFriends._visible = vis;
}
function onCommonRoomFriendAdded(e)
{
   if(_debugId == undefined)
   {
      return undefined;
   }
   trace("[friendIcon.as " + _debugId + "] onCommonRoomFriendAdded. this:" + this + " btn:" + e.btn);
   trace("[friendIcon.as " + _debugId + "] friendElem.mcNumFriends:" + friendElem + "," + friendElem.mcNumFriends);
   var _loc5_ = _parent._parent.topAnimContainer;
   _addFriendIcon = _loc5_.attachMovie("addFriendCommonRoomIcon","addFriendCommonRoomIcon",_loc5_.getNextHighestDepth());
   trace("[friendIcon.as " + _debugId + "] _addFriendIcon:" + _addFriendIcon + "container:" + _loc5_);
   var _loc7_ = new flash.display.BitmapData(75,70,true,16777215);
   var _loc6_ = new flash.geom.Matrix(1,0,0,1,100,175);
   _loc6_.scale(0.3,0.3);
   if(!isSwfLocal())
   {
      _loc7_.draw(_root.camera.scene.char.targetPlayer.avatar,_loc6_);
   }
   else
   {
      _loc7_.draw(_root.camera.scene.char.avatar,_loc6_);
   }
   _addFriendIcon.charContainer.attachBitmap(_loc7_,2,"auto",true);
   _addFriendIcon.charContainer._xscale = 80;
   _addFriendIcon.charContainer._yscale = 80;
   _addFriendIcon.charContainer._x += 5;
   _addFriendIcon.charContainer._y += 5;
   var _loc4_ = new flash.geom.Point(e.btn._parent._x,e.btn._parent._y);
   trace("[friendIcon.as " + _debugId + "] 1) pt:" + _loc4_);
   _loc5_.globalToLocal(_loc4_);
   trace("[friendIcon.as " + _debugId + "] 2) pt:" + _loc4_);
   _addFriendIcon._x = _loc4_.x + 180;
   _addFriendIcon._y = _loc4_.y + 100;
   _addFriendIcon._xscale = 10;
   _addFriendIcon._yscale = 10;
   var _loc8_ = 0.7;
   com.greensock.TweenMax.to(_addFriendIcon,_loc8_,{_xscale:90,_yscale:90,ease:com.greensock.easing.Bounce.easeOut});
   com.greensock.TweenMax.delayedCall(_loc8_ + 0.02,moveAddFriendToIcon,null,this);
}
function moveAddFriendToIcon()
{
   var _loc2_ = 0.7;
   com.greensock.TweenMax.to(_addFriendIcon,_loc2_,{_x:190,_y:20,ease:com.greensock.easing.Strong.easeInOut,_xscale:70,_yscale:70});
   com.greensock.TweenMax.delayedCall(_loc2_ + 0.02,commonRoomFriendAnimComplete,null,this);
}
function commonRoomFriendAnimComplete()
{
   trace("[friendIcon.as " + _debugId + " ] commonRoomFriendAnimComplete" + _addFriendIcon);
   _addFriendIcon._visible = false;
   var _loc1_ = friendElem.mcNumFriends;
   com.greensock.TweenMax.to(_loc1_,0.4,{_x:_loc1_._x + 8,_y:_loc1_._y - 2,_xscale:160,_yscale:160,ease:com.greensock.easing.Sine.easeInOut,yoyo:true,repeat:1,colorTransform:{tint:16777113,tintAmount:0.8}});
   com.greensock.TweenMax.to(friendElem.char_container,0.4,{ease:com.greensock.easing.Sine.easeInOut,yoyo:true,repeat:1,colorTransform:{tint:16777113,tintAmount:0.8}});
   _numFriends++;
   drawNumFriends();
}
var _phpResults;
var _inited = false;
var _debugId;
var _numFriends;
var _charLoadContainer;
var _frameCounter;
trace("[friendIcon.as] constructed. init fn?" + init + "   this:" + this + "  this._parent:" + this._parent + "   this._parent._parent:" + this._parent._parent + ",_root._nav_mc:" + _root._nav_mc);
if(this._parent._parent == _root._nav_mc)
{
   init();
}
stop();
