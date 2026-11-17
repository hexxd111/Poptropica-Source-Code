class com.poptropica.util.SectionFactory
{
   function SectionFactory()
   {
   }
   static function getSectionURL(pSectionName)
   {
      com.poptropica.util.Debug.trace("SectionFactory::getSectionURL() pSectionName=" + pSectionName,com.poptropica.util.Debug.VERBOSE_MESSAGE);
      var _loc1_;
      switch(pSectionName)
      {
         case "home":
            _loc1_ = "pop_home.swf";
            com.poptropica.util.Debug.trace("\t\thome => " + _loc1_,com.poptropica.util.Debug.VERBOSE_MESSAGE);
            break;
         case "dailypop":
            _loc1_ = "pop_dailypop.swf";
            com.poptropica.util.Debug.trace("\t\tdailypop => " + _loc1_,com.poptropica.util.Debug.VERBOSE_MESSAGE);
            break;
         case "map":
            _loc1_ = "pop_map.swf";
            com.poptropica.util.Debug.trace("\t\tmap => " + _loc1_,com.poptropica.util.Debug.VERBOSE_MESSAGE);
            break;
         case "stats":
            _loc1_ = "pop_stats.swf";
            com.poptropica.util.Debug.trace("\t\tstats => " + _loc1_,com.poptropica.util.Debug.VERBOSE_MESSAGE);
            break;
         case "friends":
            _loc1_ = "pop_friends.swf";
            com.poptropica.util.Debug.trace("\t\tfriends => " + _loc1_,com.poptropica.util.Debug.VERBOSE_MESSAGE);
            break;
         case "friendshub":
            _loc1_ = "pop_friends_hub.swf";
            com.poptropica.util.Debug.trace("\t\tfriendshub => " + _loc1_,com.poptropica.util.Debug.VERBOSE_MESSAGE);
            break;
         default:
            _loc1_ = "";
            com.poptropica.util.Debug.trace("\t\thome => " + _loc1_,com.poptropica.util.Debug.VERBOSE_MESSAGE);
      }
      return _loc1_;
   }
}
