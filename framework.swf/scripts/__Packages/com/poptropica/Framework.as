class com.poptropica.Framework
{
   var _mainView;
   var _popController;
   var _popModel;
   function Framework(pTarget)
   {
      com.poptropica.util.Debug.trace("Framework::() " + pTarget,com.poptropica.util.Debug.VERBOSE_MESSAGE);
      this._popModel = com.poptropica.models.PopModel.getInstance();
      this._popController = new com.poptropica.controllers.PopController(this._popModel);
      this._mainView = new com.poptropica.views.MainView(this._popModel,this._popController,pTarget,0);
      this._popModel.addObserver(this._mainView);
      var _loc2_ = new com.poptropica.controllers.commands.StartUpCommand(pTarget);
      _loc2_.exec();
   }
}
