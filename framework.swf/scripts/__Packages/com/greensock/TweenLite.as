class com.greensock.TweenLite extends com.greensock.core.TweenCore
{
   var _delay;
   var _ease;
   var _hasPlugins;
   var _hasUpdate;
   var _notifyPluginsOfEnabled;
   var _overwrite;
   var _overwrittenProps;
   var _rawPrevTime;
   var _targetID;
   var active;
   var cachedDuration;
   var cachedPT1;
   var cachedPaused;
   var cachedReversed;
   var cachedStartTime;
   var cachedTime;
   var cachedTimeScale;
   var cachedTotalTime;
   var complete;
   var initted;
   var propTweenLookup;
   var ratio;
   var target;
   var vars;
   static var _timingClip;
   static var onPluginEvent;
   static var overwriteManager;
   static var rootFrame;
   static var rootFramesTimeline;
   static var rootTimeline;
   static var version = 11.35;
   static var plugins = {};
   static var killDelayedCallsTo = killTweensOf;
   static var defaultEase = easeOut;
   static var masterList = {};
   static var _cnt = -16000;
   static var _reservedProps = {ease:1,delay:1,overwrite:1,onComplete:1,onCompleteParams:1,useFrames:1,runBackwards:1,startAt:1,onUpdate:1,onUpdateParams:1,roundProps:1,onStart:1,onStartParams:1,onReverseComplete:1,onReverseCompleteParams:1,onRepeat:1,onRepeatParams:1,proxiedEase:1,easeParams:1,yoyo:1,onCompleteListener:1,onUpdateListener:1,onStartListener:1,orientToBezier:1,timeScale:1,immediateRender:1,repeat:1,repeatDelay:1,timeline:1,data:1,paused:1};
   function TweenLite(target, duration, vars)
   {
      super(duration,vars);
      var _loc7_;
      var _loc6_;
      if(_timingClip.onEnterFrame != updateAll)
      {
         _loc7_ = _root.getBytesLoaded() != undefined ? _root : findSubloadedSWF(_root);
         _loc6_ = 999;
         while(_loc7_.getInstanceAtDepth(_loc6_) != undefined)
         {
            _loc6_ = _loc6_ + 1;
         }
         _timingClip = _loc7_.createEmptyMovieClip("__tweenLite" + String(version).split(".").join("_"),_loc6_);
         _timingClip.onEnterFrame = updateAll;
         rootTimeline.cachedStartTime = getTimer() * 0.001;
         rootTimeline.cachedTotalTime = rootFramesTimeline.cachedTotalTime = 0;
         this.cachedStartTime = this._delay;
         rootFramesTimeline.cachedStartTime = rootFrame;
      }
      this.ratio = 0;
      this.target = target;
      this._targetID = getID(target,true);
      if(this.vars.timeScale != undefined && this.target instanceof com.greensock.core.TweenCore)
      {
         this.cachedTimeScale = 1;
      }
      this.propTweenLookup = {};
      this._ease = defaultEase;
      this._overwrite = !(vars.overwrite == undefined || !overwriteManager.enabled && vars.overwrite > 1) ? Number(vars.overwrite) : overwriteManager.mode;
      var _loc5_ = masterList[this._targetID].tweens;
      var _loc4_;
      if(_loc5_.length == 0)
      {
         _loc5_[0] = this;
      }
      else if(this._overwrite == 1)
      {
         _loc4_ = _loc5_.length;
         while((_loc4_ = _loc4_ - 1) > -1)
         {
            if(!_loc5_[_loc4_].gc)
            {
               _loc5_[_loc4_].setEnabled(false,false);
            }
         }
         masterList[this._targetID].tweens = [this];
      }
      else
      {
         _loc5_[_loc5_.length] = this;
      }
      if(this.active || this.vars.immediateRender)
      {
         this.renderTime(0,false,true);
      }
   }
   static function initClass()
   {
      rootFrame = 0;
      rootTimeline = new com.greensock.core.SimpleTimeline(null);
      rootFramesTimeline = new com.greensock.core.SimpleTimeline(null);
      rootTimeline.autoRemoveChildren = rootFramesTimeline.autoRemoveChildren = true;
      if(overwriteManager == undefined)
      {
         overwriteManager = {mode:1,enabled:false};
      }
   }
   function init()
   {
      if(this.vars.onInit)
      {
         this.vars.onInit.apply(null,this.vars.onInitParams);
      }
      var _loc2_;
      var _loc5_;
      var _loc3_;
      var _loc6_;
      var _loc7_;
      if(typeof this.vars.ease == "function")
      {
         this._ease = this.vars.ease;
      }
      if(this.vars.easeParams != undefined)
      {
         this.vars.proxiedEase = this._ease;
         this._ease = this.easeProxy;
      }
      this.cachedPT1 = undefined;
      this.propTweenLookup = {};
      for(_loc2_ in this.vars)
      {
         if(!(_reservedProps[_loc2_] && !(_loc2_ == "timeScale" && this.target instanceof com.greensock.core.TweenCore)))
         {
            if(plugins[_loc2_] && (_loc3_ = new plugins[_loc2_]()).onInitTween(this.target,this.vars[_loc2_],this))
            {
               this.cachedPT1 = new com.greensock.core.PropTween(_loc3_,"changeFactor",0,1,_loc3_.overwriteProps.length != 1 ? "_MULTIPLE_" : _loc3_.overwriteProps[0],true,this.cachedPT1);
               if(this.cachedPT1.name == "_MULTIPLE_")
               {
                  _loc5_ = _loc3_.overwriteProps.length;
                  while((_loc5_ = _loc5_ - 1) > -1)
                  {
                     this.propTweenLookup[_loc3_.overwriteProps[_loc5_]] = this.cachedPT1;
                  }
               }
               else
               {
                  this.propTweenLookup[this.cachedPT1.name] = this.cachedPT1;
               }
               if(_loc3_.priority)
               {
                  this.cachedPT1.priority = _loc3_.priority;
                  _loc6_ = true;
               }
               if(_loc3_.onDisable || _loc3_.onEnable)
               {
                  this._notifyPluginsOfEnabled = true;
               }
               this._hasPlugins = true;
            }
            else
            {
               this.cachedPT1 = new com.greensock.core.PropTween(this.target,_loc2_,Number(this.target[_loc2_]),typeof this.vars[_loc2_] != "number" ? Number(this.vars[_loc2_]) : Number(this.vars[_loc2_]) - this.target[_loc2_],_loc2_,false,this.cachedPT1);
               this.propTweenLookup[_loc2_] = this.cachedPT1;
            }
         }
      }
      if(_loc6_)
      {
         onPluginEvent("onInit",this);
      }
      var _loc4_;
      if(this.vars.runBackwards)
      {
         _loc4_ = this.cachedPT1;
         while(_loc4_)
         {
            _loc4_.start += _loc4_.change;
            _loc4_.change = - _loc4_.change;
            _loc4_ = _loc4_.nextNode;
         }
      }
      this._hasUpdate = Boolean(typeof this.vars.onUpdate == "function");
      if(this._overwrittenProps)
      {
         this.killVars(this._overwrittenProps);
         if(this.cachedPT1 == undefined)
         {
            this.setEnabled(false,false);
         }
      }
      if(this._overwrite > 1 && this.cachedPT1 && (_loc7_ = masterList[this._targetID].tweens) && _loc7_.length > 1)
      {
         if(overwriteManager.manageOverwrites(this,this.propTweenLookup,_loc7_,this._overwrite))
         {
            this.init();
         }
      }
      this.initted = true;
   }
   function renderTime(time, suppressEvents, force)
   {
      var _loc4_;
      var _loc5_ = this.cachedTime;
      if(time >= this.cachedDuration)
      {
         this.cachedTotalTime = this.cachedTime = this.cachedDuration;
         this.ratio = 1;
         _loc4_ = true;
         if(this.cachedDuration == 0)
         {
            if((time == 0 || this._rawPrevTime < 0) && this._rawPrevTime != time)
            {
               force = true;
            }
            this._rawPrevTime = time;
         }
      }
      else if(time <= 0)
      {
         this.cachedTotalTime = this.cachedTime = this.ratio = 0;
         if(time < 0)
         {
            this.active = false;
            if(this.cachedDuration == 0)
            {
               if(this._rawPrevTime > 0)
               {
                  force = true;
                  _loc4_ = true;
               }
               this._rawPrevTime = time;
            }
         }
         if(this.cachedReversed && _loc5_ != 0)
         {
            _loc4_ = true;
         }
      }
      else
      {
         this.cachedTotalTime = this.cachedTime = time;
         this.ratio = this._ease(time,0,1,this.cachedDuration);
      }
      if(this.cachedTime == _loc5_ && !force)
      {
         return undefined;
      }
      if(!this.initted)
      {
         this.init();
         if(!_loc4_ && this.cachedTime)
         {
            this.ratio = this._ease(this.cachedTime,0,1,this.cachedDuration);
         }
      }
      if(!this.active && !this.cachedPaused)
      {
         this.active = true;
      }
      if(_loc5_ == 0 && this.vars.onStart && this.cachedTime != 0 && !suppressEvents)
      {
         this.vars.onStart.apply(this.vars.onStartScope,this.vars.onStartParams);
      }
      var _loc2_ = this.cachedPT1;
      while(_loc2_)
      {
         _loc2_.target[_loc2_.property] = _loc2_.start + this.ratio * _loc2_.change;
         _loc2_ = _loc2_.nextNode;
      }
      if(this._hasUpdate && !suppressEvents)
      {
         this.vars.onUpdate.apply(this.vars.onUpdateScope,this.vars.onUpdateParams);
      }
      if(_loc4_)
      {
         if(this._hasPlugins && this.cachedPT1)
         {
            onPluginEvent("onComplete",this);
         }
         this.complete(true,suppressEvents);
      }
   }
   function killVars(vars, permanent)
   {
      if(this._overwrittenProps == undefined)
      {
         this._overwrittenProps = {};
      }
      var _loc3_;
      var _loc2_;
      var _loc5_;
      for(_loc3_ in vars)
      {
         if(this.propTweenLookup[_loc3_])
         {
            _loc2_ = this.propTweenLookup[_loc3_];
            if(_loc2_.isPlugin && _loc2_.name == "_MULTIPLE_")
            {
               _loc2_.target.killProps(vars);
               if(_loc2_.target.overwriteProps.length == 0)
               {
                  _loc2_.name = "";
               }
            }
            if(_loc2_.name != "_MULTIPLE_")
            {
               if(_loc2_.nextNode)
               {
                  _loc2_.nextNode.prevNode = _loc2_.prevNode;
               }
               if(_loc2_.prevNode)
               {
                  _loc2_.prevNode.nextNode = _loc2_.nextNode;
               }
               else if(this.cachedPT1 == _loc2_)
               {
                  this.cachedPT1 = _loc2_.nextNode;
               }
               if(_loc2_.isPlugin && _loc2_.target.onDisable)
               {
                  _loc2_.target.onDisable();
                  if(_loc2_.target.activeDisable)
                  {
                     _loc5_ = true;
                  }
               }
               delete this.propTweenLookup[_loc3_];
            }
         }
         if(permanent != false && vars != this._overwrittenProps)
         {
            this._overwrittenProps[_loc3_] = 1;
         }
      }
      return _loc5_;
   }
   function invalidate()
   {
      if(this._notifyPluginsOfEnabled)
      {
         onPluginEvent("onDisable",this);
      }
      this.cachedPT1 = undefined;
      this._overwrittenProps = undefined;
      this._hasUpdate = this.initted = this.active = this._notifyPluginsOfEnabled = false;
      this.propTweenLookup = {};
   }
   function setEnabled(enabled, ignoreTimeline)
   {
      var _loc3_;
      if(enabled)
      {
         _loc3_ = masterList[this._targetID].tweens;
         if(_loc3_)
         {
            _loc3_[_loc3_.length] = this;
         }
         else
         {
            masterList[this._targetID] = {target:this.target,tweens:[this]};
         }
      }
      super.setEnabled(enabled,ignoreTimeline);
      if(this._notifyPluginsOfEnabled && this.cachedPT1)
      {
         return onPluginEvent(!enabled ? "onDisable" : "onEnable",this);
      }
      return false;
   }
   function easeProxy(t, b, c, d)
   {
      return this.vars.proxiedEase.apply(null,arguments.concat(this.vars.easeParams));
   }
   static function to(target, duration, vars)
   {
      return new com.greensock.TweenLite(target,duration,vars);
   }
   static function from(target, duration, vars)
   {
      vars.runBackwards = true;
      if(vars.immediateRender != false)
      {
         vars.immediateRender = true;
      }
      return new com.greensock.TweenLite(target,duration,vars);
   }
   static function delayedCall(delay, onComplete, onCompleteParams, onCompleteScope, useFrames)
   {
      return new com.greensock.TweenLite(onComplete,0,{delay:delay,onComplete:onComplete,onCompleteParams:onCompleteParams,onCompleteScope:onCompleteScope,immediateRender:false,useFrames:useFrames,overwrite:0});
   }
   static function updateAll()
   {
      rootTimeline.renderTime((getTimer() * 0.001 - rootTimeline.cachedStartTime) * rootTimeline.cachedTimeScale,false,false);
      rootFrame++;
      rootFramesTimeline.renderTime((rootFrame - rootFramesTimeline.cachedStartTime) * rootFramesTimeline.cachedTimeScale,false,false);
      var _loc3_;
      var _loc2_;
      var _loc1_;
      if(!(rootFrame % 60))
      {
         _loc3_ = masterList;
         for(var _loc4_ in _loc3_)
         {
            _loc1_ = _loc3_[_loc4_].tweens;
            _loc2_ = _loc1_.length;
            while((_loc2_ = _loc2_ - 1) > -1)
            {
               if(_loc1_[_loc2_].gc)
               {
                  _loc1_.splice(_loc2_,1);
               }
            }
            if(_loc1_.length == 0)
            {
               delete _loc3_[_loc4_];
            }
         }
      }
   }
   static function killTweensOf(target, complete, vars)
   {
      var _loc6_ = getID(target,true);
      var _loc4_ = masterList[_loc6_].tweens;
      var _loc3_;
      var _loc1_;
      if(_loc4_ != undefined)
      {
         _loc3_ = _loc4_.length;
         while((_loc3_ = _loc3_ - 1) > -1)
         {
            _loc1_ = _loc4_[_loc3_];
            if(!_loc1_.gc)
            {
               if(complete == true)
               {
                  _loc1_.complete(false,false);
               }
               if(vars != undefined)
               {
                  _loc1_.killVars(vars);
               }
               if(vars == undefined || _loc1_.cachedPT1 == undefined && _loc1_.initted)
               {
                  _loc1_.setEnabled(false,false);
               }
            }
         }
         if(vars == undefined)
         {
            delete masterList[_loc6_];
         }
      }
   }
   static function getID(target, lookup)
   {
      var _loc2_;
      var _loc1_;
      if(lookup)
      {
         _loc1_ = masterList;
         if(typeof target == "movieclip")
         {
            if(_loc1_[String(target)] != undefined)
            {
               return String(target);
            }
            _loc2_ = String(target);
            masterList[_loc2_] = {target:target,tweens:[]};
            return _loc2_;
         }
         for(var _loc3_ in _loc1_)
         {
            if(_loc1_[_loc3_].target == target)
            {
               return _loc3_;
            }
         }
      }
      _cnt++;
      _loc2_ = "t" + _cnt;
      masterList[_loc2_] = {target:target,tweens:[]};
      return _loc2_;
   }
   static function easeOut(t, b, c, d)
   {
      return -1 * (t /= d) * (t - 2);
   }
   static function findSubloadedSWF(mc)
   {
      for(var _loc3_ in mc)
      {
         if(typeof mc[_loc3_] == "movieclip")
         {
            if(mc[_loc3_]._url != _root._url && mc[_loc3_].getBytesLoaded() != undefined)
            {
               return mc[_loc3_];
            }
            if(findSubloadedSWF(mc[_loc3_]) != undefined)
            {
               return findSubloadedSWF(mc[_loc3_]);
            }
         }
      }
      return undefined;
   }
}
