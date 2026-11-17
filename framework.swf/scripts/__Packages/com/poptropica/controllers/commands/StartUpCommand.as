class com.poptropica.controllers.commands.StartUpCommand extends com.poptropica.controllers.commands.CommandDispatcher
{
   var _rt_target;
   function StartUpCommand(pMvClip)
   {
      super();
      com.poptropica.util.Debug.trace("StartupCommand::()",com.poptropica.util.Debug.VERBOSE_MESSAGE);
      this._rt_target = pMvClip;
   }
   function exec()
   {
      com.poptropica.util.Debug.trace("StartUpCommand::exec()",com.poptropica.util.Debug.VERBOSE_MESSAGE);
      var _loc2_ = com.poptropica.models.PopModel.getInstance();
      var _loc5_ = com.poptropica.controllers.PopController.getInstance(_loc2_);
      com.poptropica.util.Prototype.forceAllRelativeLoadClipCallsToUseAbsURLsBasedOnRootDomain();
      _loc2_.isTestMode = !com.poptropica.util.PopUtils.isURLLive(this._rt_target._url);
      _loc2_.rt_mc = this._rt_target;
      this.setUpRootJSFunction();
      com.poptropica.util.Debug.trace("_rt_target.state=" + this._rt_target.state,com.poptropica.util.Debug.VERBOSE_MESSAGE);
      if(!this._rt_target.state)
      {
         _loc2_.state = com.poptropica.models.PopAppStates.RETURN_USER_STANDARD;
      }
      else
      {
         _loc2_.state = this._rt_target.state;
      }
      if(!this._rt_target.startup_path)
      {
         _loc2_.startup_path = "gameplay";
      }
      else
      {
         _loc2_.startup_path = this._rt_target.startup_path;
      }
      var _loc3_ = this._rt_target.island;
      var _loc4_ = this._rt_target.desc;
      if(_loc3_ == undefined)
      {
         _loc3_ = "Home";
      }
      if(_loc4_ == undefined)
      {
         _loc4_ = "Home";
      }
      if(_loc3_ == "Home")
      {
         _loc2_.cleanOutCampaignData();
      }
      _loc2_.island = _loc3_;
      _loc2_.desc = _loc4_;
      _loc2_.gameplay_url = "gameplay.swf";
      _loc5_.loadingSequenceComplete("startup");
   }
   function setUpRootJSFunction()
   {
      var _loc2_ = com.poptropica.models.PopModel.getInstance();
      var mPopController = com.poptropica.controllers.PopController.getInstance(_loc2_);
      this._rt_target.JSToAS2Bridge = function(pDataStr)
      {
         com.poptropica.controllers.PopController(mPopController).sendUpdateNotification(com.poptropica.models.PopUpdateNotificationTypes.JS_TO_AS2_BRIDGE_EVENT,pDataStr);
      };
   }
   function notifyCommandComplete()
   {
      this.dispatchEvent(new com.poptropica.controllers.events.CommandEvent(com.poptropica.controllers.events.CommandEvent.COMMAND_COMPLETE));
   }
}
