class com.poptropica.views.MainView extends com.poptropica.mvc.AbstractView
{
   var _adAutoCardView;
   var _adBillboardView;
   var _adLogOutView;
   var _adMainStreetView;
   var _adWrapperView;
   var _animTopView;
   var _bg_mc;
   var _controller;
   var _currentSectionName;
   var _gameplayLoaderView;
   var _loadBar;
   var _model;
   var _nav_change_password;
   var _nav_logout;
   var _nav_mc;
   var _pointerView;
   var _popupLoader;
   var _popup_mc;
   var _prev_selected_nav_btn;
   var _sectionContener;
   var _sectionListener;
   var _sectionLoader;
   var _target_mc;
   static var sectionNames = ["gameplay","dailypop","stats","items","friendshub","home","gameplay"];
   static var sectionNameEvents = ["BlimpClicked","DailyPopClicked","StatsStoreStuffClicked","InventoryClicked","FriendsHubClicked","HomeClicked",""];
   static var sectionDimensions = ["gameplay_lbl","fullSize_lbl","reducedSize_lbl","gameplay_lbl","fullSize_lbl","fullSize_lbl","gameplay_lbl"];
   var _navBtns = new Array();
   var _background_depth = 20;
   var _gameplay_depth = 10;
   var _section_depth = 30;
   var _nav_depth = 50;
   var _nav_logout_depth = 25;
   var _loading_depth = 100;
   var _ad_depth = 150;
   var _popup_depth = 160;
   var _pointer_depth = 200;
   var _anim_top_depth = 180;
   function MainView(m, c, pTarget, depth, x, y)
   {
      super(m,c);
      com.poptropica.util.Debug.trace("MainView::() pTarget=" + pTarget + "  depth=" + depth,com.poptropica.util.Debug.VERBOSE_MESSAGE);
      this._target_mc = pTarget;
      this._target_mc.stop();
      Stage.scaleMode = "noScale";
      Stage.align = "TL";
      fscommand("allowscale","false");
      if(this._target_mc.loadProgress)
      {
         this._target_mc.loadProgress.swapDepths(this._loading_depth);
      }
      this._gameplayLoaderView = new com.poptropica.views.GameplayLoaderView(this._model,this._controller,this._target_mc,this._gameplay_depth);
      this._model.addObserver(this._gameplayLoaderView);
      this._adWrapperView = new com.poptropica.views.AdWrapperView(this._model,this._controller,this._target_mc,this._ad_depth);
      this._model.addObserver(this._adWrapperView);
      this._adBillboardView = new com.poptropica.views.AdBillboardView(this._model,this._controller,this._target_mc);
      this._adBillboardView.dispatcher.addEventListener("Loaded",this.adBillboardViewLoaded);
      this._adBillboardView.dispatcher.addEventListener("LoadError",this.adBillboardViewLoadError);
      this._model.addObserver(this._adBillboardView);
      this._adMainStreetView = new com.poptropica.views.AdMainStreetView(this._model,this._controller,this._target_mc);
      this._adMainStreetView.dispatcher.addEventListener("Loaded",this.adMainStreetViewLoaded);
      this._adMainStreetView.dispatcher.addEventListener("LoadError",this.adMainStreetViewLoadError);
      this._model.addObserver(this._adMainStreetView);
      this._adAutoCardView = new com.poptropica.views.AdAutoCardView(this._model,this._controller,this._target_mc);
      this._model.addObserver(this._adAutoCardView);
      this._adLogOutView = new com.poptropica.views.AdLogOutView(this._model,this._controller,this._target_mc);
      this._model.addObserver(this._adLogOutView);
      trace("AdLogOutView :: _adLogOutView : " + this._adLogOutView);
      this._pointerView = new com.poptropica.views.PointerView(this._model,this._controller,this._target_mc,this._pointer_depth);
      this._model.addObserver(this._pointerView);
      this._animTopView = new com.poptropica.views.AnimTopView(this._model,this._controller,this._target_mc,this._anim_top_depth);
      this._model.addObserver(this._animTopView);
   }
   function update(pObs, pInfoObj)
   {
      com.poptropica.util.Debug.trace("MainView::update()  pInfoObj._type=" + pInfoObj._type,com.poptropica.util.Debug.VERBOSE_MESSAGE);
      var _loc4_;
      var _loc3_;
      switch(pInfoObj._type)
      {
         case com.poptropica.models.PopUpdateNotificationTypes.REGISTRATION:
            this.updateLogoutBtnDisplay(this._currentSectionName);
            break;
         case com.poptropica.models.PopUpdateNotificationTypes.TOGGLE_NAV_ENABLED:
            this.toggleNavEnabled(Boolean(pInfoObj._data));
            break;
         case com.poptropica.models.PopUpdateNotificationTypes.LOAD_SEQUENCE_COMPLETE:
            if(this._target_mc.loadProgress)
            {
               removeMovieClip(this._target_mc.loadProgress);
            }
            break;
         case com.poptropica.models.PopUpdateNotificationTypes.BUILD:
            this.setUpViewBasedOnState(String(pInfoObj._data));
            com.poptropica.models.PopModel(this._model).isBuilt = true;
            break;
         case com.poptropica.models.PopUpdateNotificationTypes.SECTION_CHANGE:
            this.updateMainViewAfterSectionChange(String(pInfoObj._data));
            break;
         case com.poptropica.models.PopUpdateNotificationTypes.SET_PATH:
            _loc4_ = String(pInfoObj._data).split("/")[0];
            this.updateMainViewAfterSectionChange(_loc4_);
            break;
         case com.poptropica.models.PopUpdateNotificationTypes.SHOW_FRAMEWORK_POPUP:
            this.updateFrameworkPopup(Object(pInfoObj._data));
            break;
         case com.poptropica.models.PopUpdateNotificationTypes.REMOVE_FRAMEWORK_POPUP:
            this.updateFrameworkPopup(null);
            break;
         case com.poptropica.models.PopUpdateNotificationTypes.AWARD_ITEMS:
            _loc3_ = {itemIDs:Array(pInfoObj._data)};
            com.poptropica.controllers.PopController.getInstance().showFrameworkPopup("framework/popups/getcard.swf",_loc3_);
            break;
         case com.poptropica.models.PopUpdateNotificationTypes.SET_SECTION_STATUS:
            if(String(pInfoObj._data) == com.poptropica.sections.SectionStatus.SECTION_LOADING)
            {
               this.showLoadBar();
            }
            else if(String(pInfoObj._data) != com.poptropica.sections.SectionStatus.SECTION_LOADING_COMPLETE)
            {
               if(String(pInfoObj._data) == com.poptropica.sections.SectionStatus.SECTION_INITED)
               {
                  if(this._currentSectionName == "stats" || this._currentSectionName == "friends")
                  {
                     this._sectionContener.tabChildren = true;
                  }
                  else
                  {
                     this._sectionContener.tabChildren = false;
                  }
                  if(this._currentSectionName == "stats")
                  {
                     if(com.poptropica.models.PopModel(this._model).gameplayMC.isInventoryActive())
                     {
                        com.poptropica.models.PopModel(this._model).gameplayMC.removeInventoryPopup();
                     }
                  }
               }
               else if(String(pInfoObj._data) == com.poptropica.sections.SectionStatus.SECTION_READY)
               {
                  this.hideLoadBar();
               }
            }
         default:
            return;
      }
   }
   function getRefFromSection(pSectionName)
   {
      com.poptropica.util.Debug.trace("MainView::getRefFromSection()",com.poptropica.util.Debug.VERBOSE_MESSAGE);
      var _loc2_ = -1;
      var _loc1_ = 0;
      while(_loc1_ < sectionNames.length)
      {
         if(pSectionName == sectionNames[_loc1_])
         {
            _loc2_ = _loc1_;
            break;
         }
         _loc1_ = _loc1_ + 1;
      }
      return _loc2_;
   }
   function clearPopup()
   {
      com.poptropica.util.Debug.trace("MainView::clearPopup()",com.poptropica.util.Debug.VERBOSE_MESSAGE);
      if(this._popupLoader && this._popup_mc)
      {
         this._popupLoader.unloadClip(this._popup_mc);
         this._popupLoader = undefined;
         this._popup_mc = undefined;
      }
   }
   function updateFrameworkPopup(pPopupObj)
   {
      com.poptropica.util.Debug.trace("MainView::updateFrameworkPopup()",com.poptropica.util.Debug.VERBOSE_MESSAGE);
      if(pPopupObj == null)
      {
         this.clearPopup();
         return undefined;
      }
      var _loc5_ = pPopupObj.path;
      var popupParameters = pPopupObj.popupParameters;
      if(_loc5_ == "")
      {
         com.poptropica.util.Debug.trace("MainView::updateFrameworkPopup()  - No path for popup",com.poptropica.util.Debug.FATAL_ERROR);
         return undefined;
      }
      var _loc8_ = function()
      {
         com.poptropica.util.Debug.trace("MainView::updateFrameworkPopup() - Problem loading popup",com.poptropica.util.Debug.FATAL_ERROR);
      };
      var _loc10_ = function(target_mc)
      {
         com.poptropica.util.Debug.trace("MainView::updateFrameworkPopup() onPopupLoadComplete",com.poptropica.util.Debug.VERBOSE_MESSAGE);
      };
      var _loc9_ = function(target_mc)
      {
         com.poptropica.util.Debug.trace("MainView::updateFrameworkPopup() onPopupLoadStart",com.poptropica.util.Debug.VERBOSE_MESSAGE);
      };
      var _loc7_ = function(target_mc)
      {
         com.poptropica.util.Debug.trace("MainView::updateFrameworkPopup() onPopupLoadInit",com.poptropica.util.Debug.VERBOSE_MESSAGE);
         target_mc.popupParameters = popupParameters;
      };
      this._popup_mc = this._target_mc.createEmptyMovieClip("popup_mc",this._popup_depth);
      var _loc6_ = "popupLoadingGraphic";
      if(com.poptropica.models.PopModel.getInstance().sectionDimensionString == "gameplay_lbl" || com.poptropica.models.PopModel.getInstance().sectionDimensionString == "reducedSize_lbl")
      {
         _loc6_ = "popupLoadingGraphicSmall";
      }
      var _loc4_ = this._popup_mc.attachMovie(_loc6_,"popupLoadingGraphic",this._popup_mc.getNextHighestDepth());
      if(pPopupObj.showShadow == false)
      {
         _loc4_.mcShadow._visible = false;
      }
      trace("[MainView] )))))) pPopupObj.showShadow: " + pPopupObj.showShadow + ", loadingGraphic.mcShadow:" + _loc4_.mcShadow);
      _loc4_.clickCatcher.onRelease = function()
      {
      };
      var _loc11_ = this._popup_mc.createEmptyMovieClip("container",this._popup_mc.getNextHighestDepth());
      this._popup_mc._x = 0;
      this._popup_mc._y = 0;
      var _loc2_ = new Object();
      _loc2_.onLoadError = com.poptropica.util.EventDelegate.create(this,_loc8_);
      _loc2_.onLoadComplete = com.poptropica.util.EventDelegate.create(this,_loc10_);
      _loc2_.onLoadInit = com.poptropica.util.EventDelegate.create(this,_loc7_);
      _loc2_.onLoadStart = com.poptropica.util.EventDelegate.create(this,_loc9_);
      this._popupLoader = new MovieClipLoader();
      this._popupLoader.addListener(_loc2_);
      this._popupLoader.loadClip(_loc5_,this._popup_mc.container);
   }
   function updateMainViewAfterSectionChange(pSectionName)
   {
      com.poptropica.util.Debug.trace("MainView::updateMainViewAfterSectionChange()",com.poptropica.util.Debug.VERBOSE_MESSAGE);
      this.updateFrameDimensions(pSectionName);
      this.updateLogoutBtnDisplay(pSectionName);
      if(this._currentSectionName != pSectionName)
      {
         this.removeSection();
         this.setSection(pSectionName);
         this.updateNavBar(pSectionName);
      }
   }
   function updateFrameDimensions(pSectionName)
   {
      com.poptropica.util.Debug.trace("MainView::updateFrameDimensions()",com.poptropica.util.Debug.VERBOSE_MESSAGE);
      var _loc3_ = this.getRefFromSection(this._currentSectionName);
      var _loc2_ = this.getRefFromSection(pSectionName);
      if(sectionDimensions[_loc3_] != sectionDimensions[_loc2_])
      {
         switch(sectionDimensions[_loc2_])
         {
            case "reducedSize_lbl":
               this._bg_mc.gotoAndStop("reducedSize_lbl");
               this._nav_mc._x = 566;
               this._sectionContener._x = 165;
               this._adWrapperView.content_mc._visible = true;
               break;
            case "fullSize_lbl":
               this._bg_mc.gotoAndStop("fullSize_lbl");
               this._nav_mc._x = 627;
               this._sectionContener._x = 105;
               this._adWrapperView.content_mc._visible = false;
               this._nav_logout._x = 796;
               break;
            case "gameplay_lbl":
               this._bg_mc.gotoAndStop("gameplay_lbl");
               this._nav_mc._x = 566;
               this._sectionContener._x = 165;
               this._adWrapperView.content_mc._visible = true;
         }
         com.poptropica.models.PopModel.getInstance().sectionDimensionString = sectionDimensions[_loc2_];
      }
   }
   function updateLogoutBtnDisplay(pSectionName)
   {
      com.poptropica.util.Debug.trace("MainView::updateLogoutBtnDisplay()",com.poptropica.util.Debug.VERBOSE_MESSAGE);
      var _loc5_ = this.getRefFromSection(pSectionName);
      var _loc4_ = com.poptropica.models.PopModel(this._model).is_logged_in;
      var _loc3_ = sectionDimensions[_loc5_];
      var _loc2_ = false;
      if(_loc3_ == "reducedSize_lbl" || _loc3_ == "gameplay_lbl")
      {
         _loc2_ = false;
      }
      else
      {
         _loc2_ = _loc4_;
      }
      this._nav_logout._visible = _loc2_;
      this._nav_change_password._visible = _loc2_;
   }
   function setUpViewBasedOnState(pState)
   {
      com.poptropica.util.Debug.trace("MainView::setUpViewBasedOnState() pState=" + pState,com.poptropica.util.Debug.VERBOSE_MESSAGE);
      switch(pState)
      {
         case com.poptropica.models.PopAppStates.INIT:
         case com.poptropica.models.PopAppStates.RETURN_USER_STANDARD:
            this.build(pState);
            break;
         case com.poptropica.models.PopAppStates.RETURN_USER_AD_1:
         default:
            return;
      }
   }
   function build(pState)
   {
      com.poptropica.util.Debug.trace("MainView::build()",com.poptropica.util.Debug.VERBOSE_MESSAGE);
      var c = com.poptropica.controllers.PopController(this._controller);
      this._sectionListener = new Object();
      this._sectionListener.onLoadError = function()
      {
         c.setSectionStatus(com.poptropica.sections.SectionStatus.SECTION_ERROR);
      };
      this._sectionListener.onLoadComplete = function()
      {
         c.setSectionStatus(com.poptropica.sections.SectionStatus.SECTION_LOADING_COMPLETE);
      };
      this._sectionListener.onLoadInit = function()
      {
         c.setSectionStatus(com.poptropica.sections.SectionStatus.SECTION_INITED);
      };
      this._sectionListener.onLoadStart = function()
      {
         c.setSectionStatus(com.poptropica.sections.SectionStatus.SECTION_LOADING);
      };
      this._sectionLoader = new MovieClipLoader();
      this._sectionLoader.addListener(this._sectionListener);
      this._sectionContener = this._target_mc.createEmptyMovieClip("section",this._section_depth);
      this._sectionContener._x = 110;
      this._sectionContener._y = 85;
      this.makeBG();
      this.makeNavBar();
   }
   function makeBG()
   {
      com.poptropica.util.Debug.trace("MainView::makeBG()",com.poptropica.util.Debug.VERBOSE_MESSAGE);
      this._bg_mc = this._target_mc.attachMovie("LibBg","bg_mc",this._background_depth);
      this._bg_mc.stop();
      this._bg_mc.tabChildren = false;
      this._bg_mc.bg_action1_mc.onRollOver = com.poptropica.util.EventDelegate.create(this,this.BGRollOver);
      this._bg_mc.bg_action2_mc.onRollOver = com.poptropica.util.EventDelegate.create(this,this.BGRollOver);
      this._bg_mc.bg_action3_mc.onRollOver = com.poptropica.util.EventDelegate.create(this,this.BGRollOver);
      this._bg_mc.bg_action4_mc.onRollOver = com.poptropica.util.EventDelegate.create(this,this.BGRollOver);
      this._bg_mc.logo_mc.onRelease = com.poptropica.util.EventDelegate.create(this,this.onLogoClick);
      this._bg_mc.logo_mc.onRollOver = com.poptropica.util.EventDelegate.create(this,this.onLogoOver);
      this._bg_mc.logo_mc.onRollOut = com.poptropica.util.EventDelegate.create(this,this.onLogoOut);
   }
   function BGRollOver()
   {
      com.poptropica.controllers.PopController(this._controller).setPointerDisplay("arrow");
   }
   function makeNavBar()
   {
      com.poptropica.util.Debug.trace("MainView::makeNavBar(), Debug.VERBOSE_MESSAGE");
      this._nav_mc = this._target_mc.attachMovie("LibNavBar","_nav_mc",this._nav_depth,{_x:635,_y:50});
      this._nav_mc.tabChildren = false;
      this._nav_mc.gameplayBtn.onRelease = com.poptropica.util.EventDelegate.create(this,this.itemClick,0);
      this._nav_mc.dailypopBtn.onRelease = com.poptropica.util.EventDelegate.create(this,this.itemClick,1);
      this._nav_mc.statsBtn.onRelease = com.poptropica.util.EventDelegate.create(this,this.itemClick,2);
      this._nav_mc.friendshubBtn.onRelease = com.poptropica.util.EventDelegate.create(this,this.itemClick,4);
      this._nav_mc.homeBtn.onRelease = com.poptropica.util.EventDelegate.create(this,this.itemClick,5);
      this._nav_mc.gameplayBtn.onRollOver = this._nav_mc.gameplayBtn.onDragOver = com.poptropica.util.EventDelegate.create(this,this.navItemRollOver,this._nav_mc.gameplayBtn,0);
      this._nav_mc.dailypopBtn.onRollOver = this._nav_mc.dailypopBtn.onDragOver = com.poptropica.util.EventDelegate.create(this,this.navItemRollOver,this._nav_mc.dailypopBtn,1);
      this._nav_mc.statsBtn.onRollOver = this._nav_mc.statsBtn.onDragOver = com.poptropica.util.EventDelegate.create(this,this.navItemRollOver,this._nav_mc.statsBtn,2);
      this._nav_mc.friendshubBtn.onRollOver = this._nav_mc.friendshubBtn.onDragOver = com.poptropica.util.EventDelegate.create(this,this.navItemRollOver,this._nav_mc.friendshubBtn,4);
      this._nav_mc.homeBtn.onRollOver = this._nav_mc.homeBtn.onDragOver = com.poptropica.util.EventDelegate.create(this,this.navItemRollOver,this._nav_mc.homeBtn,5);
      this._nav_mc.gameplayBtn.onRollOut = this._nav_mc.gameplayBtn.onDragOut = this._nav_mc.gameplayBtn.onReleaseOutside = com.poptropica.util.EventDelegate.create(this,this.navItemRollOut,this._nav_mc.gameplayBtn);
      this._nav_mc.dailypopBtn.onRollOut = this._nav_mc.dailypopBtn.onDragOut = this._nav_mc.dailypopBtn.onReleaseOutside = com.poptropica.util.EventDelegate.create(this,this.navItemRollOut,this._nav_mc.dailypopBtn);
      this._nav_mc.statsBtn.onRollOut = this._nav_mc.statsBtn.onDragOut = this._nav_mc.statsBtn.onReleaseOutside = com.poptropica.util.EventDelegate.create(this,this.navItemRollOut,this._nav_mc.statsBtn);
      this._nav_mc.friendshubBtn.onRollOut = this._nav_mc.friendshubBtn.onDragOut = this._nav_mc.friendshubBtn.onReleaseOutside = com.poptropica.util.EventDelegate.create(this,this.navItemRollOut,this._nav_mc.friendshubBtn);
      this._nav_mc.homeBtn.onRollOut = this._nav_mc.homeBtn.onDragOut = this._nav_mc.homeBtn.onReleaseOutside = com.poptropica.util.EventDelegate.create(this,this.navItemRollOut,this._nav_mc.homeBtn);
      this._nav_mc.gameplayBtn.stop();
      this._nav_mc.dailypopBtn.stop();
      this._nav_mc.statsBtn.stop();
      this._nav_mc.friendshubBtn.stop();
      this._nav_mc.friendshubBtn.mc.init();
      this._nav_mc.homeBtn.stop();
      this._navBtns.push(this._nav_mc.gameplayBtn,this._nav_mc.dailypopBtn,this._nav_mc.statsBtn,this._nav_mc.friendshubBtn,this._nav_mc.homeBtn);
      this._nav_logout = this._target_mc.attachMovie("LibNavLogout","_nav_logout",this._nav_logout_depth,{_x:796,_y:98});
      this._nav_logout.tabChildren = false;
      this._nav_logout._visible = com.poptropica.models.PopModel(this._model).is_logged_in;
      this._nav_logout.logout_mc.onRollOut = this._nav_logout.logout_mc.onDragOut = this._nav_mc.logout_mc.onReleaseOutside = com.poptropica.util.EventDelegate.create(this,this.navLogoutRollOut,this._nav_logout.logout_mc);
      this._nav_logout.logout_mc.onRollOver = this._nav_logout.logout_mc.onDragOver = com.poptropica.util.EventDelegate.create(this,this.navLogoutRollOver,this._nav_logout.logout_mc);
      this._nav_logout.logout_mc.onRelease = com.poptropica.util.EventDelegate.create(this,this.navLogoutClick);
      this._nav_change_password = this._target_mc.attachMovie("LibNavChangePassword","_nav_change_password",this._nav_logout_depth + 1,{_x:this._nav_logout._x - 130,_y:98});
      this._nav_change_password.tabChildren = false;
      this._nav_change_password._visible = com.poptropica.models.PopModel(this._model).is_logged_in;
      this._nav_change_password.mc.onRollOut = this._nav_change_password.mc.onDragOut = this._nav_mc.changePassword_mc.onReleaseOutside = com.poptropica.util.EventDelegate.create(this,this.navChangePasswordRollOut,this._nav_change_password.mc);
      this._nav_change_password.mc.onRollOver = this._nav_change_password.mc.onDragOver = com.poptropica.util.EventDelegate.create(this,this.navChangePasswordRollOver,this._nav_change_password.mc);
      this._nav_change_password.mc.onRelease = com.poptropica.util.EventDelegate.create(this,this.navChangePasswordClick);
      com.poptropica.models.PopModel(this._model).navbarMC = this._nav_mc;
   }
   function setSection(pSectionName)
   {
      com.poptropica.util.Debug.trace("MainView::setSection() pSectionName=" + pSectionName,com.poptropica.util.Debug.VERBOSE_MESSAGE);
      if(pSectionName != "gameplay" && pSectionName != "items")
      {
         this.loadSection(pSectionName);
      }
      if(pSectionName == "gameplay")
      {
         com.poptropica.models.PopModelConst.gameplayMC.sendChangeInfoToServer();
      }
      this._currentSectionName = pSectionName;
   }
   function loadSection(pSectionName)
   {
      com.poptropica.util.Debug.trace("MainView::loadSection() url=" + com.poptropica.util.SectionFactory.getSectionURL(pSectionName),com.poptropica.util.Debug.VERBOSE_MESSAGE);
      com.poptropica.util.Debug.trace("MainView::loadSection() _sectionContener=" + this._sectionContener,com.poptropica.util.Debug.VERBOSE_MESSAGE);
      this._sectionLoader.loadClip(com.poptropica.util.SectionFactory.getSectionURL(pSectionName),this._sectionContener);
      com.poptropica.util.SectionFactory.getSectionURL(pSectionName);
   }
   function removeSection()
   {
      com.poptropica.util.Debug.trace("MainView::removeSection()",com.poptropica.util.Debug.VERBOSE_MESSAGE);
      if(this._loadBar != undefined)
      {
         this.hideLoadBar();
      }
      if(this._sectionContener.pop != undefined)
      {
         this._sectionContener.pop.destroy();
      }
      this._sectionLoader.unloadClip(this._sectionContener);
   }
   function showLoadBar()
   {
      com.poptropica.util.Debug.trace("MainView::showLoadBar()",com.poptropica.util.Debug.VERBOSE_MESSAGE);
      if(this._loadBar != undefined)
      {
         this.hideLoadBar();
      }
      this._loadBar = this._target_mc.attachMovie("LoadProgressSection","loadbar",100);
      this._loadBar._x = this._sectionContener._x;
      this._loadBar._y = this._sectionContener._y;
      var _loc2_ = this.getRefFromSection(this._currentSectionName);
      if(sectionDimensions[_loc2_] == "fullSize_lbl")
      {
         this._loadBar.gotoAndStop(2);
      }
      else
      {
         this._loadBar.gotoAndStop(1);
      }
   }
   function hideLoadBar()
   {
      this._loadBar.removeMovieClip();
      this._loadBar = undefined;
   }
   function toggleNavEnabled(pEnabled)
   {
      com.poptropica.util.Debug.trace("MainView::toggleNavEnabled()  pEnabled=" + pEnabled,com.poptropica.util.Debug.VERBOSE_MESSAGE);
      var _loc2_;
      if(pEnabled)
      {
         _loc2_ = 0;
         while(_loc2_ < this._navBtns.length)
         {
            this._navBtns[_loc2_].enabled = true;
            _loc2_ = _loc2_ + 1;
         }
         if(this._prev_selected_nav_btn)
         {
            this._prev_selected_nav_btn.enabled = false;
            this._prev_selected_nav_btn = null;
         }
      }
      else
      {
         _loc2_ = 0;
         while(_loc2_ < this._navBtns.length)
         {
            if(this._navBtns[_loc2_].enabled == false)
            {
               this._prev_selected_nav_btn = this._navBtns[_loc2_];
            }
            this._navBtns[_loc2_].enabled = false;
            _loc2_ = _loc2_ + 1;
         }
      }
   }
   function updateNavBar(pSectionName)
   {
      com.poptropica.util.Debug.trace("MainView::updateNavBar()  pSectionName=" + pSectionName,com.poptropica.util.Debug.VERBOSE_MESSAGE);
      var _loc2_ = 0;
      while(_loc2_ < this._navBtns.length)
      {
         this._navBtns[_loc2_].enabled = true;
         this._navBtns[_loc2_].gotoAndStop(1);
         _loc2_ = _loc2_ + 1;
      }
      var _loc3_ = this._nav_mc[pSectionName + "Btn"];
      _loc3_.enabled = false;
      _loc3_.gotoAndStop(3);
   }
   function itemClick(pIndex)
   {
      this._nav_mc.gotoAndStop(1);
      com.poptropica.controllers.PopController(this._controller).setPointerDisplay("arrow");
      if(sectionNames[pIndex] != "")
      {
         com.poptropica.controllers.PopController(this._controller).setPath(sectionNames[pIndex]);
         com.poptropica.controllers.PopController(this._controller).track("","NavEvent",sectionNameEvents[pIndex]);
      }
   }
   function navItemRollOver(pItem, pIndex)
   {
      pItem.gotoAndStop(2);
      this._nav_mc.gotoAndStop(pIndex + 2);
      com.poptropica.controllers.PopController(this._controller).setPointerDisplay("click");
   }
   function navItemRollOut(pItem)
   {
      pItem.gotoAndStop(1);
      this._nav_mc.gotoAndStop(1);
      com.poptropica.controllers.PopController(this._controller).setPointerDisplay("arrow");
   }
   function onLogoClick()
   {
      com.poptropica.controllers.PopController(this._controller).setPath("gameplay");
   }
   function onLogoOver()
   {
      com.poptropica.controllers.PopController(this._controller).setPointerDisplay("click");
   }
   function onLogoOut()
   {
      com.poptropica.controllers.PopController(this._controller).setPointerDisplay("arrow");
   }
   function navLogoutClick()
   {
      com.poptropica.controllers.PopController(this._controller).setPointerDisplay("arrow");
      com.poptropica.controllers.PopController(this._controller).returnToGameAndSave();
   }
   function navLogoutRollOver(pItem)
   {
      pItem.gotoAndStop(2);
      com.poptropica.controllers.PopController(this._controller).setPointerDisplay("click");
   }
   function navLogoutRollOut(pItem)
   {
      pItem.gotoAndStop(1);
      com.poptropica.controllers.PopController(this._controller).setPointerDisplay("arrow");
   }
   function navChangePasswordClick()
   {
      com.poptropica.controllers.PopController(this._controller).setPointerDisplay("arrow");
      com.poptropica.controllers.PopController.getInstance().showFrameworkPopup("popups/change_password.swf",null);
   }
   function adMainStreetViewLoaded(event)
   {
      com.poptropica.controllers.AdController.getInstance().campaignAssetsReady(com.poptropica.models.AdCampaignType.MAIN_STREET);
   }
   function navChangePasswordRollOver(pItem)
   {
      pItem.gotoAndStop(2);
      com.poptropica.controllers.PopController(this._controller).setPointerDisplay("click");
   }
   function adBillboardViewLoaded(event)
   {
      com.poptropica.controllers.AdController.getInstance().campaignAssetsReady(com.poptropica.models.AdCampaignType.BILLBOARD);
   }
   function adMainStreetViewLoadError(event)
   {
      com.poptropica.controllers.AdController.getInstance().campaignAssetsLoadError(com.poptropica.models.AdCampaignType.MAIN_STREET);
   }
   function navChangePasswordRollOut(pItem)
   {
      pItem.gotoAndStop(1);
      com.poptropica.controllers.PopController(this._controller).setPointerDisplay("arrow");
   }
   function adBillboardViewLoadError(event)
   {
      com.poptropica.controllers.AdController.getInstance().campaignAssetsLoadError(com.poptropica.models.AdCampaignType.BILLBOARD);
   }
}
