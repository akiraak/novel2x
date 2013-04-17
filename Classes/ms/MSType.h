namespace ms {
	typedef unsigned char	Uint8;
	typedef char			Sint8;
	typedef unsigned short	Uint16;
	typedef short			Sint16;
	typedef unsigned int	Uint32;
	typedef int				Sint32;

	//--------------------------------
	struct UV {
		float u0;
		float v0;
		float u1;
		float v1;
	};
	inline UV UVMake(float _u0, float _v0, float _u1, float _v1){
		UV uv;
		uv.u0 = _u0;
		uv.v0 = _v0;
		uv.u1 = _u1;
		uv.v1 = _v1;
		return uv;
	}
	//--------------------------------
	struct Vector2f {
		float x;
		float y;
	};
	inline Vector2f Vector2fMake(float _x, float _y){
		Vector2f vec;
		vec.x = _x;
		vec.y = _y;
		return vec;
	}
	//--------------------------------
	struct Vector2n {
		Sint32 x;
		Sint32 y;
	};
	inline Vector2n Vector2nMake(Sint32 _x, Sint32 _y){
		Vector2n vec;
		vec.x = _x;
		vec.y = _y;
		return vec;
	}
	//--------------------------------
	struct Vector3f {
		float x;
		float y;
		float z;
	};
	inline Vector3f Vector3fMake(float _x, float _y, float _z){
		Vector3f vec;
		vec.x = _x;
		vec.y = _y;
		vec.z = _z;
		return vec;
	}
	//--------------------------------
	struct Color4f {
		float r;
		float g;
		float b;
		float a;
	};
	inline Color4f Color4fMake(float _r, float _g, float _b, float _a){
		Color4f color;
		color.r = _r;
		color.g = _g;
		color.b = _b;
		color.a = _a;
		return color;
	}
	//--------------------------------
	struct Matrixf {
		float m[4][4];
	};
	//--------------------------------
	struct Matrix33f {
		float m[3][3];
	};
	//--------------------------------
	struct Rect {
		Vector2f	pos;
		Vector2f	size;
	};
	inline Rect RectMake(float x, float y, float w, float h){
		Rect rc;
		rc.pos.x = x;
		rc.pos.y = y;
		rc.size.x = w;
		rc.size.y = h;
		return rc;
	}
	inline BOOL RectHit(const Rect& rect, const Vector2f& pos){
		if(pos.x >= rect.pos.x &&
		   pos.x < rect.pos.x+rect.size.x &&
		   pos.y >= rect.pos.y &&
		   pos.y < rect.pos.y+rect.size.y)
		{
			return TRUE;
		}
		return FALSE;
	}
};

#define MS_SAFE_DELETE(a)	{if(a){delete a; a = NULL;}}
#define MS_SAFE_FREE(a)		{if(a){free(a); a = NULL;}}
#define MS_ABS(a)			((a)<0?-a:a)

#ifndef ARRAYSIZE
#define ARRAYSIZE(_a)	((int)sizeof(_a) / ((int)sizeof((_a)[0])))
#endif

#ifndef MS_FIELDOFFSET
#define MS_FIELDOFFSET(_type,_field) ((ms::Sint32)&(((_type*)0)->_field))
#endif

#ifndef MS_BYTEOFFSET
#define MS_BYTEOFFSET(_p,_n) ((void*)((ms::Uint8*)(_p)+(_n)))
#endif

#ifndef ASSERT
#ifdef DEBUG
	#define ASSERT assert
#else
#define ASSERT(x)
#endif
#endif

#ifndef NSLOG
#ifdef DEBUG
#define NSLOG NSLog
#else
#define NSLOG(x...)
#endif
#endif

#define CLAMP(val, min, max)	{if(val < min)val = min;if(val > max)val = max;}

#ifndef IS_IPAD
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#endif
