#import "MS.h"

namespace ms {
	Uint32 getTime(){
		struct timeval t;
		int r;
		r = gettimeofday(&t, NULL);
		ASSERT(r == 0);
		return (t.tv_sec * 1000) + (t.tv_usec / 1000);
	}
}
