#import <UIKit/UIKit.h>
#import "MS.h"

#define DEBUG_CHANGE_UP_DIR

@class AccelerometerDelegate;

namespace ms {
	class Accelerometer : public ms::Object {
	public:
		Accelerometer();
		virtual ~Accelerometer();	
		virtual void init();
		virtual void touchesBegan(const Vector2f* touchPos, Uint32 touchCount, NSSet* touches, UIEvent* event);
		virtual void onAccelerometer(const ms::Vector3f& _vec);
		virtual void start();
		void setInterval(float _interval){interval = _interval;}
		ms::Vector3f getVector(){return vec;}
		float getRadZ();
		enum UP_DIR {
			UP_DIR_NONE = -1,
			UP_DIR_UP = 0,
			UP_DIR_DOWN,
			UP_DIR_LEFT,
			UP_DIR_RIGHT,
			
			UP_DIR_COUNT,
		};
		UP_DIR getUpDir(){return upDir;}
		enum NOTIFY {
			NOTIFY_DIR_CHANGE,
		};
		struct NOTIFY_INFO {
			UP_DIR	upDir;
		};
	private:
		enum STATE {
			STATE_DISABLE = 0,
			STATE_ENABLE,
		};
		STATE					state;
		AccelerometerDelegate*	delegate;
		ms::Vector3f			vec;
		float					interval;
		UP_DIR					upDir;
	};
}

@interface AccelerometerDelegate : NSObject <UIAccelerometerDelegate> {
	UIAccelerometer*	accelerometer;
	ms::Accelerometer*	parent;
}
-(id)init:(ms::Accelerometer*) _parent interval:(float)_interval;
@end

