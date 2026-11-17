class com.poptropica.controllers.commands.TrackCommand extends com.poptropica.controllers.commands.CommandDispatcher
{
   function TrackCommand()
   {
      super();
      com.poptropica.util.Debug.trace("TrackCommand::()",com.poptropica.util.Debug.VERBOSE_MESSAGE);
   }
   function exec(CampaignName, EventToTrack, ChoiceName, SubChoiseName, trackScene)
   {
      com.poptropica.util.Debug.trace("TrackCommand::exec()",com.poptropica.util.Debug.VERBOSE_MESSAGE);
      if(trackScene == undefined || trackScene == null)
      {
         trackScene = false;
      }
      var _loc1_ = com.poptropica.models.PopModel.getInstance();
      var _loc2_ = _loc1_.poptropica_user;
      var _loc8_ = _loc2_.gender;
      var _loc7_ = _loc2_.language;
      var _loc10_ = _loc2_.grade;
      var _loc3_;
      var _loc4_;
      if(trackScene)
      {
         _loc3_ = _loc1_.roomName;
         _loc4_ = String(_loc1_.getIslandProperty(_loc1_.island,"cluster_name"));
      }
      else
      {
         _loc3_ = "";
         _loc4_ = "";
      }
      loadVariablesNum("/brain/track.php?cluster=" + escape(_loc4_) + "&scene=" + escape(_loc3_) + "&campaign=" + escape(CampaignName) + "&event=" + escape(EventToTrack) + "&grade=" + _loc10_ + "&gender=" + _loc8_ + "&lang=" + _loc7_ + (!ChoiceName ? "" : "&choice=" + escape(ChoiceName)) + (!SubChoiseName ? "" : "&subchoice=" + escape(SubChoiseName)) + "&brain=Poptropica&randomNumber=" + random(10000),0);
   }
}
