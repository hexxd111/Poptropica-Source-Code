class com.poptropica.controllers.commands.GetAdCommand extends com.poptropica.controllers.commands.CommandDispatcher
{
   var _island;
   var _override_island;
   var _override_offmain;
   var _testDataPath;
   var _type = "Standard";
   var _version = 2;
   static var local = false;
   function GetAdCommand()
   {
      super();
      com.poptropica.util.Debug.trace("GetAdCommand::()",com.poptropica.util.Debug.VERBOSE_MESSAGE);
   }
   function get type()
   {
      return this._type;
   }
   function set type(p)
   {
      this._type = p;
   }
   function get version()
   {
      return this._version;
   }
   function set version(p)
   {
      this._version = p;
   }
   function get testDataPath()
   {
      return this._testDataPath;
   }
   function set testDataPath(p)
   {
      this._testDataPath = p;
   }
   function get override_island()
   {
      return this._override_island;
   }
   function set override_island(p)
   {
      this._override_island = p;
   }
   function get override_offmain()
   {
      return this._override_offmain;
   }
   function set override_offmain(p)
   {
      this._override_offmain = p;
   }
   function exec()
   {
      com.poptropica.util.Debug.trace("GetAdCommand::exec() type : " + this._type,com.poptropica.util.Debug.VERBOSE_MESSAGE);
      var _loc5_ = com.poptropica.models.PopModel.getInstance();
      this._island = _loc5_.island;
      if(this._override_island != undefined)
      {
         this._island = this._override_island;
      }
      var _loc7_ = _loc5_.roomName;
      var _loc3_ = _loc7_ != "Main Street" ? 1 : 0;
      if(this._override_offmain != undefined)
      {
         _loc3_ = this._override_offmain;
      }
      var _loc6_;
      if(this._island == "Home" || this._island == "Party")
      {
         _loc6_ = new com.poptropica.controllers.events.CommandEvent(com.poptropica.controllers.events.CommandEvent.COMMAND_ERROR);
         _loc6_._message = "Error retrieving campaign : Invalid Island";
         this.dispatchEvent(_loc6_);
         return undefined;
      }
      var _loc4_ = _loc5_.getCampaignInfo(this._type,this._island,_loc3_);
      var _loc2_ = SharedObject.getLocal("campaignData","/");
      com.poptropica.util.Debug.trace("GetAdCommand checking saved data : " + _loc4_ + " args : " + [this._type,this._island,_loc3_],com.poptropica.util.Debug.VERBOSE_MESSAGE);
      if(_loc4_ != null)
      {
         this.notifyCommandComplete(_loc4_);
      }
      else if(_loc2_.data.islands[this._island] == undefined && !local)
      {
         if(_loc2_.data.islands == undefined)
         {
            _loc2_.data.islands = new Array();
         }
         _loc2_.data.islands[this._island] = true;
         _loc2_.flush();
         this.loadAd();
      }
      else
      {
         _loc6_ = new com.poptropica.controllers.events.CommandEvent(com.poptropica.controllers.events.CommandEvent.COMMAND_ERROR);
         _loc6_._message = "Error retrieving campaign : Invalid campaign data";
         this.dispatchEvent(_loc6_);
      }
   }
   function loadAd()
   {
      com.poptropica.util.Debug.trace("GetAdCommand:: loadAd() type : " + this._type,com.poptropica.util.Debug.VERBOSE_MESSAGE);
      var _loc8_ = com.poptropica.models.PopModel.getInstance();
      var _loc10_ = _loc8_.poptropica_user;
      var _loc7_ = [this._type];
      var _loc9_ = "/get_campaign_list.php";
      var _loc3_ = new LoadVars();
      var _loc5_ = new LoadVars();
      var _loc4_ = _loc10_.age;
      var _loc2_ = _loc10_.gender;
      if(this._type == "All")
      {
         _loc7_ = com.poptropica.models.AdCampaignType.all();
      }
      var _loc6_;
      if(_loc4_ == undefined)
      {
         _loc6_ = SharedObject.getLocal("Char","/");
         _loc4_ = _loc6_.data.age;
         _loc2_ = _loc6_.data.gender;
      }
      if(_loc2_ == 0)
      {
         _loc2_ = "F";
      }
      else
      {
         _loc2_ = "M";
      }
      _loc5_.onLoad = Delegate.create(this,this.parseAdData,_loc5_);
      utils.ArrayUtils.convertArrayToURLEncoding(_loc7_,"types",_loc3_);
      _loc3_.age = _loc4_;
      _loc3_.gender = _loc2_;
      _loc3_.island = this._island;
      if(this._testDataPath != undefined && _loc8_.isTestMode)
      {
         _loc9_ = this._testDataPath;
      }
      _loc3_.sendAndLoad(_loc9_,_loc5_,"POST");
   }
   function notifyCommandComplete(pInfoObj)
   {
      com.poptropica.util.Debug.trace("GetAdCommand:: notifyCommandComplete() type : " + this._type,com.poptropica.util.Debug.VERBOSE_MESSAGE);
      var _loc2_ = new com.poptropica.controllers.events.CommandEvent(com.poptropica.controllers.events.CommandEvent.COMMAND_COMPLETE);
      _loc2_._data = pInfoObj;
      this.dispatchEvent(_loc2_);
   }
   function parseAdData(success, data)
   {
      var _loc3_;
      var _loc5_;
      var _loc4_;
      if(success)
      {
         com.poptropica.util.Debug.trace("GetAdCommand:: data retrieved()" + data.on_main_json + " / " + data.off_main_json,com.poptropica.util.Debug.VERBOSE_MESSAGE);
         if(data.on_main_json != undefined)
         {
            this.parseJson(data.on_main_json,0);
         }
         if(data.off_main_json != undefined)
         {
            this.parseJson(data.off_main_json,1);
         }
         if(data.on_main_json == undefined && data.off_main_json == undefined)
         {
            _loc3_ = new com.poptropica.controllers.events.CommandEvent(com.poptropica.controllers.events.CommandEvent.COMMAND_ERROR);
            _loc3_._message = "Error retrieving campaign : Invalid campaign data";
            this.dispatchEvent(_loc3_);
         }
         else
         {
            _loc5_ = new com.poptropica.controllers.events.CommandEvent(com.poptropica.controllers.events.CommandEvent.COMMAND_COMPLETE);
            this.dispatchEvent(_loc5_);
         }
      }
      else
      {
         _loc4_ = new com.poptropica.controllers.events.CommandEvent(com.poptropica.controllers.events.CommandEvent.COMMAND_ERROR);
         _loc4_._message = "Error retrieving campaign : Failed onLoad for get campaign call";
         this.dispatchEvent(_loc4_);
      }
   }
   function saveAdData(type, data, island, offMain)
   {
      var _loc3_ = new com.poptropica.models.vo.AdvertisementVO(data.campaign_name,data.click_through_URL,data.impression_URL,data.campaign_file1,data.campaign_file2);
      com.poptropica.models.PopModel.getInstance().saveCampaignInfo(_loc3_,type,this._island,offMain);
      if(type == this.type)
      {
         this.notifyCommandComplete(_loc3_);
      }
   }
   function parseJson(json, offMain)
   {
      var _loc5_ = new asLib.JSON();
      var _loc2_ = _loc5_.parse(json);
      for(var _loc3_ in _loc2_)
      {
         this.saveAdData(_loc3_,_loc2_[_loc3_],this._island,offMain);
      }
   }
}
