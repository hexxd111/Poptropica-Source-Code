class com.poptropica.models.proxy.profile.PrivacyProxy extends com.poptropica.models.proxy.supportClasses.ProxyBase
{
   var _callBackFunction;
   var _errorMessage;
   var _model;
   var _sender;
   function PrivacyProxy()
   {
      super();
      this._sender.login = this._model.login;
      this._sender.pass_hash = this._model.password_hash;
      this._sender.dbid = this._model.db_id;
      this._errorMessage = "PrivacyProxy::(), ERROR LOADING";
   }
   function sendData(callBackFunction, privacyId)
   {
      this._callBackFunction = callBackFunction;
      this._sender.privid = privacyId;
      super.doConnect("profile/set_privacy.php",true);
   }
   function loadData(callBackFunction)
   {
      this._callBackFunction = callBackFunction;
      super.doConnect("profile/get_privacy.php");
   }
}
