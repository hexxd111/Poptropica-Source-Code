class com.poptropica.controllers.PopController extends com.poptropica.mvc.AbstractController
{
   var _getPrefixCommand;
   var _getXMLCommand;
   var _model;
   static var instance;
   function PopController(cm)
   {
      super(cm);
      com.poptropica.util.Debug.trace("PopController::()",com.poptropica.util.Debug.VERBOSE_MESSAGE);
   }
   static function getInstance(cm)
   {
      if(instance == undefined)
      {
         instance = new com.poptropica.controllers.PopController(cm);
      }
      return instance;
   }
   function initProfileData()
   {
      var _loc3_ = new com.poptropica.models.proxy.profile.StatusProxy();
      _loc3_.loadData(this.onProfileStatusDataLoaded);
      var _loc4_ = new com.poptropica.models.proxy.profile.PrivacyProxy();
      _loc4_.loadData(this.onProfilePrivacyDataLoaded);
      var _loc2_ = new com.poptropica.models.proxy.badges.AlbumsProxy();
      _loc2_.loadData(this.onProfileAlbumsDataLoaded);
   }
   function onProfileAlbumSelected(albumId, setOffset, nSets)
   {
      var _loc2_ = new com.poptropica.models.proxy.badges.AlbumPageProxy();
      _loc2_.loadData(this.onProfileAlbumPageDataLoaded,albumId,setOffset,nSets);
   }
   function onProfileBadgeSetSelected(badgeSetId)
   {
      var _loc2_ = new com.poptropica.models.proxy.badges.BadgeSetProxy();
      _loc2_.loadData(this.onProfileBadgeSetDataLoaded,badgeSetId);
   }
   function onProfilePrivacySelected(privacyId)
   {
      var _loc2_ = new com.poptropica.models.proxy.profile.PrivacyProxy();
      _loc2_.sendData(this.onPrivacySet,privacyId);
   }
   function onProfileStatusSelected(messageId)
   {
      var _loc2_ = new com.poptropica.models.proxy.profile.StatusProxy();
      _loc2_.sendData(this.onStatusSet,messageId);
   }
   function onProfileAlbumPageDataLoaded(pData)
   {
      com.poptropica.models.PopModel(this._model).albumPageVO = new com.poptropica.models.vo.badges.AlbumPageVO(pData);
   }
   function onProfileBadgeSetDataLoaded(pData)
   {
      com.poptropica.models.PopModel(this._model).badgeSetVO = new com.poptropica.models.vo.badges.BadgeSetVO(pData);
   }
   function onStatusSet(pData)
   {
      trace("PopController :: onStatusSet() - server respons: " + pData);
   }
   function onPrivacySet(pData)
   {
      trace("PopController :: onPrivacySet() - server respons: " + pData);
   }
   function markClipsViewed(pArrayOfIds)
   {
      var _loc1_ = new com.poptropica.models.proxy.dailyPop.MarkCreatorClipsViewed();
      _loc1_.sendData(null,pArrayOfIds);
   }
   function initDailyPopGameDetailsPageData(pGameId)
   {
      var _loc2_ = new com.poptropica.models.proxy.dailyPop.GameDetailsProxy();
      _loc2_.loadData(com.poptropica.util.EventDelegate.create(this,this.onDailyPopGameDetailsDataLoaded),pGameId);
   }
   function onDailyPopGameDetailsDataLoaded(pData)
   {
      com.poptropica.models.PopModel(this._model).setDailyPopGameDetailsData(new com.poptropica.models.vo.dailyPopVO.GameDetailsVO(pData));
   }
   function initDailyPopGameIndexPageData(pPartnerId)
   {
      var _loc2_;
      if(com.poptropica.models.PopModel(this._model).dailyPopGameIndexPageVO)
      {
         com.poptropica.models.PopModel(this._model).notifyObserversAboutGamesIndexPageDataSet();
      }
      else
      {
         _loc2_ = new com.poptropica.models.proxy.dailyPop.GamesProxy();
         _loc2_.loadData(com.poptropica.util.EventDelegate.create(this,this.onDailyPopGamesDataLoaded),pPartnerId);
      }
   }
   function initDailyPopChallengesQuizTypesData()
   {
      var _loc2_;
      if(!com.poptropica.models.PopModel(this._model).getChallengesVO().quizeTypesCollection)
      {
         _loc2_ = new com.poptropica.models.proxy.dailyPop.challenges.QuizeTypesProxy();
         _loc2_.loadData(com.poptropica.util.EventDelegate.create(this,this.onDailyPopChallengeQuizeTypesLoaded));
      }
      else
      {
         com.poptropica.models.PopModel(this._model).notifyQuizesTypesLoaded();
      }
   }
   function initDailyPopChallengesOfTheDayData()
   {
      var _loc2_;
      if(!com.poptropica.models.PopModel(this._model).getChallengesVO().challengeOfTheDay)
      {
         _loc2_ = new com.poptropica.models.proxy.dailyPop.challenges.ChallengeOfTheDayProxy();
         _loc2_.loadData(com.poptropica.util.EventDelegate.create(this,this.onDailyPopChallengeOfTheDayLoaded));
      }
      else
      {
         com.poptropica.models.PopModel(this._model).notifyChallengesOfTheDayLoaded();
      }
   }
   function onDailyPopChallengeQuizeTypesLoaded(pData)
   {
      com.poptropica.models.PopModel(this._model).setQuizesTypes(pData);
   }
   function onDailyPopChallengeOfTheDayLoaded(pData)
   {
      com.poptropica.models.PopModel(this._model).setChallengesOfTheDay(pData);
   }
   function initDailyPopChallengesGetQuizes(pQuantity, pOffset, pType, pChallengeQuizId)
   {
      var _loc1_ = new com.poptropica.controllers.commands.dailyPop.challenges.GetQuizesCommand();
      _loc1_.exec(pQuantity,pOffset,pType,pChallengeQuizId);
   }
   function sendQuizResult(pQuizId, pScore, pWinLoss, pTime, pPersonalHighScore)
   {
      var _loc1_ = new com.poptropica.models.proxy.dailyPop.challenges.SubmitQuizProxy();
      _loc1_.sendData(null,pQuizId,pScore,pWinLoss,pTime,pPersonalHighScore);
   }
   function initUserChallengesResult(pChallengeQuizId)
   {
      var _loc1_ = new com.poptropica.controllers.commands.dailyPop.challenges.GetUserCResultCommand();
      _loc1_.exec(pChallengeQuizId);
   }
   function sendUserChallengeResult(pChallangesId)
   {
      var _loc2_ = new com.poptropica.models.proxy.dailyPop.challenges.SetUserChallengeResultProxy();
      _loc2_.loadData(undefined,pChallangesId);
      com.poptropica.models.PopModel(this._model).setUserChallengesResult(pChallangesId);
   }
   function initUserItemsRatingData(pArrayOfIds)
   {
      var _loc2_ = new com.poptropica.models.proxy.rating.UserRatingProxy();
      _loc2_.loadData(com.poptropica.util.EventDelegate.create(this,this.onUserItemsRatingDataLoaded),pArrayOfIds);
   }
   function initAgrigateItemsRatingData(pArrayOfIds)
   {
      var _loc2_ = new com.poptropica.models.proxy.rating.ItemsRatingsProxy();
      _loc2_.loadData(com.poptropica.util.EventDelegate.create(this,this.onUserItemsRatingDataLoaded),pArrayOfIds);
   }
   function onUserItemsRatingDataLoaded(pData)
   {
      com.poptropica.models.PopModel(this._model).setUserItemsRatingData(new com.poptropica.models.vo.rating.RatingVO(pData));
   }
   function userRateItem(pItemId, pRate)
   {
      var _loc2_ = new com.poptropica.models.proxy.rating.UserRateItemProxy();
      _loc2_.loadData(com.poptropica.util.EventDelegate.create(this,this.onUserRateItemDataLoaded),pItemId,pRate);
   }
   function onUserRateItemDataLoaded(pData)
   {
      com.poptropica.util.Debug.trace("PopController::onUserRateItemDataLoaded() -> answer = " + unescape(pData),com.poptropica.util.Debug.VERBOSE_MESSAGE);
   }
   function onDailyPopGamesDataLoaded(pData)
   {
      com.poptropica.models.PopModel(this._model).setDailyPopGameIndexPageData(com.poptropica.util.DailyPopUtils.parseDailyPopGamesData(pData));
   }
   function initDailyPopComicHomePageData()
   {
      var _loc2_;
      if(com.poptropica.models.PopModel(this._model).dailyPopComicHomePageVO)
      {
         com.poptropica.models.PopModel(this._model).notifyObserversAboutComicHomePageDataSet();
      }
      else
      {
         _loc2_ = new com.poptropica.models.proxy.dailyPop.ComicsProxy();
         _loc2_.loadData(com.poptropica.util.EventDelegate.create(this,this.onDailyPopComicsDataLoaded));
      }
   }
   function initComicViewerVoData(pId, pUserName, pDbId, pComicTitle)
   {
      var _loc2_ = new com.poptropica.models.proxy.ComicStripsProxy();
      _loc2_.loadData(com.poptropica.util.EventDelegate.create(this,this.onComicViewerVoDataLoaded,pComicTitle,pId),pId,pUserName,pDbId);
   }
   function initDailyPopSneakPeeksData(offset)
   {
      var _loc2_;
      if(com.poptropica.models.PopModel(this._model).listSneakPeeksVO && com.poptropica.models.PopModel(this._model).offsetSneakPeeks == offset)
      {
         com.poptropica.models.PopModel(this._model).notifyObserversAboutSneakPeekDataSet();
      }
      else
      {
         com.poptropica.models.PopModel(this._model).offsetSneakPeeks = offset;
         _loc2_ = new com.poptropica.models.proxy.dailyPop.SneakPeeksProxy();
         _loc2_.loadData(com.poptropica.util.EventDelegate.create(this,this.onDailyPopSneakPeeksDataLoaded));
      }
   }
   function onDailyPopSneakPeeksDataLoaded(pData)
   {
      com.poptropica.models.PopModel(this._model).setDailyPopSneakPeeksData(com.poptropica.util.DailyPopUtils.parseSneakPeeksData(pData));
   }
   function initDailyPopSneakPeeksPreviousData(offset)
   {
      com.poptropica.models.PopModel(this._model).offsetSneakPeeks = offset;
      var _loc2_ = new com.poptropica.models.proxy.dailyPop.SneakPeeksProxy();
      _loc2_.loadData(com.poptropica.util.EventDelegate.create(this,this.onDailyPopSneakPeeksPreviousDataLoaded));
   }
   function onDailyPopSneakPeeksPreviousDataLoaded(pData)
   {
      com.poptropica.models.PopModel(this._model).setDailyPopSneakPeeksPreviousData(com.poptropica.util.DailyPopUtils.parseSneakPeeksData(pData));
   }
   function initDailyPopSneakPeeksPreviewData(offset)
   {
      com.poptropica.models.PopModel.getInstance().offsetSneakPeeks = offset;
      var _loc2_ = new com.poptropica.models.proxy.dailyPop.SneakPeeksProxy();
      _loc2_.loadData(com.poptropica.util.EventDelegate.create(this,this.onDailyPopSneakPeeksPreviewDataLoaded));
   }
   function onDailyPopSneakPeeksPreviewDataLoaded(pData)
   {
      com.poptropica.models.PopModel.getInstance().setDailyPopSneakPeeksPreviewData(com.poptropica.util.DailyPopUtils.parseSneakPeeksData(pData));
   }
   function copyDailyPopSneakPeeksPreview()
   {
      com.poptropica.models.PopModel(this._model).copyDailyPopSneakPeeksPreview();
   }
   function initDailyPopCreatorClipsData()
   {
      var _loc2_;
      if(com.poptropica.models.PopModel(this._model).listCreatorClipsVO)
      {
         com.poptropica.models.PopModel(this._model).notifyObserversAboutCreatorClipsDataSet();
      }
      else
      {
         _loc2_ = new com.poptropica.models.proxy.dailyPop.GetCreatorClipsProxy();
         _loc2_.loadData(com.poptropica.util.EventDelegate.create(this,this.onDailyPopCreatorClipsDataLoaded));
      }
   }
   function onDailyPopCreatorClipsDataLoaded(pData)
   {
      com.poptropica.models.PopModel(this._model).setDailyPopCreatorClipsData(com.poptropica.util.DailyPopUtils.parseSneakPeeksData(pData));
   }
   function onDailyPopComicsDataLoaded(pData)
   {
      com.poptropica.models.PopModel(this._model).setDailyPopComicData(com.poptropica.util.DailyPopUtils.parseDailyPopComicData(pData));
   }
   function onProfileStatusDataLoaded(pData)
   {
      com.poptropica.models.PopModel(this._model).statusVO = new com.poptropica.models.vo.profile.StatusVO(pData);
   }
   function onProfilePrivacyDataLoaded(pData)
   {
      com.poptropica.models.PopModel(this._model).privacyVO = new com.poptropica.models.vo.profile.PrivacyVO(pData);
   }
   function onProfileAlbumsDataLoaded(pData)
   {
      com.poptropica.models.PopModel(this._model).albumsVO = new com.poptropica.models.vo.badges.AlbumsVO(pData);
   }
   function onComicViewerVoDataLoaded(pData, pComicTitle, pId)
   {
      com.poptropica.models.PopModel(this._model).setComicViewerVO(com.poptropica.util.ComicViewerUtil.parseComicViewerVoData(pData,pComicTitle,pId));
   }
   function setState(str)
   {
      com.poptropica.util.Debug.trace("PopController::setState() str=" + str,com.poptropica.util.Debug.VERBOSE_MESSAGE);
      com.poptropica.models.PopModel(this._model).state = str;
   }
   function sendUpdateNotification(pNotType, pNotObject)
   {
      com.poptropica.util.Debug.trace("PopController::sendNotification() pNotType=" + pNotType,com.poptropica.util.Debug.VERBOSE_MESSAGE);
      com.poptropica.models.PopModel(this._model).sendUpdateNotification(pNotType,pNotObject);
   }
   function setRootVar(varName, obj)
   {
      com.poptropica.util.Debug.trace("PopController::setRootVar()",com.poptropica.util.Debug.VERBOSE_MESSAGE);
      com.poptropica.models.PopModel(this._model).rt_mc[varName] = obj;
   }
   function toplevelPopUp(pPath)
   {
      com.poptropica.util.Debug.trace("PopController::toplevelPopUp() pPath=" + pPath,com.poptropica.util.Debug.VERBOSE_MESSAGE);
   }
   function loadingSequenceComplete(pSequenceCompleted)
   {
      com.poptropica.util.Debug.trace("PopController::loadingSequenceComplete() pSequenceCompleted=" + pSequenceCompleted,com.poptropica.util.Debug.VERBOSE_MESSAGE);
      var _loc3_;
      var _loc5_;
      var _loc2_;
      var _loc4_;
      switch(pSequenceCompleted)
      {
         case "startup":
            var me = this;
            _loc3_ = function()
            {
               com.poptropica.util.Debug.trace("PopController::afterPrefixLoaded() ",com.poptropica.util.Debug.VERBOSE_MESSAGE);
               me.loadingSequenceComplete("getPrefix");
            };
            this._getPrefixCommand = new com.poptropica.controllers.commands.GetPrefixCommand();
            this._getPrefixCommand.addEventListener(com.poptropica.controllers.events.CommandEvent.COMMAND_COMPLETE,com.poptropica.util.EventDelegate.create(this,_loc3_));
            this._getPrefixCommand.exec();
            break;
         case "getPrefix":
            var me = this;
            _loc5_ = function()
            {
               com.poptropica.util.Debug.trace("PopController::afterXMLLoaded() ",com.poptropica.util.Debug.VERBOSE_MESSAGE);
               me.loadingSequenceComplete("getConfigXML");
            };
            this._getXMLCommand = new com.poptropica.controllers.commands.GetConfigXMLCommand();
            this._getXMLCommand.addEventListener(com.poptropica.controllers.events.CommandEvent.COMMAND_COMPLETE,com.poptropica.util.EventDelegate.create(this,_loc5_));
            this._getXMLCommand.exec();
            break;
         case "getConfigXML":
            this.sendUpdateNotification(com.poptropica.models.PopUpdateNotificationTypes.RETRIEVE_GAMEPLAY,com.poptropica.models.PopModel(this._model).gameplay_url);
            trace("loaded 1 ");
            break;
         case "gameplay":
            trace("loaded 2 ");
            this.sendUpdateNotification(com.poptropica.models.PopUpdateNotificationTypes.LOAD_SEQUENCE_COMPLETE);
            _loc2_ = new com.poptropica.controllers.commands.ExtractVariablesFromGameplayCommand();
            _loc2_.exec();
            _loc4_ = new com.poptropica.controllers.commands.RetrofittingWorkaroundsCommand(com.poptropica.models.PopModel(this._model).rt_mc);
            _loc4_.exec();
            this.sendUpdateNotification(com.poptropica.models.PopUpdateNotificationTypes.BUILD,com.poptropica.models.PopModel(this._model).state);
            if(com.poptropica.models.PopModel(this._model).state == com.poptropica.models.PopAppStates.INIT)
            {
               this.setPath("gameplay");
            }
            else if(com.poptropica.models.PopModel(this._model).state == com.poptropica.models.PopAppStates.RETURN_USER_STANDARD)
            {
               this.setPath(com.poptropica.models.PopModel(this._model).startup_path);
            }
            com.poptropica.controllers.AdController.getInstance().loadWrapper(com.poptropica.models.PopModel(this._model));
         default:
            return;
      }
   }
   function successfulRegistration(infoObj, senderHash)
   {
      com.poptropica.util.Debug.trace("PopController::successfulRegistration() ",com.poptropica.util.Debug.VERBOSE_MESSAGE);
      com.poptropica.models.PopModel(this._model).poptropica_user.login = infoObj.login;
      com.poptropica.models.PopModel(this._model).poptropica_user.password_hash = senderHash;
      com.poptropica.models.PopModel(this._model).db_id = infoObj.dbid;
      this.sendUpdateNotification(com.poptropica.models.PopUpdateNotificationTypes.REGISTRATION,null);
   }
   function returnToGameAndSave()
   {
      com.poptropica.util.Debug.trace("PopController::returnToGameAndSave()",com.poptropica.util.Debug.VERBOSE_MESSAGE);
      com.poptropica.models.PopModel(this._model).setPathSection("gameplay");
      this.sendUpdateNotification(com.poptropica.models.PopUpdateNotificationTypes.INIT_SAVE_SEQUENCE,null);
   }
   function returnToGame()
   {
      com.poptropica.util.Debug.trace("PopController::returnToGame()",com.poptropica.util.Debug.VERBOSE_MESSAGE);
      com.poptropica.models.PopModel(this._model).setPathSection("gameplay");
   }
   function submitPromoCode(promoCode)
   {
      com.poptropica.util.Debug.trace("PopController::submitPromoCode() promoCode=" + promoCode,com.poptropica.util.Debug.VERBOSE_MESSAGE);
      var _loc2_ = new com.poptropica.models.proxy.PromoCodeProxy();
      _loc2_.loadData(com.poptropica.util.EventDelegate.create(this,this.onPromoCodeLoaded),promoCode);
   }
   function onPromoCodeLoaded(pData)
   {
      com.poptropica.util.Debug.trace("PopController::onPromoCodeLoaded() pData=" + pData,com.poptropica.util.Debug.VERBOSE_MESSAGE);
      var _loc2_ = com.poptropica.util.HomeUtils.parsePromoCodeSubmitData(pData);
      if(_loc2_.activated)
      {
         this.sendUpdateNotification(com.poptropica.models.PopUpdateNotificationTypes.PROMO_CODE_ACTIVATED,_loc2_);
         if(_loc2_.items != null && _loc2_.items.length > 0)
         {
            com.poptropica.models.PopModel(this._model).awardItems(_loc2_.items,_loc2_.itemCategories);
         }
         if(_loc2_.credits != null && _loc2_.credits != undefined && _loc2_.credits != 0 && Number(_loc2_.credits) != NaN)
         {
            com.poptropica.models.PopModel(this._model).awardCredits(Number(_loc2_.credits));
         }
      }
      else
      {
         this.sendUpdateNotification(com.poptropica.models.PopUpdateNotificationTypes.PROMO_CODE_ACTIVATION_ERROR,_loc2_);
      }
   }
   function showModalTextWindow(pTxt, pShowCloseBtn)
   {
      com.poptropica.util.Debug.trace("PopController::showModalTextWindow() pTxt=" + pTxt,com.poptropica.util.Debug.VERBOSE_MESSAGE);
   }
   function showFrameworkPopup(pPath, pParameters)
   {
      com.poptropica.util.Debug.trace("PopController::showFrameworkPopup()",com.poptropica.util.Debug.VERBOSE_MESSAGE);
      var _loc2_ = {path:pPath,popupParameters:pParameters};
      this.sendUpdateNotification(com.poptropica.models.PopUpdateNotificationTypes.SHOW_FRAMEWORK_POPUP,_loc2_);
   }
   function removeFrameworkPopup()
   {
      com.poptropica.util.Debug.trace("PopController::removeFrameworkPopup()",com.poptropica.util.Debug.VERBOSE_MESSAGE);
      this.sendUpdateNotification(com.poptropica.models.PopUpdateNotificationTypes.REMOVE_FRAMEWORK_POPUP,null);
   }
   function link(pStr)
   {
      com.poptropica.util.Debug.trace("PopController::link()  pStr=" + pStr,com.poptropica.util.Debug.VERBOSE_MESSAGE);
      var _loc11_ = Boolean(pStr.indexOf("pop://") == -1);
      var _loc12_;
      var _loc9_;
      var _loc6_;
      var _loc2_;
      var _loc5_;
      var _loc8_;
      var _loc3_;
      var _loc7_;
      var _loc10_;
      if(_loc11_)
      {
         if(pStr.indexOf("[LOGIN]") > 0)
         {
            _loc12_ = pStr.split("[LOGIN]")[0];
            _loc9_ = com.poptropica.models.PopModel(this._model).gameplayMC.createEmptyMovieClip("send_mc",com.poptropica.models.PopModel(this._model).gameplayMC.getNextHighestDepth());
            _loc9_.login = com.poptropica.models.PopModelConst.avatar.loadLogin();
            _loc9_.logged_in = !com.poptropica.models.PopModelConst.avatar.isRegistred() ? 0 : 1;
            _loc9_.getURL(_loc12_,"_blank","POST");
         }
         else
         {
            if(pStr.indexOf("[RANDOM]") > 0)
            {
               pStr = utils.Utils.stringReplace(pStr,"[RANDOM]",String(random(10000)));
            }
            getURL(pStr,"_blank");
         }
      }
      else
      {
         _loc6_ = pStr.substr(6);
         _loc2_ = _loc6_.split("/");
         switch(_loc2_[0])
         {
            case "gameplay":
               if(_loc2_.length == 1)
               {
                  com.poptropica.models.PopModel(this._model).path = _loc6_;
               }
               else
               {
                  _loc5_ = _loc2_[1];
                  if(_loc2_[2] == "START")
                  {
                     _loc8_ = String(com.poptropica.models.PopModel(this._model).getIslandProperty(_loc5_,"island_main"));
                     _loc3_ = Object(com.poptropica.models.PopModel(this._model).getIslandProperty(_loc5_,"init_coords"));
                  }
                  else
                  {
                     _loc8_ = _loc2_[2];
                     _loc7_ = _loc2_[3];
                     if(_loc7_ == undefined || _loc7_ == "")
                     {
                        _loc7_ = String(com.poptropica.models.PopModel(this._model).getIslandProperty(_loc5_,"init_coords"));
                     }
                     else
                     {
                        _loc10_ = _loc7_.split(",");
                        _loc3_ = new Object();
                        _loc3_.x = _loc10_[0];
                        _loc3_.y = _loc10_[1];
                     }
                  }
                  if(_loc5_ != undefined && _loc8_ != undefined && _loc3_.x != undefined && _loc3_.y != undefined)
                  {
                     com.poptropica.models.PopModel(this._model).camera.scene.char.loadScene(_loc8_,_loc3_.x,_loc3_.y,_loc5_);
                  }
                  else
                  {
                     com.poptropica.util.Debug.trace("PopController::link()  ERROR: Not enough data to link to scene - islandName=" + _loc5_ + "  sceneName=" + _loc8_,com.poptropica.util.Debug.WARNING);
                  }
               }
               return;
            case "stats":
               com.poptropica.models.PopModel(this._model).path = _loc6_;
               return;
            case "popup":
               com.poptropica.models.PopModel(this._model).gameplayMC.popup(_loc2_[1] + ".swf",_loc2_[2]);
               return;
            case "membershipTour":
               _loc9_ = com.poptropica.models.PopModel(this._model).gameplayMC.createEmptyMovieClip("send_mc",com.poptropica.models.PopModel(this._model).gameplayMC.getNextHighestDepth());
               _loc9_.login = com.poptropica.models.PopModelConst.avatar.loadLogin();
               _loc9_.logged_in = !com.poptropica.models.PopModelConst.avatar.isRegistred() ? 0 : 1;
               _loc9_.getURL("http://www.poptropica.com/about/membership-tour.html","_blank","POST");
               return;
            default:
               com.poptropica.models.PopModel(this._model).path = _loc6_;
               return;
         }
      }
   }
   function loadTrackingPixel(pStr)
   {
      if(pStr.indexOf("[RANDOM]") > 0)
      {
         pStr = utils.Utils.stringReplace(pStr,"[RANDOM]",String(random(10000)));
      }
      getURL("javascript: loadTrackingPixel(\'" + pStr + "\')","");
   }
   function track(CampaignName, EventToTrack, ChoiceName, SubChoiseName, trackScene)
   {
      com.poptropica.util.Debug.trace("PopController::track() CampaignName=" + CampaignName + "  EventToTrack=" + EventToTrack + "  ChoiceName=" + ChoiceName + "  SubChoiseName=" + SubChoiseName + "   trackScene=" + trackScene,com.poptropica.util.Debug.VERBOSE_MESSAGE);
      var _loc1_ = new com.poptropica.controllers.commands.TrackCommand();
      _loc1_.exec(CampaignName,EventToTrack,ChoiceName,SubChoiseName,trackScene);
   }
   function setPointerDisplay(str)
   {
      com.poptropica.views.PointerView.getInstance().changePointerDisplay(str);
   }
   function checkForRetrofittingWorkaroundOnSectionChange(pOldSectionName, pNewSectionName)
   {
      var _loc4_;
      var _loc5_;
      if(pOldSectionName != pNewSectionName)
      {
         if(com.poptropica.models.PopModel(this._model).isSectionRetrofitted(pOldSectionName))
         {
            _loc4_ = new com.poptropica.controllers.commands.PullVarsFromFrameworkCommand();
            _loc4_.exec(pOldSectionName,pNewSectionName);
         }
         if(com.poptropica.models.PopModel(this._model).isSectionRetrofitted(pNewSectionName))
         {
            _loc5_ = new com.poptropica.controllers.commands.PassVarsToFrameworkCommand();
            _loc5_.exec(pOldSectionName,pNewSectionName);
         }
      }
   }
   function setPath(str)
   {
      com.poptropica.util.Debug.trace("PopController::setPath() path=" + str,com.poptropica.util.Debug.VERBOSE_MESSAGE);
      var _loc3_ = str.split("/")[0];
      this.checkForRetrofittingWorkaroundOnSectionChange(com.poptropica.models.PopModel(this._model).pathArray[0],_loc3_);
      if(_loc3_ == "stats")
      {
         _root.loadStore = true;
      }
      com.poptropica.models.PopModel(this._model).path = str;
   }
   function setSection(section)
   {
      com.poptropica.util.Debug.trace("PopController::setSection() section=" + section,com.poptropica.util.Debug.VERBOSE_MESSAGE);
      this.checkForRetrofittingWorkaroundOnSectionChange(com.poptropica.models.PopModel(this._model).pathArray[0],section);
      com.poptropica.models.PopModel(this._model).setPathSection(section);
   }
   function setSubSection(subsection)
   {
      com.poptropica.util.Debug.trace("PopController::setSubSection() subsection=" + subsection,com.poptropica.util.Debug.VERBOSE_MESSAGE);
      com.poptropica.models.PopModel(this._model).setPathSubSection(subsection);
   }
   function setSectionStatus(status)
   {
      com.poptropica.util.Debug.trace("PopController::setSectionStatus() status=" + status,com.poptropica.util.Debug.VERBOSE_MESSAGE);
      com.poptropica.models.PopModel(this._model).setSectionStatus(status);
   }
}
