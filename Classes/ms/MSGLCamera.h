namespace ms {
	class GLCamera : public Object {
	public:
		GLCamera();
		virtual ~GLCamera();
		virtual void init();
		void setScene(GLScene* _scene){scene = _scene;}
		void cleanPos();
		void setScreenSize(const ms::Vector2f& inScreenSize);
		void cleanScreenSize();
		BOOL update(ms::Uint32 elapsedTime);
		void touchesBegan(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event);
		void touchesMoved(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event);
		void touchesEnded(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event);
		void touchesCancelled(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event);
		void setMoveRect(const ms::Rect& rc);
		void setTouchRect(const ms::Rect& rc);
		void enableMove();
		const ms::Matrixf* getMatrix(){return &matCamera;}
		void setMatrix(const ms::Matrixf& mat){matCamera = mat;}
		void startZoom();
		void startZoomTargetPos(Vector2f& pos);
		void setPos(Vector2f& pos);
		ms::Vector2f getPos();
		float getRotZ(){return rotAnimNowZ;}
		enum UP_DIR {
			UP_DIR_UP = 0,
			UP_DIR_DOWN,
			UP_DIR_LEFT,
			UP_DIR_RIGHT,
			
			UP_DIR_COUNT,
		};
		enum NOTIFY{
			NOTIFY_TOUCH,
			NOTIFY_CHANGE_UP_DIR,
		};
		struct NOTIFY_TOUCH_INFO {
			ms::Vector2f	pos;
			BOOL			zoomMax;
		};
		struct NOTIFY_CHANGE_UP_DIR_INFO {
			UP_DIR upDir;
		};
		BOOL setUpDir(UP_DIR _upDir);
		
		enum CONTROL_FLAG {
			CONTROL_FLAG_MOVE_V = 1,
			CONTROL_FLAG_MOVE_H,
			CONTROL_FLAG_TOUCH_ZOOM,
			CONTROL_FLAG_PINCH_ZOOM,
			
			CONTROL_FLAG_COUNT,
		};
		void enableAllControlFlag(){controlFlagBit=0xFFFFFFFF;}
		void enableControlFlag(CONTROL_FLAG _controlFlag);
		void disableControlFlag(CONTROL_FLAG _controlFlag);
		BOOL getControlFlag(CONTROL_FLAG _controlFlag){
			ASSERT(_controlFlag >= 0 && _controlFlag < CONTROL_FLAG_COUNT);
			return controlFlagBit & (1<<_controlFlag);
		};
	private:
		enum STATE {
			STATE_INIT = 0,
			STATE_DISABLE,
			STATE_IDLE,
			STATE_MOVE,
			STATE_ZOOM_INIT,
			STATE_ZOOM,
			STATE_ZOOM_TARGET_INIT,
			STATE_ZOOM_TARGET,
			STATE_ZOOM_MULTITOUCH_INIT,
			STATE_ZOOM_MULTITOUCH,
			STATE_THROW,
			STATE_CHANGE_UP_DIR_INIT,
			STATE_CHANGE_UP_DIR,
		};
		STATE			state;
		ms::Uint32		controlFlagBit;
		GLScene*		scene;
		ms::Uint32		timer;
		ms::Matrixf		matCamera;
		ms::Uint32		touchStartTime;
		ms::Vector2n	touchStartPos;
		ms::Vector2n	touchNowPos;
		ms::Vector2n	touchGapPos;
		ms::Vector2f	throwSpeed;
		ms::Vector2f	stopSpeed;
		BOOL			cameraUpdate;
		BOOL			moveLimit;
		ms::Rect		moveRect;
		ms::Rect		touchRect;
		enum{
			ZOOM_LEVEL_COUNT = 3,
		};
		static float	zoomLevelValueDefault[ZOOM_LEVEL_COUNT];
		float			zoomLevelValue[ZOOM_LEVEL_COUNT];
		ms::Sint32		zoomLevel;
		ms::Vector3f	zoomStart;
		ms::Vector3f	zoomEnd;
		ms::Vector3f	zoomTargetPos;
		struct MultiTouchInfo {
			UITouch*		touch;
			ms::Vector2f	pos;
		};
		MultiTouchInfo	multiTouchInfo[2];
		float			multiTouchZoomFirstLen;
		float			multiTouchZoomFirstZ;
		UP_DIR			upDir;
		float			rotAnimStartZ;
		float			rotAnimEndZ;
		float			rotAnimNowZ;
		ms::Matrixf		rotAnimStartMat;
		
		void updateZoomLevel();
	};
}