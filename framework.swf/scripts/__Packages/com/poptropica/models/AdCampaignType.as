class com.poptropica.models.AdCampaignType
{
   static var MAIN_STREET = "Main Street";
   static var BILLBOARD = "Billboard";
   static var WRAPPER = "Wrapper";
   static var AUTOCARD = "AutoCard";
   static var HOME_CAROUSEL = "Home Page Carousel";
   static var HOME_SMALL_PROMO = "Home Page Small Promo";
   static var COMICS_INDEX = "Comics Index";
   static var COMICS_VIEWER = "Comics Viewer";
   static var GAMES_INDEX = "Games Index";
   static var LOGOUT = "Logout";
   function AdCampaignType()
   {
   }
   static function all()
   {
      return [MAIN_STREET,BILLBOARD,WRAPPER,AUTOCARD,HOME_SMALL_PROMO,HOME_CAROUSEL,COMICS_INDEX,COMICS_VIEWER,GAMES_INDEX,LOGOUT];
   }
}
