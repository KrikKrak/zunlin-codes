package PEUIComponent.TransformToolSource
{
	import PEUIComponent.TransformToolSource.RoxioTVCursor.*;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventPhase;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import mx.core.UIComponent;
	
	/**
	 * The ori announce of this class is list below.
	 * The TransformTools realting classes are organized by Zunlin @ Sonic SH
	 * These classes are used to transform a display object, such as rotate, move...
	 * 
	 * Thanks for Trevor McCauley's great work.
	 * 
	 * @author zunlin_zhang
	 * @date 2007-12-24
	 */	
	
	/**
	 * Creates a transform tool that allows uaers to modify display objects on the screen
	 * 
	 * @usage
	 * <pre>
	 * var tool:TransformTool = new TransformTool();
	 * addChild(tool);
	 * tool.target = targetDisplayObject;
	 * </pre>
	 * 
	 * @version 0.9.10
	 * @author  Trevor McCauley
	 * @author  http://www.senocular.com
	 */
	 
	public class TransformTool extends UIComponent
	{	
		// Variables
		private var toolInvertedMatrix:Matrix = new Matrix();
		private var innerRegistration:Point = new Point();
		private var registrationLog:Dictionary = new Dictionary(true);
		
		private var targetBounds:Rectangle = new Rectangle();
		
		private var mouseLoc:Point = new Point();
		private var mouseOffset:Point = new Point();
		private var innerMouseLoc:Point = new Point();
		private var interactionStart:Point = new Point();
		private var innerInteractionStart:Point = new Point();
		private var interactionStartAngle:Number = 0;
		private var interactionStartMatrix:Matrix = new Matrix();
		
		private var toolSprites:Sprite = new Sprite();
		private var lines:Sprite = new Sprite();
		private var moveControls:Sprite = new Sprite();
		private var registrationControls:Sprite = new Sprite();
		private var rotateControls:Sprite = new Sprite();
		private var scaleControls:Sprite = new Sprite();
		private var skewControls:Sprite = new Sprite();
		private var cursors:Sprite = new Sprite();
		private var customControls:Sprite = new Sprite();
		private var customCursors:Sprite = new Sprite();
		
		// With getter/setters
		private var _target:DisplayObject;
		private var _toolMatrix:Matrix = new Matrix();
		private var _globalMatrix:Matrix = new Matrix();
		
		private var _registration:Point = new Point();
		
		private var _livePreview:Boolean = true;
		private var _raiseNewTargets:Boolean = true;
		private var _moveNewTargets:Boolean = false;
		private var _moveEnabled:Boolean = true;
		private var _registrationEnabled:Boolean = true;
		private var _rotationEnabled:Boolean = true;
		private var _scaleEnabled:Boolean = true; 
		private var _skewEnabled:Boolean = true;
		private var _outlineEnabled:Boolean = true;
		private var _customControlsEnabled:Boolean = true;
		private var _customCursorsEnabled:Boolean = true;
		private var _cursorsEnabled:Boolean = true; 
		private var _rememberRegistration:Boolean = true;
		
		private var _constrainScale:Boolean = false;
		private var _constrainRotationAngle:Number = Math.PI/4; // default at 45 degrees
		private var _constrainRotation:Boolean = false;
		
		private var _moveUnderObjects:Boolean = true;
		private var _maintainControlForm:Boolean = true;
		private var _controlSize:Number = 8;
			
		private var _maxScaleX:Number = Infinity;
		private var _maxScaleY:Number = Infinity;
		
		private var _boundsTopLeft:Point = new Point();
		private var _boundsTop:Point = new Point();
		private var _boundsTopRight:Point = new Point();
		private var _boundsRight:Point = new Point();
		private var _boundsBottomRight:Point = new Point();
		private var _boundsBottom:Point = new Point();
		private var _boundsBottomLeft:Point = new Point();
		private var _boundsLeft:Point = new Point();
		private var _boundsCenter:Point = new Point();
		
		private var _currentControl:TransformToolControl;
		
		private var _moveControl:TransformToolControl;
		private var _registrationControl:TransformToolControl;
		private var _outlineControl:TransformToolControl;
		private var _scaleTopLeftControl:TransformToolControl;
		private var _scaleTopControl:TransformToolControl;
		private var _scaleTopRightControl:TransformToolControl;
		private var _scaleRightControl:TransformToolControl;
		private var _scaleBottomRightControl:TransformToolControl;
		private var _scaleBottomControl:TransformToolControl;
		private var _scaleBottomLeftControl:TransformToolControl;
		private var _scaleLeftControl:TransformToolControl;
		private var _rotationTopLeftControl:TransformToolControl;
		private var _rotationTopRightControl:TransformToolControl;
		private var _rotationBottomRightControl:TransformToolControl;
		private var _rotationBottomLeftControl:TransformToolControl;
		private var _skewTopControl:TransformToolControl;
		private var _skewRightControl:TransformToolControl;
		private var _skewBottomControl:TransformToolControl;
		private var _skewLeftControl:TransformToolControl;
			
		private var _moveCursor:TransformToolCursor;
		private var _registrationCursor:TransformToolCursor;
		private var _rotationCursor:TransformToolCursor;
		private var _scaleCursor:TransformToolCursor;
		private var _skewCursor:TransformToolCursor;
		
		// Event constants
		public static const NEW_TARGET:String = "newTarget";
		public static const TRANSFORM_TARGET:String = "transformTarget";
		public static const TRANSFORM_TOOL:String = "transformTool";
		public static const CONTROL_INIT:String = "controlInit";
		public static const CONTROL_TRANSFORM_TOOL:String = "controlTransformTool";
		public static const CONTROL_DOWN:String = "controlDown";
		public static const CONTROL_MOVE:String = "controlMove";
		public static const CONTROL_UP:String = "controlUp";
		public static const CONTROL_PREFERENCE:String = "controlPreference";
		
		// Skin constants
		public static const REGISTRATION:String = "registration";
		public static const SCALE_TOP_LEFT:String = "scaleTopLeft";
		public static const SCALE_TOP:String = "scaleTop";
		public static const SCALE_TOP_RIGHT:String = "scaleTopRight";
		public static const SCALE_RIGHT:String = "scaleRight";
		public static const SCALE_BOTTOM_RIGHT:String = "scaleBottomRight";
		public static const SCALE_BOTTOM:String = "scaleBottom";
		public static const SCALE_BOTTOM_LEFT:String = "scaleBottomLeft";
		public static const SCALE_LEFT:String = "scaleLeft";
		public static const ROTATION_TOP_LEFT:String = "rotationTopLeft";
		public static const ROTATION_TOP_RIGHT:String = "rotationTopRight";
		public static const ROTATION_BOTTOM_RIGHT:String = "rotationBottomRight";
		public static const ROTATION_BOTTOM_LEFT:String = "rotationBottomLeft";
		public static const SKEW_TOP:String = "skewTop";
		public static const SKEW_RIGHT:String = "skewRight";
		public static const SKEW_BOTTOM:String = "skewBottom";
		public static const SKEW_LEFT:String = "skewLeft";
		public static const CURSOR_REGISTRATION:String = "cursorRegistration";
		public static const CURSOR_MOVE:String = "cursorMove";
		public static const CURSOR_SCALE:String = "cursorScale";
		public static const CURSOR_ROTATION:String = "cursorRotate";
		public static const CURSOR_SKEW:String = "cursorSkew";
		
		// Properties
		
		/**
		 * The display object the transform tool affects
		 */
		public function get target():DisplayObject {
			return _target;
		}
		public function set target(d:DisplayObject):void {
			
			// null target, set target as null
			if (!d) {
				if (_target) {
					_target = null;
					updateControlsVisible();
					dispatchEvent(new Event(NEW_TARGET));
				}
				return;
			}else{
				
				// invalid target, do nothing
				if (d == _target || d == this || contains(d)
				|| (d is DisplayObjectContainer && (d as DisplayObjectContainer).contains(this))) {
					return;
				}
				
				// valid target, set and update
				_target = d;
				updateMatrix();
				setNewRegistation();
				updateControlsVisible();
				
				// raise to top of display list if applies
				if (_raiseNewTargets) {
					raiseTarget();
				}
			}
			
			// if not moving new targets, apply transforms
			if (!_moveNewTargets) {
				apply();
			}
			
			// send event; updates control points
			dispatchEvent(new Event(NEW_TARGET));
				
			// initiate move interaction if applies after controls updated
			if (_moveNewTargets && _moveEnabled && _moveControl) {
				_currentControl = _moveControl;
				_currentControl.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
			}
		}
		
		/**
		 * When true, new targets are placed at the top of their display list
		 * @see target
		 */
		public function get raiseNewTargets():Boolean {
			return _raiseNewTargets;
		}
		public function set raiseNewTargets(b:Boolean):void {
			_raiseNewTargets = b;
		}
		
		/**
		 * When true, new targets are immediately given a move interaction and can be dragged
		 * @see target
		 * @see moveEnabled
		 */
		public function get moveNewTargets():Boolean {
			return _moveNewTargets;
		}
		public function set moveNewTargets(b:Boolean):void {
			_moveNewTargets = b;
		}
		
		/**
		 * When true, the target instance scales with the tool as it is transformed.
		 * When false, transforms in the tool are only reflected when transforms are completed.
		 */
		public function get livePreview():Boolean {
			return _livePreview;
		}
		public function set livePreview(b:Boolean):void {
			_livePreview = b;
		}
		
		/**
		 * Controls the default Control sizes of controls used by the tool
		 */
		public function get controlSize():Number {
			return _controlSize;
		}
		public function set controlSize(n:Number):void {
			if (_controlSize != n) {
				_controlSize = n;
				dispatchEvent(new Event(CONTROL_PREFERENCE));
			}
		}
		
		/**
		 * When true, counters transformations applied to controls by their parent containers
		 */
		public function get maintainControlForm():Boolean {
			return _maintainControlForm;
		}
		public function set maintainControlForm(b:Boolean):void {
			if (_maintainControlForm != b) {
				_maintainControlForm = b;
				dispatchEvent(new Event(CONTROL_PREFERENCE));
			}
		}
		
		/**
		 * When true (default), the transform tool uses an invisible control using the shape of the current
		 * target to allow movement. This means any objects above the target but below the
		 * tool cannot be clicked on since this hidden control will be clicked on first
		 * (allowing you to move objects below others without selecting the objects on top).
		 * When false, the target itself is used for movement and any objects above the target
		 * become clickable preventing tool movement if the target itself is not clicked directly.
		 */
		public function get moveUnderObjects():Boolean {
			return _moveUnderObjects;
		}
		public function set moveUnderObjects(b:Boolean):void {
			if (_moveUnderObjects != b) {
				_moveUnderObjects = b;
				dispatchEvent(new Event(CONTROL_PREFERENCE));
			}
		}
		
		/**
		 * The transform matrix of the tool
		 * as it exists in its on coordinate space
		 * @see globalMatrix
		 */
		public function get toolMatrix():Matrix {
			return _toolMatrix.clone();
		}
		public function set toolMatrix(m:Matrix):void {
			updateMatrix(m, false);
			updateRegistration();
			dispatchEvent(new Event(TRANSFORM_TOOL));
		}
		
		/**
		 * The transform matrix of the tool
		 * as it appears in global space
		 * @see toolMatrix
		 */
		public function get globalMatrix():Matrix {
			var _globalMatrix:Matrix = _toolMatrix.clone();
			_globalMatrix.concat(transform.concatenatedMatrix);
			return _globalMatrix;
		}
		public function set globalMatrix(m:Matrix):void {
			updateMatrix(m);
			updateRegistration();
			dispatchEvent(new Event(TRANSFORM_TOOL));
		}
		
		/**
		 * The location of the registration point in the tool. Note: registration
		 * points are tool-specific.  If you change the registration point of a
		 * target, the new registration will only be reflected in the tool used
		 * to change that point.
		 * @see registrationEnabled
		 * @see rememberRegistration
		 */
		public function get registration():Point {
			return _registration.clone();
		}
		public function set registration(p:Point):void {
			_registration = p.clone();
			innerRegistration = toolInvertedMatrix.transformPoint(_registration);
			
			if (_rememberRegistration) {
				// log new registration point for the next
				// time this target is selected
				registrationLog[_target] = innerRegistration;
			}
			dispatchEvent(new Event(TRANSFORM_TOOL));
		}
		
		/**
		 * The current control being used in the tool if being manipulated.
		 * This value is null if the user is not transforming the tool.
		 */
		public function get currentControl():TransformToolControl {
			return _currentControl;
		}
		
		/**
		 * Allows or disallows users to move the tool
		 */
		public function get moveEnabled():Boolean {
			return _moveEnabled;
		}
		public function set moveEnabled(b:Boolean):void {
			if (_moveEnabled != b) {
				_moveEnabled = b;
				updateControlsEnabled();
			}
		}
		
		/**
		 * Allows or disallows users to see and move the registration point
		 * @see registration
		 * @see rememberRegistration
		 */
		public function get registrationEnabled():Boolean {
			return _registrationEnabled;
		}
		public function set registrationEnabled(b:Boolean):void {
			if (_registrationEnabled != b) {
				_registrationEnabled = b;
				updateControlsEnabled();
			}
		}
		
		/**
		 * Allows or disallows users to see and adjust rotation controls
		 */
		public function get rotationEnabled():Boolean {
			return _rotationEnabled;
		}
		public function set rotationEnabled(b:Boolean):void {
			if (_rotationEnabled != b) {
				_rotationEnabled = b;
				updateControlsEnabled();
			}
		}
		
		/**
		 * Allows or disallows users to see and adjust scale controls
		 */
		public function get scaleEnabled():Boolean {
			return _scaleEnabled;
		}
		public function set scaleEnabled(b:Boolean):void {
			if (_scaleEnabled != b) {
				_scaleEnabled = b;
				updateControlsEnabled();
			}
		}
		
		/**
		 * Allows or disallows users to see and adjust skew controls
		 */
		public function get skewEnabled():Boolean {
			return _skewEnabled;
		}
		public function set skewEnabled(b:Boolean):void {
			if (_skewEnabled != b) {
				_skewEnabled = b;
				updateControlsEnabled();
			}
		}
		
		/**
		 * Allows or disallows users to see tool boundry outlines
		 */
		public function get outlineEnabled():Boolean {
			return _outlineEnabled;
		}
		public function set outlineEnabled(b:Boolean):void {
			if (_outlineEnabled != b) {
				_outlineEnabled = b;
				updateControlsEnabled();
			}
		}
		
		/**
		 * Allows or disallows users to see native cursors
		 * @see addCursor
		 * @see removeCursor
		 * @see customCursorsEnabled
		 */
		public function get cursorsEnabled():Boolean {
			return _cursorsEnabled;
		}
		public function set cursorsEnabled(b:Boolean):void {
			if (_cursorsEnabled != b) {
				_cursorsEnabled = b;
				updateControlsEnabled();
			}
		}
		
		/**
		 * Allows or disallows users to see and use custom controls
		 * @see addControl
		 * @see removeControl
		 * @see customCursorsEnabled
		 */
		public function get customControlsEnabled():Boolean {
			return _customControlsEnabled;
		}
		public function set customControlsEnabled(b:Boolean):void {
			if (_customControlsEnabled != b) {
				_customControlsEnabled = b;
				updateControlsEnabled();
				dispatchEvent(new Event(CONTROL_PREFERENCE));
			}
		}
		
		/**
		 * Allows or disallows users to see custom cursors
		 * @see addCursor
		 * @see removeCursor
		 * @see cursorsEnabled
		 * @see customControlsEnabled
		 */
		public function get customCursorsEnabled():Boolean {
			return _customCursorsEnabled;
		}
		public function set customCursorsEnabled(b:Boolean):void {
			if (_customCursorsEnabled != b) {
				_customCursorsEnabled = b;
				updateControlsEnabled();
				dispatchEvent(new Event(CONTROL_PREFERENCE));
			}
		}
		
		/**
		 * Allows or disallows users to see custom cursors
		 * @see registration
		 */
		public function get rememberRegistration():Boolean {
			return _rememberRegistration;
		}
		public function set rememberRegistration(b:Boolean):void {
			_rememberRegistration = b;
			if (!_rememberRegistration) {
				registrationLog = new Dictionary(true);
			}
		}
		
		/**
		 * Allows constraining of scale transformations that scale along both X and Y.
		 * @see constrainRotation
		 */
		public function get constrainScale():Boolean {
			return _constrainScale;
		}
		public function set constrainScale(b:Boolean):void {
			if (_constrainScale != b) {
				_constrainScale = b;
				dispatchEvent(new Event(CONTROL_PREFERENCE));
			}
		}
		
		/**
		 * Allows constraining of rotation transformations by an angle
		 * @see constrainRotationAngle
		 * @see constrainScale
		 */
		public function get constrainRotation():Boolean {
			return _constrainRotation;
		}
		public function set constrainRotation(b:Boolean):void {
			if (_constrainRotation != b) {
				_constrainRotation = b;
				dispatchEvent(new Event(CONTROL_PREFERENCE));
			}
		}
		
		/**
		 * The angle at which rotation is constrainged when constrainRotation is true
		 * @see constrainRotation
		 */
		public function get constrainRotationAngle():Number {
			return _constrainRotationAngle * 180/Math.PI;
		}
		public function set constrainRotationAngle(n:Number):void {
			var angleInRadians:Number = n * Math.PI/180;
			if (_constrainRotationAngle != angleInRadians) {
				_constrainRotationAngle = angleInRadians;
				dispatchEvent(new Event(CONTROL_PREFERENCE));
			}
		}
		
		/**
		 * The maximum scaleX allowed to be applied to a target
		 */
		public function get maxScaleX():Number {
			return _maxScaleX;
		}
		public function set maxScaleX(n:Number):void {
			_maxScaleX = n;
		}
		
		/**
		 * The maximum scaleY allowed to be applied to a target
		 */
		public function get maxScaleY():Number {
			return _maxScaleY;
		}
		public function set maxScaleY(n:Number):void {
			_maxScaleY = n;
		}
		
		public function get boundsTopLeft():Point { return _boundsTopLeft.clone(); }
		public function get boundsTop():Point { return _boundsTop.clone(); }
		public function get boundsTopRight():Point { return _boundsTopRight.clone(); }
		public function get boundsRight():Point { return _boundsRight.clone(); }
		public function get boundsBottomRight():Point { return _boundsBottomRight.clone(); }
		public function get boundsBottom():Point { return _boundsBottom.clone(); }
		public function get boundsBottomLeft():Point { return _boundsBottomLeft.clone(); }
		public function get boundsLeft():Point { return _boundsLeft.clone(); }
		public function get boundsCenter():Point { return _boundsCenter.clone(); }
		public function get mouse():Point { return new Point(mouseX, mouseY); }
		
		public function get moveControl():TransformToolControl { return _moveControl; }
		public function get registrationControl():TransformToolControl { return _registrationControl; }
		public function get outlineControl():TransformToolControl { return _outlineControl; }
		public function get scaleTopLeftControl():TransformToolControl { return _scaleTopLeftControl; }
		public function get scaleTopControl():TransformToolControl { return _scaleTopControl; }
		public function get scaleTopRightControl():TransformToolControl { return _scaleTopRightControl; }
		public function get scaleRightControl():TransformToolControl { return _scaleRightControl; }
		public function get scaleBottomRightControl():TransformToolControl { return _scaleBottomRightControl; }
		public function get scaleBottomControl():TransformToolControl { return _scaleBottomControl; }
		public function get scaleBottomLeftControl():TransformToolControl { return _scaleBottomLeftControl; }
		public function get scaleLeftControl():TransformToolControl { return _scaleLeftControl; }
		public function get rotationTopLeftControl():TransformToolControl { return _rotationTopLeftControl; }
		public function get rotationTopRightControl():TransformToolControl { return _rotationTopRightControl; }
		public function get rotationBottomRightControl():TransformToolControl { return _rotationBottomRightControl; }
		public function get rotationBottomLeftControl():TransformToolControl { return _rotationBottomLeftControl; }
		public function get skewTopControl():TransformToolControl { return _skewTopControl; }
		public function get skewRightControl():TransformToolControl { return _skewRightControl; }
		public function get skewBottomControl():TransformToolControl { return _skewBottomControl; }
		public function get skewLeftControl():TransformToolControl { return _skewLeftControl; }
		
		public function get moveCursor():TransformToolCursor { return _moveCursor; }
		public function get registrationCursor():TransformToolCursor { return _registrationCursor; }
		public function get rotationCursor():TransformToolCursor { return _rotationCursor; }
		public function get scaleCursor():TransformToolCursor { return _scaleCursor; }
		public function get skewCursor():TransformToolCursor { return _skewCursor; }
		
//===================================================
// functions added by Zunlin
		private var _singleSideScaleEnable:Boolean = true;
		private var _singleSideScaleAdded:Boolean = false;
		public function set singleSideScaleEnable(val:Boolean):void
		{
			_singleSideScaleEnable = val;
			if (val == true)
			{
				_scaleCursor.addReference(_scaleTopControl);
				_scaleCursor.addReference(_scaleRightControl);
				_scaleCursor.addReference(_scaleBottomControl);
				_scaleCursor.addReference(_scaleLeftControl);
				
				addToolControl(scaleControls, _scaleTopControl);
				addToolControl(scaleControls, _scaleRightControl);
				addToolControl(scaleControls, _scaleBottomControl);
				addToolControl(scaleControls, _scaleLeftControl);
				
				_singleSideScaleAdded = true;
			}
			else
			{
				if (_singleSideScaleAdded == true)
				{
					_scaleCursor.removeReference(_scaleTopControl);
					_scaleCursor.removeReference(_scaleRightControl);
					_scaleCursor.removeReference(_scaleBottomControl);
					_scaleCursor.removeReference(_scaleLeftControl);
					
					removeToolControl(scaleControls, _scaleTopControl);
					removeToolControl(scaleControls, _scaleRightControl);
					removeToolControl(scaleControls, _scaleBottomControl);
					removeToolControl(scaleControls, _scaleLeftControl);
					
					_singleSideScaleAdded = false;
				}
			}
		}

		public function get rotateAngle():Number
		{
			return target.rotation * Math.PI / 180;
		}
		
		public function get objectSize():Rectangle
		{		
			var w:Number = Math.sqrt((boundsTopLeft.x - boundsTopRight.x) * (boundsTopLeft.x - boundsTopRight.x)
												+ (boundsTopLeft.y - boundsTopRight.y) * (boundsTopLeft.y - boundsTopRight.y));
			var h:Number = Math.sqrt((boundsTopLeft.x - boundsBottomLeft.x) * (boundsTopLeft.x - boundsBottomLeft.x)
												+ (boundsTopLeft.y - boundsBottomLeft.y) * (boundsTopLeft.y - boundsBottomLeft.y));
			return new Rectangle(0, 0, w, h);
		}
		
		public function get globalTopLeft():Point
		{
			if (rotateAngle <= 0 && rotateAngle > -Math.PI / 2)
			{
				return boundsTopLeft;
			}
			else if (rotateAngle <= -Math.PI / 2 && rotateAngle > -Math.PI)
			{
				return boundsTopRight;
			}
			else if (rotateAngle > 0 && rotateAngle <= Math.PI / 2)
			{
				return boundsBottomLeft;
			}
			else
			{
				return boundsBottomRight;
			}
		}
		
		public function get newBound():Rectangle
		{
			var w:Number = Math.max(Math.abs(boundsTopLeft.x - boundsBottomRight.x), Math.abs(boundsTopRight.x - boundsBottomLeft.x));
			var h:Number = Math.max(Math.abs(boundsTopLeft.y - boundsBottomRight.y), Math.abs(boundsTopRight.y - boundsBottomLeft.y));
			return new Rectangle(0, 0, w, h);
		}
		
		public function get objectDataCopy():BitmapData
		{
			var wh:Rectangle = objectSize;
			var w:Number = wh.width;
			var h:Number = wh.height;
			var m:Matrix = target.transform.matrix.clone();
			
			if (rotateAngle > Math.PI / 2)
			{
				var beta:Number = Math.PI - rotateAngle;
				m.tx = h / Math.sin(beta) + (w - h / Math.tan(beta)) * Math.cos(beta);
				m.ty = h * Math.sin(Math.PI / 2 - beta);
			}
			else if (rotateAngle >= 0)
			{
				m.tx = h * Math.sin(rotateAngle);
				m.ty = 0;
			}
			else if (rotateAngle < -Math.PI / 2)
			{
				beta = Math.PI + rotateAngle;
				m.tx = w * Math.cos(beta);
				m.ty = w * Math.sin(beta) + h * Math.cos(beta);
			}
			else if (rotateAngle < 0)
			{
				m.tx = 0
				m.ty = w * Math.sin(-rotateAngle);
			}
			
			var bound:Rectangle = newBound;
			var bd:BitmapData = new BitmapData(bound.width, bound.height, true, 0x00000000);
			bd.draw(target, m, target.transform.colorTransform);
			return bd.clone();
		}
		
		/**
		 * Allow user change the target size from outside. It will adjust the size and pos
		 * to matain the target in the ori center pos.
		 * 
		 * @param w width of new size
		 * @param h height of new size. If 0, mean matains ori ratio. Only use width to adjust
		 */
		private var resetTargetTimer:Timer;
		private const TARGET_UPDATE_INTERVAL:int = 50;
		private var backupTarget:DisplayObject;
		public function newTargetSize(imgw:Number, imgh:Number = 0, parentXOffset:Number = 0, parentYOffset:Number = 0):void
		{
			var oriSize:Rectangle = objectSize;
			// calc h if matain ori ratio
			if (imgh == 0)
			{
				imgh = imgw * oriSize.height / oriSize.width;
			}
			
			// get w from bound width to image width
			var absAngle:Number = Math.abs(rotateAngle);
			while (absAngle - Math.PI / 2 >= 0)
			{
				absAngle -= Math.PI / 2;
			}
			var nbw:Number = imgw * Math.cos(absAngle) + imgh * Math.sin(absAngle);
			var nbh:Number = imgw * Math.sin(absAngle) + imgh * Math.cos(absAngle);
			var newbound:Rectangle = new Rectangle(0, 0, nbw, nbh);
			var oldbound:Rectangle = newBound;
			
			if (rotateAngle <= 0 && rotateAngle > -Math.PI / 2)
			{
				var a:Number = oriSize.width * Math.sin(absAngle);
				var newa:Number = a * imgw / oriSize.width;
				oldbound.x = target.x;
				oldbound.y = target.y - a;
				newbound.x = target.x;
				newbound.y = target.y - newa;
			}
			else if (rotateAngle <= -Math.PI / 2 && rotateAngle > -Math.PI)
			{
				a = oriSize.width * Math.sin(absAngle);
				newa = a * imgw / oriSize.width;
				oldbound.x = target.x - a;
				oldbound.y = target.y - oldbound.height;
				newbound.x = target.x - newa;
				newbound.y = target.y - newbound.height;
			}
			else if (rotateAngle > 0 && rotateAngle <= Math.PI / 2)
			{
				a = oriSize.height * Math.sin(absAngle);
				newa = a * imgw / oriSize.width;
				oldbound.x = target.x - a;
				oldbound.y = target.y;
				newbound.x = target.x - newa;
				newbound.y = target.y;
			}
			else
			{
				a = oriSize.height * Math.sin(absAngle);
				newa = a * imgw / oriSize.width;
				oldbound.x = target.x - oldbound.width;
				oldbound.y = target.y - a;
				newbound.x = target.x - newbound.width;
				newbound.y = target.y - newa;
			}
			
			// set new offset
			var xOffset:Number = oldbound.x + (oldbound.width / 2) - newbound.x - (newbound.width / 2);
			var yOffset:Number = oldbound.y + (oldbound.height / 2) - newbound.y - (newbound.height / 2);
			
			backupTarget = target;
			target = null;
			
			// set new size
			backupTarget.width = imgw;
			backupTarget.height = imgh;
			
			backupTarget.x += xOffset + parentXOffset;
			backupTarget.y += yOffset + parentXOffset;
			
			resetTargetTimer.reset();
			resetTargetTimer.start();
		}
		
		private function OnTargetUpdate(event:TimerEvent):void
		{
			resetTargetTimer.stop();
			
			target = backupTarget;
			raiseNewTargets = false;
			moveUnderObjects = false;
			skewEnabled = false;
			constrainScale = true;
			singleSideScaleEnable = false;
			rememberRegistration = false;
			registrationEnabled = false;
			registration = boundsCenter;
		}
		
//===================================================
		
		/**
		 * TransformTool Constructor.
		 * Creates new instances of the transform tool
		 */
		public function TransformTool() {
			resetTargetTimer = new Timer(TARGET_UPDATE_INTERVAL);
			resetTargetTimer.addEventListener(TimerEvent.TIMER, OnTargetUpdate, false, 0, true);
			createControls();
		}
		
		/**
		 * Provides a string representation of the transform instance
		 */
		override public function toString():String {
			return "[Transform Tool: target=" + String(_target) + "]" ;
		}
		
		// Setup
		private function createControls():void {
			
			// defining controls
			_moveControl = new TransformToolMoveShape("move", moveInteraction);
			_registrationControl = new TransformToolRegistrationControl(REGISTRATION, registrationInteraction, "registration");
			_rotationTopLeftControl = new TransformToolRotateControl(ROTATION_TOP_LEFT, rotationInteraction, "boundsTopLeft");
			_rotationTopRightControl = new TransformToolRotateControl(ROTATION_TOP_RIGHT, rotationInteraction, "boundsTopRight");
			_rotationBottomRightControl = new TransformToolRotateControl(ROTATION_BOTTOM_RIGHT, rotationInteraction, "boundsBottomRight");
			_rotationBottomLeftControl = new TransformToolRotateControl(ROTATION_BOTTOM_LEFT, rotationInteraction, "boundsBottomLeft");
			_scaleTopLeftControl = new TransformToolScaleControl(SCALE_TOP_LEFT, scaleBothInteraction, "boundsTopLeft");
			_scaleTopRightControl = new TransformToolScaleControl(SCALE_TOP_RIGHT, scaleBothInteraction, "boundsTopRight");
			_scaleBottomRightControl = new TransformToolScaleControl(SCALE_BOTTOM_RIGHT, scaleBothInteraction, "boundsBottomRight");
			_scaleBottomLeftControl = new TransformToolScaleControl(SCALE_BOTTOM_LEFT, scaleBothInteraction, "boundsBottomLeft");
			_scaleTopControl = new TransformToolScaleControl(SCALE_TOP, scaleYInteraction, "boundsTop");
			_scaleRightControl = new TransformToolScaleControl(SCALE_RIGHT, scaleXInteraction, "boundsRight");
			_scaleBottomControl = new TransformToolScaleControl(SCALE_BOTTOM, scaleYInteraction, "boundsBottom");
			_scaleLeftControl = new TransformToolScaleControl(SCALE_LEFT, scaleXInteraction, "boundsLeft");
			_skewTopControl = new TransformToolSkewBar(SKEW_TOP, skewXInteraction, "boundsTopRight", "boundsTopLeft", "boundsTopRight");
			_skewRightControl = new TransformToolSkewBar(SKEW_RIGHT, skewYInteraction, "boundsBottomRight", "boundsTopRight", "boundsBottomRight");
			_skewBottomControl = new TransformToolSkewBar(SKEW_BOTTOM, skewXInteraction, "boundsBottomLeft", "boundsBottomRight", "boundsBottomLeft");
			_skewLeftControl = new TransformToolSkewBar(SKEW_LEFT, skewYInteraction, "boundsTopLeft", "boundsBottomLeft", "boundsTopLeft");
			
			// defining cursors
			//_moveCursor = new TransformToolMoveCursor();
			_moveCursor = new RoxioTVMoveCursor();
			_moveCursor.addReference(_moveControl);
			
			_registrationCursor = new TransformToolRegistrationCursor();
			_registrationCursor.addReference(_registrationControl);
			
			//_rotationCursor = new TransformToolRotateCursor();
			_rotationCursor = new RoxioTVRotateCursor();
			_rotationCursor.addReference(_rotationTopLeftControl);
			_rotationCursor.addReference(_rotationTopRightControl);
			_rotationCursor.addReference(_rotationBottomRightControl);
			_rotationCursor.addReference(_rotationBottomLeftControl);
			
			//_scaleCursor = new TransformToolScaleCursor();
			_scaleCursor = new RoxioTVScaleCursor();
			_scaleCursor.addReference(_scaleTopLeftControl);
			_scaleCursor.addReference(_scaleTopRightControl);
			_scaleCursor.addReference(_scaleBottomRightControl);
			_scaleCursor.addReference(_scaleBottomLeftControl);
			
			_skewCursor = new TransformToolSkewCursor();
			_skewCursor.addReference(_skewTopControl);
			_skewCursor.addReference(_skewRightControl);
			_skewCursor.addReference(_skewBottomControl);
			_skewCursor.addReference(_skewLeftControl);
			
			// adding controls
			addToolControl(moveControls, _moveControl);
			addToolControl(registrationControls, _registrationControl);
			addToolControl(rotateControls, _rotationTopLeftControl);
			addToolControl(rotateControls, _rotationTopRightControl);
			addToolControl(rotateControls, _rotationBottomRightControl);
			addToolControl(rotateControls, _rotationBottomLeftControl);

			addToolControl(scaleControls, _scaleTopLeftControl);
			addToolControl(scaleControls, _scaleTopRightControl);
			addToolControl(scaleControls, _scaleBottomRightControl);
			addToolControl(scaleControls, _scaleBottomLeftControl);
			addToolControl(skewControls, _skewTopControl);
			addToolControl(skewControls, _skewRightControl);
			addToolControl(skewControls, _skewBottomControl);
			addToolControl(skewControls, _skewLeftControl);
			addToolControl(lines, new TransformToolOutline("outline"), false);
			
			// adding cursors
			addToolControl(cursors, _moveCursor, false);
			addToolControl(cursors, _registrationCursor, false);
			addToolControl(cursors, _rotationCursor, false);
			addToolControl(cursors, _scaleCursor, false);
			addToolControl(cursors, _skewCursor, false);
			
			singleSideScaleEnable = true;
			
			updateControlsEnabled();
		}
		
		private function addToolControl(container:Sprite, control:TransformToolControl, interactive:Boolean = true):void {
			control.transformTool = this;
			if (interactive) {
				control.addEventListener(MouseEvent.MOUSE_DOWN, startInteractionHandler);	
			}
			container.addChild(control);
			control.dispatchEvent(new Event(CONTROL_INIT));
		}
		
		/**
		 * Added by Zunlin
		 * Remove internal tool control from the container
		 */		
		private function removeToolControl(container:Sprite, control:TransformToolControl):void
		{
			if (container.contains(control))
			{
				container.removeChild(control);
			}	
		}
		
		/**
		 * Allows you to add a custom control to the tool
		 * @see removeControl
		 * @see addCursor
		 * @see removeCursor
		 */
		public function addControl(control:TransformToolControl):void {
			addToolControl(customControls, control);
		}
		
		/**
		 * Allows you to remove a custom control to the tool
		 * @see addControl
		 * @see addCursor
		 * @see removeCursor
		 */
		public function removeControl(control:TransformToolControl):TransformToolControl {
			if (customControls.contains(control)) {
				customControls.removeChild(control);
				return control;
			}
			return null;
		}
		
		/**
		 * Allows you to add a custom cursor to the tool
		 * @see removeCursor
		 * @see addControl
		 * @see removeControl
		 */
		public function addCursor(cursor:TransformToolCursor):void {
			addToolControl(customCursors, cursor);
		}
		
		/**
		 * Allows you to remove a custom cursor to the tool
		 * @see addCursor
		 * @see addControl
		 * @see removeControl
		 */
		public function removeCursor(cursor:TransformToolCursor):TransformToolCursor {
			if (customCursors.contains(cursor)) {
				customCursors.removeChild(cursor);
				return cursor;
			}
			return null;
		}
		
		/**
		 * Allows you to change the appearance of default controls
		 * @see addControl
		 * @see removeControl
		 */
		public function setSkin(controlName:String, skin:DisplayObject):void {
			var control:TransformToolInternalControl = getControlByName(controlName);
			if (control) {
				control.skin = skin;
			}
		}
		
		/**
		 * Allows you to get the skin of an existing control.
		 * If one was not set, null is returned
		 * @see addControl
		 * @see removeControl
		 */
		public function getSkin(controlName:String):DisplayObject {
			var control:TransformToolInternalControl = getControlByName(controlName);
			return control.skin;
		}
		
		private function getControlByName(controlName:String):TransformToolInternalControl {
			var control:TransformToolInternalControl;
			var containers:Array = new Array(skewControls, registrationControls, cursors, rotateControls, scaleControls);
			var i:int = containers.length;
			while (i-- && control == null) {
				control = containers[i].getChildByName(controlName) as TransformToolInternalControl;
			}
			return control;
		}
		
		// Interaction Handlers
		private function startInteractionHandler(event:MouseEvent):void {
			_currentControl = event.currentTarget as TransformToolControl;
			if (_currentControl) {
				setupInteraction();
			}
		}
		
		private function setupInteraction():void {
			updateMatrix();
			apply();
			dispatchEvent(new Event(CONTROL_DOWN));
			
			// mouse offset to allow interaction from desired point
			mouseOffset = (_currentControl && _currentControl.referencePoint) ? _currentControl.referencePoint.subtract(new Point(mouseX, mouseY)) : new Point(0, 0);
			updateMouse();
			
			// set variables for interaction reference
			interactionStart = mouseLoc.clone();
			innerInteractionStart = innerMouseLoc.clone();
			interactionStartMatrix = _toolMatrix.clone();
			interactionStartAngle = distortAngle();
			
			if (stage) {
				// setup stage events to manage control interaction
				stage.addEventListener(MouseEvent.MOUSE_MOVE, interactionHandler);
				stage.addEventListener(MouseEvent.MOUSE_UP, endInteractionHandler, false);
				stage.addEventListener(MouseEvent.MOUSE_UP, endInteractionHandler, true);
			}
		}
		
		private function interactionHandler(event:MouseEvent):void {
			// define mouse position for interaction
			updateMouse();
			
			// use original toolMatrix for reference of interaction
			_toolMatrix = interactionStartMatrix.clone();
			
			// dispatch events that let controls do their thing
			dispatchEvent(new Event(CONTROL_MOVE));
			dispatchEvent(new Event(CONTROL_TRANSFORM_TOOL));
			
			if (_livePreview) {
				// update target if applicable
				apply();
			}
			
			// smooth sailing
			event.updateAfterEvent();
		}
		
		private function endInteractionHandler(event:MouseEvent):void {
			if (event.eventPhase == EventPhase.BUBBLING_PHASE || !(event.currentTarget is Stage)) {
				// ignore unrelated events received by stage
				return;
			}
			
			if (!_livePreview) {
				// update target if applicable
				apply();
			}
			
			// get stage reference from event in case
			// stage is no longer accessible from this instance
			var stageRef:Stage = event.currentTarget as Stage;
			stageRef.removeEventListener(MouseEvent.MOUSE_MOVE, interactionHandler);
			stageRef.removeEventListener(MouseEvent.MOUSE_UP, endInteractionHandler, false);
			stageRef.removeEventListener(MouseEvent.MOUSE_UP, endInteractionHandler, true);
			dispatchEvent(new Event(CONTROL_UP));
			_currentControl = null;
		}
		
		// Interaction Transformations
		/**
		 * Control Interaction.  Moves the tool
		 */
		public function moveInteraction():void {
			var moveLoc:Point = mouseLoc.subtract(interactionStart);
			_toolMatrix.tx += moveLoc.x;
			_toolMatrix.ty += moveLoc.y;
			updateRegistration();
			completeInteraction();
		}
		
		/**
		 * Control Interaction.  Moves the registration point
		 */
		public function registrationInteraction():void {
			// move registration point
			_registration.x = mouseLoc.x;
			_registration.y = mouseLoc.y;
			innerRegistration = toolInvertedMatrix.transformPoint(_registration);
			
			if (_rememberRegistration) {
				// log new registration point for the next
				// time this target is selected
				registrationLog[_target] = innerRegistration;
			}
			completeInteraction();
		}
		
		/**
		 * Control Interaction.  Rotates the tool
		 */
		public function rotationInteraction():void {
			// rotate in global transform
			var globalMatrix:Matrix = transform.concatenatedMatrix;
			var globalInvertedMatrix:Matrix = globalMatrix.clone();
			globalInvertedMatrix.invert();
			_toolMatrix.concat(globalMatrix);
			
			// get change in rotation
			var angle:Number = distortAngle() - interactionStartAngle;
			
			if (_constrainRotation) {
				// constrain rotation based on constrainRotationAngle
				if (angle > Math.PI) {
					angle -= Math.PI*2;
				}else if (angle < -Math.PI) {
					angle += Math.PI*2;
				}
				angle = Math.round(angle/_constrainRotationAngle)*_constrainRotationAngle;
			}
			
			// apply rotation to toolMatrix
			_toolMatrix.rotate(angle);
			
			_toolMatrix.concat(globalInvertedMatrix);
			completeInteraction(true);
		}
		
		/**
		 * Control Interaction.  Scales the tool along the X axis
		 */
		public function scaleXInteraction():void {
			
			// get distortion offset vertical movement
			var distortH:Point = distortOffset(new Point(innerMouseLoc.x, innerInteractionStart.y), innerInteractionStart.x - innerRegistration.x);
			
			// update the matrix for vertical scale
			_toolMatrix.a += distortH.x;
			_toolMatrix.b += distortH.y;
			completeInteraction(true);
		}
		
		/**
		 * Control Interaction.  Scales the tool along the Y axis
		 */
		public function scaleYInteraction():void {
			// get distortion offset vertical movement
			var distortV:Point = distortOffset(new Point(innerInteractionStart.x, innerMouseLoc.y), innerInteractionStart.y - innerRegistration.y);
			
			// update the matrix for vertical scale
			_toolMatrix.c += distortV.x;
			_toolMatrix.d += distortV.y;
			completeInteraction(true);
		}
		
		/**
		 * Control Interaction.  Scales the tool along both the X and Y axes
		 */
		public function scaleBothInteraction():void {
			// mouse reference, may change from innerMouseLoc if constraining
			var innerMouseRef:Point = innerMouseLoc.clone();
			
			if (_constrainScale) {
				
				// how much the mouse has moved from starting the interaction
				var moved:Point = innerMouseLoc.subtract(innerInteractionStart);
				
				// the relationship of the start location to the registration point
				var regOffset:Point = innerInteractionStart.subtract(innerRegistration);
				
				// find the ratios between movement and the registration offset
				var ratioH:Number = regOffset.x ? moved.x/regOffset.x : 0;
				var ratioV:Number = regOffset.y ? moved.y/regOffset.y : 0;
				
				// have the larger of the movement distances brought down
				// based on the lowest ratio to fit the registration offset
				if (ratioH > ratioV) {
					innerMouseRef.x = innerInteractionStart.x + regOffset.x * ratioV;
				}else{
					innerMouseRef.y = innerInteractionStart.y + regOffset.y * ratioH;
				}
			}
			
			// get distortion offsets for both vertical and horizontal movements
			var distortH:Point = distortOffset(new Point(innerMouseRef.x, innerInteractionStart.y), innerInteractionStart.x - innerRegistration.x);
			var distortV:Point = distortOffset(new Point(innerInteractionStart.x, innerMouseRef.y), innerInteractionStart.y - innerRegistration.y);
			
			// update the matrix for both scales
			_toolMatrix.a += distortH.x;
			_toolMatrix.b += distortH.y;
			_toolMatrix.c += distortV.x;
			_toolMatrix.d += distortV.y;
			completeInteraction(true);
		}
		
		/**
		 * Control Interaction.  Skews the tool along the X axis
		 */
		public function skewXInteraction():void {
			var distortH:Point = distortOffset(new Point(innerMouseLoc.x, innerInteractionStart.y), innerInteractionStart.y - innerRegistration.y);
			_toolMatrix.c += distortH.x;
			_toolMatrix.d += distortH.y;
			completeInteraction(true);
		}
		
		/**
		 * Control Interaction.  Skews the tool along the Y axis
		 */
		public function skewYInteraction():void {
			var distortV:Point = distortOffset(new Point(innerInteractionStart.x, innerMouseLoc.y), innerInteractionStart.x - innerRegistration.x);
			_toolMatrix.a += distortV.x;
			_toolMatrix.b += distortV.y;
			completeInteraction(true);
		}
		
		private function distortOffset(offset:Point, regDiff:Number):Point {
			// get changes in matrix combinations based on targetBounds
			var ratioH:Number = regDiff ? targetBounds.width/regDiff : 0;
			var ratioV:Number = regDiff ? targetBounds.height/regDiff : 0;
			offset = interactionStartMatrix.transformPoint(offset).subtract(interactionStart);
			offset.x *= targetBounds.width ? ratioH/targetBounds.width : 0;
			offset.y *= targetBounds.height ? ratioV/targetBounds.height : 0;
			return offset;
		}
		
		private function completeInteraction(offsetReg:Boolean = false):void {
			enforceLimits();
			if (offsetReg) {
				// offset of registration to have transformations based around
				// custom registration point
				var offset:Point = _registration.subtract(_toolMatrix.transformPoint(innerRegistration));
				_toolMatrix.tx += offset.x;
				_toolMatrix.ty += offset.y;
			}
			updateBounds();
		}
		
		// Information
		private function distortAngle():Number {
			// use global mouse and registration
			var globalMatrix:Matrix = transform.concatenatedMatrix;
			var gMouseLoc:Point = globalMatrix.transformPoint(mouseLoc);
			var gRegistration:Point = globalMatrix.transformPoint(_registration);
			
			// distance and angle of mouse from registration
			var offset:Point = gMouseLoc.subtract(gRegistration);
			return Math.atan2(offset.y, offset.x);
		}
		
		// Updates
		private function updateMouse():void {
			mouseLoc = new Point(mouseX, mouseY).add(mouseOffset);
			innerMouseLoc = toolInvertedMatrix.transformPoint(mouseLoc);
		}
		
		private function updateMatrix(useMatrix:Matrix = null, counterTransform:Boolean = true):void {
			if (_target) {
				_toolMatrix = useMatrix ? useMatrix.clone() : _target.transform.concatenatedMatrix.clone();
				if (counterTransform) {
					// counter transform of the parents of the tool
					var current:Matrix = transform.concatenatedMatrix;
					current.invert();
					_toolMatrix.concat(current);
				}
				enforceLimits();
				toolInvertedMatrix = _toolMatrix.clone();
				toolInvertedMatrix.invert();
				updateBounds();
			}
		}
		
		private function updateBounds():void {
			if (_target) {
				// update tool bounds based on target bounds
				targetBounds = _target.getBounds(_target);
				_boundsTopLeft = _toolMatrix.transformPoint(new Point(targetBounds.left, targetBounds.top));
				_boundsTopRight = _toolMatrix.transformPoint(new Point(targetBounds.right, targetBounds.top));
				_boundsBottomRight = _toolMatrix.transformPoint(new Point(targetBounds.right, targetBounds.bottom));
				_boundsBottomLeft = _toolMatrix.transformPoint(new Point(targetBounds.left, targetBounds.bottom));
				_boundsTop = Point.interpolate(_boundsTopLeft, _boundsTopRight, .5);
				_boundsRight = Point.interpolate(_boundsTopRight, _boundsBottomRight, .5);
				_boundsBottom = Point.interpolate(_boundsBottomRight, _boundsBottomLeft, .5);
				_boundsLeft = Point.interpolate(_boundsBottomLeft, _boundsTopLeft, .5);
				_boundsCenter = Point.interpolate(_boundsTopLeft, _boundsBottomRight, .5);
			}
		}
		
		private function updateControlsVisible():void {
			// show toolSprites only if there is a valid target
			var isChild:Boolean = contains(toolSprites);
			if (_target) {
				if (!isChild) {
					addChild(toolSprites);
				}				
			}else if (isChild) {
				removeChild(toolSprites);
			}
		}
		
		private function updateControlsEnabled():void {
			// highest arrangement
			updateControlContainer(customCursors, _customCursorsEnabled);
			updateControlContainer(cursors, _cursorsEnabled);
			updateControlContainer(customControls, _customControlsEnabled);
			updateControlContainer(registrationControls, _registrationEnabled);
			updateControlContainer(scaleControls, _scaleEnabled);
			updateControlContainer(skewControls, _skewEnabled);
			updateControlContainer(moveControls, _moveEnabled);
			updateControlContainer(rotateControls, _rotationEnabled);
			updateControlContainer(lines, _outlineEnabled);
			// lowest arrangement
		}
		
		private function updateControlContainer(container:Sprite, enabled:Boolean):void {
			var isChild:Boolean = toolSprites.contains(container);
			if (enabled) {
				// add child or sent to bottom if enabled
				if (isChild) {
					toolSprites.setChildIndex(container, 0);
				}else{
					toolSprites.addChildAt(container, 0);
				}
			}else if (isChild) {
				// removed if disabled
				toolSprites.removeChild(container);
			}
		}
		
		private function updateRegistration():void {
			_registration = _toolMatrix.transformPoint(innerRegistration);
		}
		
		private function enforceLimits():void {
			
			var currScale:Number;
			var angle:Number;
			var enforced:Boolean = false;
			
			// use global matrix
			var _globalMatrix:Matrix = _toolMatrix.clone();
			_globalMatrix.concat(transform.concatenatedMatrix);
			
			// check current scale in X
			currScale = Math.sqrt(_globalMatrix.a * _globalMatrix.a + _globalMatrix.b * _globalMatrix.b);
			if (currScale > _maxScaleX) {
				// set scaleX to no greater than _maxScaleX
				angle = Math.atan2(_globalMatrix.b, _globalMatrix.a);
				_globalMatrix.a = Math.cos(angle) * _maxScaleX;
				_globalMatrix.b = Math.sin(angle) * _maxScaleX;
				enforced = true;
			}
			
			// check current scale in Y
			currScale = Math.sqrt(_globalMatrix.c * _globalMatrix.c + _globalMatrix.d * _globalMatrix.d);
			if (currScale > _maxScaleY) {
				// set scaleY to no greater than _maxScaleY
				angle= Math.atan2(_globalMatrix.c, _globalMatrix.d);
				_globalMatrix.d = Math.cos(angle) * _maxScaleY;
				_globalMatrix.c = Math.sin(angle) * _maxScaleY;
				enforced = true;
			}
			
			
			// if scale was enforced, apply to _toolMatrix
			if (enforced) {
				_toolMatrix = _globalMatrix;
				var current:Matrix = transform.concatenatedMatrix;
				current.invert();
				_toolMatrix.concat(current);
			}
		}
		
		// Render
		private function setNewRegistation():void {
			if (_rememberRegistration && _target in registrationLog) {
				
				// retrieved saved reg point in log
				var savedReg:Point = registrationLog[_target];
				innerRegistration = registrationLog[_target];
			}else{
				
				// use internal own point
				innerRegistration = new Point(0, 0);
			}
			updateRegistration();
		}
		
		private function raiseTarget():void {
			// set target to last object in display list
			var index:int = _target.parent.numChildren - 1;
			_target.parent.setChildIndex(_target, index);
			
			// if this tool is in the same display list
			// raise it to the top above target
			if (_target.parent == parent) {
				parent.setChildIndex(this, index);
			}
		}
		
		/**
		 * Draws the transform tool over its target instance
		 */
		public function draw():void {
			// update the matrix and draw controls
			updateMatrix();
			dispatchEvent(new Event(TRANSFORM_TOOL));
		}
		
		/**
		 * Applies the current tool transformation to its target instance
		 */
		public function apply():void {
			if (_target) {
				
				// get matrix to apply to target
				var applyMatrix:Matrix = _toolMatrix.clone();
				applyMatrix.concat(transform.concatenatedMatrix);
				
				// if target has a parent, counter parent transformations
				if (_target.parent) {
					var invertMatrix:Matrix = target.parent.transform.concatenatedMatrix;
					invertMatrix.invert();
					applyMatrix.concat(invertMatrix);
				}
				
				// set target's matrix
				_target.transform.matrix = applyMatrix;
				
				dispatchEvent(new Event(TRANSFORM_TARGET));
			}
		}
	}
}