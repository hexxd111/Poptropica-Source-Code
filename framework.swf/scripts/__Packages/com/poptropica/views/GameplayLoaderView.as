class com.poptropica.views.GameplayLoaderView extends com.poptropica.mvc.AbstractView
{
   var _gameplayContainerMc;
   var _gameplayListener;
   var _gameplayLoader;
   var _loadGameplayId;
   var _model;
   var _loadGameplayInterval = 40;
   function GameplayLoaderView(m, c, pTarget, pDepth)
   {
      super(m,c);
      com.poptropica.util.Debug.trace("GameplayLoaderView::() pTarget=" + pTarget + " pDepth=" + pDepth,com.poptropica.util.Debug.VERBOSE_MESSAGE);
      this._gameplayContainerMc = pTarget.createEmptyMovieClip("gameplay_container_mc",pDepth);
      this._gameplayContainerMc._lockroot = true;
      com.poptropica.models.PopModel(this._model).gameplayMC = this._gameplayContainerMc;
      this._gameplayListener = new Object();
      this._gameplayListener.onLoadError = com.poptropica.util.EventDelegate.create(this,this.onGPLoadError);
      this._gameplayListener.onLoadComplete = com.poptropica.util.EventDelegate.create(this,this.onGPLoadComplete);
      this._gameplayListener.onLoadInit = com.poptropica.util.EventDelegate.create(this,this.onGPLoadInit);
      this._gameplayListener.onLoadStart = com.poptropica.util.EventDelegate.create(this,this.onGPLoadStart);
      this._gameplayLoader = new MovieClipLoader();
      this._gameplayLoader.addListener(this._gameplayListener);
   }
   function update(o, pInfoObj)
   {
      com.poptropica.util.Debug.trace("GameplayLoaderView::update()  pInfoObj._type=" + pInfoObj._type,com.poptropica.util.Debug.VERBOSE_MESSAGE);
      switch(pInfoObj._type)
      {
         case com.poptropica.models.PopUpdateNotificationTypes.RETRIEVE_GAMEPLAY:
            this.positionGameplayScreen(com.poptropica.models.PopModel(this._model).gameplayX,com.poptropica.models.PopModel(this._model).gameplayY);
            this.retrieveGameplay(String(pInfoObj._data));
            break;
         case com.poptropica.models.PopUpdateNotificationTypes.LOAD_SEQUENCE_COMPLETE:
         case com.poptropica.models.PopUpdateNotificationTypes.BUILD:
            this.setUpViewBasedOnState(String(pInfoObj._data));
         default:
            return;
      }
   }
   function setUpViewBasedOnState(pState)
   {
      com.poptropica.util.Debug.trace("GameplayLoaderView::setUpViewBasedOnState()  pState=" + pState,com.poptropica.util.Debug.VERBOSE_MESSAGE);
      this.positionGameplayScreen(com.poptropica.models.PopModel(this._model).gameplayX,com.poptropica.models.PopModel(this._model).gameplayY);
   }
   function positionGameplayScreen(pX, pY)
   {
      com.poptropica.util.Debug.trace("GameplayLoaderView::positionGameplayScreen() ",com.poptropica.util.Debug.VERBOSE_MESSAGE);
      this._gameplayContainerMc._x = pX;
      this._gameplayContainerMc._y = pY;
   }
   function prepareGameplayLoaderView()
   {
      com.poptropica.util.Debug.trace("GameplayLoaderView::prepareGameplayLoaderView() ",com.poptropica.util.Debug.VERBOSE_MESSAGE);
   }
   function retrieveGameplay(pPath)
   {
      com.poptropica.util.Debug.trace("GameplayLoaderView::retrieveGameplay()  pPath=" + pPath,com.poptropica.util.Debug.VERBOSE_MESSAGE);
      this._gameplayLoader.loadClip(pPath,this._gameplayContainerMc);
      this._loadGameplayId = setInterval(this,"checkSceneLoaded",this._loadGameplayInterval);
   }
   function checkSceneLoaded()
   {
      if(this._gameplayContainerMc.sceneIsVisible)
      {
         com.poptropica.controllers.PopController(this.getController()).sendUpdateNotification(com.poptropica.models.PopUpdateNotificationTypes.GAMEPLAY_LOADED);
         com.poptropica.controllers.PopController(this.getController()).loadingSequenceComplete("gameplay");
         clearInterval(this._loadGameplayId);
      }
   }
   function onGPLoadError()
   {
      com.poptropica.util.Debug.trace("GameplayLoaderView::onGPLoadError() ",com.poptropica.util.Debug.VERBOSE_MESSAGE);
   }
   function onGPLoadInit(targ_mc)
   {
      com.poptropica.util.Debug.trace("GameplayLoaderView::onGPLoadInit() ",com.poptropica.util.Debug.VERBOSE_MESSAGE);
   }
   function onGPLoadStart(targ_mc)
   {
      com.poptropica.util.Debug.trace("GameplayLoaderView::onGPLoadStart() ",com.poptropica.util.Debug.VERBOSE_MESSAGE);
   }
   function onGPLoadComplete()
   {
      com.poptropica.util.Debug.trace("GameplayLoaderView::onGPLoadComplete() ",com.poptropica.util.Debug.VERBOSE_MESSAGE);
   }
   function clear()
   {
      com.poptropica.util.Debug.trace("GameplayLoaderView::clear()",com.poptropica.util.Debug.VERBOSE_MESSAGE);
      this._model.removeObserver(this);
   }
}
