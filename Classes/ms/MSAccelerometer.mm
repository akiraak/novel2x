#import "MSAccelerometer.h"
#import "SceneDebugString.h"

namespace ms {
	//--------------------------------
	Accelerometer::Accelerometer():
	state((STATE)0),
	delegate(NULL),
	vec(ms::Vector3fMake(0.0f, 0.0f, 0.0f)),
	interval(1.0f),
	upDir((UP_DIR)0)
	{
	}
	//--------------------------------
	Accelerometer::~Accelerometer(){
		[delegate release];
	}
	//--------------------------------
	void Accelerometer::init(){
		{
			ASSERT(!delegate);
			delegate = [[AccelerometerDelegate alloc] init:this interval:interval];
			ASSERT(delegate);
		}
	}
	//--------------------------------
	void Accelerometer::touchesBegan(const Vector2f* touchPos, Uint32 touchCount, NSSet* touches, UIEvent* event){
		if(state == STATE_ENABLE){
#ifdef DEBUG_CHANGE_UP_DIR
			if(touchPos->x < 48.0f &&
			   touchPos->y > (ms::GLScene::SCREEN_SIZE_H/2.0f-24.0f) &&
			   touchPos->y < (ms::GLScene::SCREEN_SIZE_H/2.0f+24.0f))
			{
				UP_DIR next[]={
					UP_DIR_LEFT,
					UP_DIR_DOWN,
					UP_DIR_RIGHT,
					UP_DIR_UP,
				};
				upDir = next[upDir];
				NOTIFY_INFO info;
				memset(&info, 0, sizeof(info));
				info.upDir = upDir;
				sendChildNotifyMessage(NOTIFY_DIR_CHANGE, &info);
			}
#endif
		}
	}
	//--------------------------------
	void Accelerometer::onAccelerometer(const ms::Vector3f& _vec){
		if(state == STATE_ENABLE){
			vec = _vec;
			
			// 本体の向きを検出
			{
				UP_DIR nowUpDir = (UP_DIR)0;
				ms::Vector2f vecAbs = ms::Vector2fMake(ABS(_vec.x), ABS(_vec.y)) ;
				if(_vec.y < 0){
					// 上
					if(vecAbs.y > vecAbs.x){
						nowUpDir = UP_DIR_UP;
					}else if(_vec.x > 0){
						nowUpDir = UP_DIR_LEFT;
					}else{
						nowUpDir = UP_DIR_RIGHT;
					}
				}else{
					// 下
					if(vecAbs.y > vecAbs.x){
						nowUpDir = UP_DIR_DOWN;
					}else if(_vec.x > 0){
						nowUpDir = UP_DIR_LEFT;
					}else{
						nowUpDir = UP_DIR_RIGHT;
					}
				}
				if(upDir != nowUpDir){
					upDir = nowUpDir;
					
					NOTIFY_INFO info;
					memset(&info, 0, sizeof(info));
					info.upDir = upDir;
					sendChildNotifyMessage(NOTIFY_DIR_CHANGE, &info);
				}
			}
		}
	}
	//--------------------------------
	void Accelerometer::start(){
		state = STATE_ENABLE;
	}
	//--------------------------------
	float Accelerometer::getRadZ(){
		return PI-atan2f(vec.x, vec.y);
	}
}

//--------------------------------
@implementation AccelerometerDelegate

//--------------------------------
-(id)init:(ms::Accelerometer*) _parent interval:(float)_interval{
	if(self = [super init]){
		ASSERT(!accelerometer);
		accelerometer = [UIAccelerometer sharedAccelerometer];
		accelerometer.updateInterval = _interval;
		accelerometer.delegate = self;
		
		parent = _parent;
	}
	return self;
}
//--------------------------------
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration{
	ASSERT(parent);
	parent->onAccelerometer(ms::Vector3fMake(acceleration.x, acceleration.y, acceleration.z));
}
//--------------------------------
- (void)dealloc{
	[accelerometer release];
	[super dealloc];
}
@end
