class multiplayer.MultiUserObjectManager
{
   static var mBaseScope;
   static var mGroup;
   static var mInitialized = false;
   static var mCreateForNewUserTimer = null;
   static var mNewUserData = null;
   static var CREATE_FOR_NEW_USER_UPDATE = 1000;
   function MultiUserObjectManager()
   {
   }
   static function init(baseScope)
   {
      mGroup = new GroupManager();
      mBaseScope = baseScope;
      mInitialized = true;
      utils.Logger.setWarningLevel(utils.Logger.VERBOSE);
   }
   static function reset()
   {
      stopCreateForNewUser();
      mGroup.deleteAllElements();
      mInitialized = false;
      mGroup = null;
      mBaseScope = null;
      mCreateForNewUserTimer = null;
      mNewUserData = null;
      utils.Logger.log("MultiUserObjectManager :: resetting...",utils.Logger.ALL);
   }
   static function createNew(type, scope, baseScope, x, y)
   {
      if(!mInitialized)
      {
         init(baseScope);
      }
      var _loc6_;
      var _loc3_ = getElementsOfType(type);
      if(_loc3_.length > 0)
      {
         _loc6_ = _loc3_[0];
         if(!_loc6_.allowMultipleInstances())
         {
            utils.Logger.log("MultiUserObjectManager :: object of type " + type + " already exists.  No more can be created.",utils.Logger.WARNING);
            return undefined;
         }
      }
      var _loc5_ = ["create"];
      utils.Logger.log("MultiUserObjectManager :: createNew : " + _loc5_.concat(arguments),utils.Logger.ALL);
      var _loc4_ = Math.floor(Math.random() * 10000);
      var _loc2_ = _loc5_.concat(arguments);
      sendAction(_loc4_,_loc2_);
      _loc2_[0] = "createForNewUser";
      mNewUserData = new Object();
      mNewUserData.id = _loc4_;
      mNewUserData.params = _loc2_;
   }
   static function create(id, type, scope, baseScope, x, y)
   {
      utils.Logger.log("MultiUserObjectManager :: create : " + arguments,utils.Logger.ALL);
      if(typeof type == "string")
      {
         type = Number(type);
      }
      if(typeof scope == "string")
      {
         scope = eval(scope);
      }
      if(typeof baseScope == "string")
      {
         baseScope = eval(baseScope);
      }
      if(typeof id == "string")
      {
         id = Number(id);
      }
      if(!mInitialized)
      {
         init(baseScope);
      }
      var multiUserObject;
      var multiUserObjects = getElementsOfType(type);
      if(multiUserObjects.length > 0)
      {
         if(mGroup.getElementByID(id,type) != null)
         {
            utils.Logger.log("MultiUserObjectManager :: object with id " + id + " already exists.",utils.Logger.WARNING);
            return undefined;
         }
         multiUserObject = multiUserObjects[0];
         if(!multiUserObject.allowMultipleInstances())
         {
            utils.Logger.log("MultiUserObjectManager :: object of type " + type + " already exists.  No more can be created.",utils.Logger.WARNING);
            return undefined;
         }
      }
      switch(type)
      {
         case multiplayer.MultiUserObjectType.FORTUNE_COOKIE:
            multiUserObject = new multiplayer.FortuneCookie(scope);
            multiplayer.FortuneCookie(multiUserObject).show();
            break;
         case multiplayer.MultiUserObjectType.PRANK_CAN:
            multiUserObject = new multiplayer.PrankCan(scope);
            multiplayer.PrankCan(multiUserObject).show();
            break;
         default:
            utils.Logger.log("MultiUserObjectManager :: Unknown object type : " + type,utils.Logger.ERROR);
            return undefined;
      }
      mGroup.addElement(multiUserObject,id,type);
      multiUserObject.setBaseScope(baseScope);
      multiUserObject.setPosition(Number(x),Number(y));
      multiUserObject.setID(id);
      multiUserObject.setType(type);
      if(mNewUserData != null)
      {
         if(type == multiplayer.MultiUserObjectType.FORTUNE_COOKIE)
         {
            multiUserObject.broadcastUserName();
            var randomFortune = multiplayer.FortuneCookie(multiUserObject).getRandomFortune();
            sendAction(id,["setFortune",randomFortune]);
         }
         if(type == multiplayer.MultiUserObjectType.PRANK_CAN)
         {
            sendAction(id,["setPrank",_global.prank,_global.canFrame]);
         }
         startCreateForNewUser();
      }
      return multiUserObject;
   }
   static function createForNewUser(id, type, scope, baseScope, x, y, arg1, arg2, arg3)
   {
      if(typeof id == "string")
      {
         id = Number(id);
      }
      if(typeof type == "string")
      {
         type = Number(type);
      }
      if(typeof baseScope == "string")
      {
         baseScope = eval(baseScope);
      }
      if(!mInitialized)
      {
         init(baseScope);
      }
      utils.Logger.log("MultiUserObjectManager :: id is : " + mGroup.getElementByID(id,type) + " for id : " + id,utils.Logger.VERBOSE);
      if(mGroup.getElementByID(id,type) == null)
      {
         utils.Logger.log("MultiUserObjectManager :: createForNewUser( " + arguments + " )",utils.Logger.ALL);
         var multiUserObject = create(id,type,scope,baseScope,x,y);
         switch(type)
         {
            case multiplayer.MultiUserObjectType.FORTUNE_COOKIE:
               multiplayer.FortuneCookie(multiUserObject).setObjectClicks(Number(arg1));
               multiUserObject.setLeaderUserName(arg2);
               multiplayer.FortuneCookie(multiUserObject).setFortune(arg3);
               break;
            case multiplayer.MultiUserObjectType.PRANK_CAN:
               multiplayer.PrankCan(multiUserObject).setObjectClicks(Number(arg1));
               multiplayer.PrankCan(multiUserObject).setPrank(arg2,arg3);
               break;
            default:
               utils.Logger.log("MultiUserObjectManager :: Unknown object type : " + type,utils.Logger.ERROR);
         }
         return multiUserObject;
      }
   }
   static function objectClicked(id, total)
   {
      if(typeof id == "string")
      {
         id = Number(id);
      }
      if(typeof total == "string")
      {
         total = Number(total);
      }
      var _loc3_ = mGroup.getElementByID(id);
      _loc3_.objectClicked(total);
   }
   static function removeObject(id)
   {
      if(typeof id == "string")
      {
         id = Number(id);
      }
      if(mGroup.getTotalGroupElements() < 2)
      {
         stopCreateForNewUser();
      }
      var _loc2_ = mGroup.getElementByID(id);
      _loc2_.removeObject();
      mGroup.removeElement(id);
   }
   static function sendAction(id, params)
   {
      utils.Logger.log("MultiUserObjectManager :: Sending Action *******\nred5 : " + mBaseScope.camera.scene.red5 + "\nserver : " + mBaseScope.server + "\nid : " + id + "\nparams: " + params,utils.Logger.VERBOSE);
      var _loc1_;
      var _loc3_;
      if(mBaseScope.camera.scene.red5 && mBaseScope.server)
      {
         _loc1_ = params.slice();
         _loc3_ = _loc1_[0];
         _loc1_.unshift(id);
         _loc1_[0] = _loc3_;
         _loc1_[1] = id;
         mBaseScope.server.call("emotion",null,"multiUserObjectAction",_loc1_.join(", "));
      }
   }
   static function setLeaderUserName(id, name)
   {
      if(typeof id == "string")
      {
         id = Number(id);
      }
      var _loc2_ = mGroup.getElementByID(id);
      _loc2_.setLeaderUserName(name);
   }
   static function setFortune(id, fortune)
   {
      if(typeof id == "string")
      {
         id = Number(id);
      }
      var _loc2_ = mGroup.getElementByID(id);
      _loc2_.setFortune(fortune);
   }
   static function setPrank(id, prank, frame)
   {
      if(typeof id == "string")
      {
         id = Number(id);
      }
      var _loc2_ = mGroup.getElementByID(id);
      _loc2_.setPrank(prank,frame);
   }
   static function startCreateForNewUser()
   {
      var _loc4_ = mNewUserData.id;
      var _loc5_ = mNewUserData.params;
      var _loc2_ = mGroup.getElementByID(_loc4_);
      var _loc6_;
      var _loc3_;
      if(_loc4_ != undefined && _loc5_ != undefined && _loc2_ != undefined && _loc2_ != null)
      {
         mCreateForNewUserTimer = _global.setTimeout(Delegate.create(multiplayer.MultiUserObjectManager,startCreateForNewUser),CREATE_FOR_NEW_USER_UPDATE);
         _loc6_ = _loc2_.getType();
         _loc3_ = _loc5_.slice();
         switch(_loc6_)
         {
            case multiplayer.MultiUserObjectType.FORTUNE_COOKIE:
               _loc3_.push(_loc2_.getObjectClickTotal());
               _loc3_.push(_loc2_.getLeaderUserName());
               _loc3_.push(multiplayer.FortuneCookie(_loc2_).getFortune());
               break;
            case multiplayer.MultiUserObjectType.PRANK_CAN:
               _loc3_.push(_loc2_.getObjectClickTotal());
               _loc3_.push(multiplayer.PrankCan(_loc2_).getPrank());
               _loc3_.push(multiplayer.PrankCan(_loc2_).getCanFrame());
               break;
            default:
               utils.Logger.log("MultiUserObjectManager :: Unknown object type : " + _loc6_,utils.Logger.ERROR);
         }
         sendAction(_loc4_,_loc3_);
      }
      else
      {
         utils.Logger.log("MultiUserObjectManager :: Aborting create of null object.",utils.Logger.ERROR);
      }
   }
   static function stopCreateForNewUser()
   {
      _global.clearTimeout(mCreateForNewUserTimer);
      mCreateForNewUserTimer = null;
      mNewUserData = null;
   }
   static function getElementsOfType(type)
   {
      return mGroup.getGroup(type);
   }
}
