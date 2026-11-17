class com.poptropica.views.AnimTopView extends com.poptropica.mvc.AbstractView
{
   var _container;
   var _model;
   static var instance;
   var _clickWait = 0;
   function AnimTopView(m, c, pTarget, pDepth)
   {
      super(m,c);
      com.poptropica.util.Debug.trace("AnimTopView::() pTarget=" + pTarget + " pDepth=" + pDepth,com.poptropica.util.Debug.VERBOSE_MESSAGE);
      instance = this;
      this.make();
      this._container = pTarget.createEmptyMovieClip("animtop_ctn_mc",pDepth);
      trace("[AnimTopView] pTarget:" + pTarget + " depth:" + pDepth + "  container:" + this._container);
   }
   static function getInstance()
   {
      return instance;
   }
   function update(o, pInfoObj)
   {
      com.poptropica.util.Debug.trace("AnimTopView::update()  pInfoObj._type=" + pInfoObj._type,com.poptropica.util.Debug.VERBOSE_MESSAGE);
   }
   function changeAnimTopDisplay(pState)
   {
      this._container.gotoAndStop(pState);
   }
   function get container()
   {
      return this._container;
   }
   function make()
   {
      com.poptropica.util.Debug.trace("AnimTopView::make() ",com.poptropica.util.Debug.VERBOSE_MESSAGE);
   }
   function clear()
   {
      com.poptropica.util.Debug.trace("AnimTopView::clear()",com.poptropica.util.Debug.VERBOSE_MESSAGE);
      this._model.removeObserver(this);
   }
}
