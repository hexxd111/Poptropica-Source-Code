class com.poptropica.models.PopModelConst
{
   static var _avatar;
   static var _dbID;
   static var _gameplayCamera;
   static var _gameplayMC;
   static var _island;
   static var _lastPrefixUpdate;
   static var _navbarMC;
   static var _poptropicaUser;
   static var _roomName;
   static var _section;
   static var _state;
   static var _gameplayWidth = 640;
   static var _gameplayHeight = 480;
   static var _prefix = "";
   static var _gameplayX = 0;
   static var _gameplayY = 0;
   function PopModelConst()
   {
   }
   static function get gameplayWidth()
   {
      return _gameplayWidth;
   }
   static function get gameplayHeight()
   {
      return _gameplayHeight;
   }
   static function set gameplayWidth(w)
   {
      _gameplayWidth = w;
   }
   static function set gameplayHeight(h)
   {
      _gameplayHeight = h;
   }
   static function set state(h)
   {
      _state = h;
   }
   static function get state()
   {
      return _state;
   }
   static function set island(h)
   {
      _island = h;
   }
   static function get island()
   {
      return _island;
   }
   static function set roomName(h)
   {
      _roomName = h;
   }
   static function get roomName()
   {
      return _roomName;
   }
   static function set dbID(h)
   {
      _dbID = h;
   }
   static function get dbID()
   {
      return _dbID;
   }
   static function get prefix()
   {
      return _prefix;
   }
   static function set prefix(h)
   {
      _prefix = h;
   }
   static function get lastPrefixUpdate()
   {
      return _lastPrefixUpdate;
   }
   static function set lastPrefixUpdate(h)
   {
      _lastPrefixUpdate = h;
   }
   static function set poptropicaUser(h)
   {
      _poptropicaUser = h;
   }
   static function get poptropicaUser()
   {
      return _poptropicaUser;
   }
   static function get gameplayX()
   {
      return _gameplayX;
   }
   static function get gameplayY()
   {
      return _gameplayY;
   }
   static function set gameplayX(pX)
   {
      _gameplayX = pX;
   }
   static function set gameplayY(pY)
   {
      _gameplayY = pY;
   }
   static function get gameplayCamera()
   {
      return _gameplayCamera;
   }
   static function set gameplayCamera(pC)
   {
      _gameplayCamera = pC;
   }
   static function get navbarMC()
   {
      return _navbarMC;
   }
   static function set navbarMC(pC)
   {
      _navbarMC = pC;
   }
   static function get gameplayMC()
   {
      return _gameplayMC;
   }
   static function set gameplayMC(pC)
   {
      _gameplayMC = pC;
   }
   static function get avatar()
   {
      return _avatar;
   }
   static function set avatar(pC)
   {
      _avatar = pC;
   }
   static function get section()
   {
      return _section;
   }
   static function set section(section)
   {
      _section = section;
   }
}
