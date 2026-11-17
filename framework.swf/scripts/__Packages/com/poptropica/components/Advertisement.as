class com.poptropica.components.Advertisement
{
   var _adPath;
   var _data;
   var _mc;
   static var AD_CLICK = "ad click";
   static var AD_OVER = "ad over";
   static var AD_OUT = "ad out";
   static var AD_LOADED = "ad loaded";
   function Advertisement(pTarget, pDepth, pX, pY)
   {
      com.poptropica.util.Debug.trace("Advertisement::()",com.poptropica.util.Debug.VERBOSE_MESSAGE);
      mx.events.EventDispatcher.initialize(this);
      this.create(pTarget,pDepth,pX,pY);
   }
   function create(pTarget, pDepth, pX, pY)
   {
      this._mc = pTarget.createEmptyMovieClip("_ad" + pDepth,pDepth);
      this._mc._x = pX;
      this._mc._y = pY;
   }
   function loadAd(pAdPath)
   {
      com.poptropica.util.Debug.trace("Advertisement::loadAd()",com.poptropica.util.Debug.VERBOSE_MESSAGE);
      this._adPath = pAdPath;
      var me = this;
      var _loc3_ = new MovieClipLoader();
      var _loc2_ = new Object();
      _loc2_.onLoadInit = function()
      {
         me.setUpInteractivity();
         me.dispatchEvent({type:AD_LOADED,target:me});
      };
      _loc2_.onLoadError = function(target, errorCode, htmlCode)
      {
         com.poptropica.util.Debug.trace("Advertisement::loadAd()  onLoadError  errorCode=" + errorCode,com.poptropica.util.Debug.WARNING);
      };
      _loc3_.addListener(_loc2_);
      _loc3_.loadClip(this._adPath,this._mc);
   }
   function setUpInteractivity()
   {
      com.poptropica.util.Debug.trace("Advertisement:: setUpInteractivity()");
      this._mc.onRollOver = this._mc.onDragOver = com.poptropica.util.EventDelegate.create(this,this.onOverAction);
      this._mc.onRollOut = this._mc.onDragOut = com.poptropica.util.EventDelegate.create(this,this.onOutAction);
      this._mc.onPress = com.poptropica.util.EventDelegate.create(this,this.onPressAction);
   }
   function onPressAction()
   {
      com.poptropica.util.Debug.trace("Advertisement:: onPressAction()");
      this.dispatchEvent({type:AD_CLICK,target:this});
   }
   function onOutAction()
   {
      this.dispatchEvent({type:AD_OUT,target:this});
   }
   function onOverAction()
   {
      this.dispatchEvent({type:AD_OVER,target:this});
   }
   function get mc()
   {
      return this._mc;
   }
   function get data()
   {
      return this._data;
   }
   function set data(value)
   {
      this._data = value;
   }
   function addEventListener()
   {
   }
   function removeEventListener()
   {
   }
   function dispatchEvent()
   {
   }
}
