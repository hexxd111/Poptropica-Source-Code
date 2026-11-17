class com.poptropica.views.DebuggerView extends com.poptropica.mvc.AbstractView
{
   var _content;
   var _target;
   var _tf;
   var _toggle = true;
   function DebuggerView(m, c, target, depth, x, y)
   {
      super(m,c);
      com.poptropica.util.Debug.trace("DebuggerView::()",com.poptropica.util.Debug.VERBOSE_MESSAGE);
      this._target = target;
      this._content = this._target.createEmptyMovieClip("_debugger_mc",depth);
      this.makeDebugTF(this._content,1,x,y);
   }
   function makeDebugTF(target, depth, x, y)
   {
      com.poptropica.util.Debug.trace("DebuggerView::makeDebugTF()",com.poptropica.util.Debug.VERBOSE_MESSAGE);
      this._tf = target.createTextField("path_debugger",depth,x,y,400,20);
      this._tf.background = true;
      this._tf.backgroundColor = 13421772;
      this._tf.textColor = 3355443;
      this._tf.selectable = false;
   }
   function update(o, pInfoObj)
   {
      com.poptropica.util.Debug.trace("DebuggerView::update()",com.poptropica.util.Debug.VERBOSE_MESSAGE);
      this._tf.text = pInfoObj._type + "  -> " + pInfoObj._data;
   }
}
