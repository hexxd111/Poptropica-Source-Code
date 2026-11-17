class com.poptropica.models.proxy.badges.AlbumsProxy extends com.poptropica.models.proxy.supportClasses.ProxyBase
{
   var _callBackFunction;
   var _errorMessage;
   var _model;
   var _sender;
   function AlbumsProxy()
   {
      super();
      this._sender.login = this._model.login;
      this._sender.pass_hash = this._model.password_hash;
      this._sender.dbid = this._model.db_id;
      this._errorMessage = "AlbumsProxy::(), ERROR LOADING COMIC STRIPS STREAM";
   }
   function loadData(callBackFunction)
   {
      this._callBackFunction = callBackFunction;
      super.doConnect("badges/get_albums.php");
   }
}
