class com.poptropica.util.Prototype
{
   function Prototype()
   {
   }
   static function forceAllRelativeLoadClipCallsToUseAbsURLsBasedOnRootDomain()
   {
      com.poptropica.util.Debug.trace("Prototype::forceAllRelativeLoadClipCallsToUseAbsURLsBasedOnRootDomain()",com.poptropica.util.Debug.VERBOSE_MESSAGE);
      var flashPrefix = com.poptropica.util.PopUtils.getFlashPrefixFromLocalConnection();
      var baseLoadClip = MovieClipLoader.prototype.loadClip;
      MovieClipLoader.prototype.loadClip = function(uri, tgt)
      {
         if(uri.indexOf("http://") != 0 && uri.indexOf("https://") != 0)
         {
            uri = flashPrefix + uri;
         }
         return baseLoadClip.call(this,uri,tgt);
      };
   }
}
