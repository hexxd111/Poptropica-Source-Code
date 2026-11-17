class utils.Logger
{
   static var LOG_PREFIX = "log : ";
   static var VERBOSE = 0;
   static var ALL = 1;
   static var WARNING = 2;
   static var ERROR = 3;
   static var mWarningLevel = ALL;
   function Logger()
   {
      trace("Logger is a static class and should not be instantiated.");
   }
   static function log(message, warningLevel)
   {
      if(warningLevel >= mWarningLevel)
      {
         trace(LOG_PREFIX + message);
      }
   }
   static function setWarningLevel(warningLevel)
   {
      trace("Logger :: Setting warning level : " + warningLevel);
      mWarningLevel = warningLevel;
   }
}
