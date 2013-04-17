#import "MS.h"

namespace BookUtil {
	ms::Sint32 getPageCountWithBookPath(NSString* bookPath);
	ms::Sint32 getPageCountWithBookName(NSString* bookName);
	NSString* getFilePathWithIndex(NSString* bookPath, int index);
	BOOL existBook(NSString* bookName);
	void remove(NSString* bookName);
	BOOL resizeTextureFile(UIImage* srcImage, UIImage** dstImage, NSString* filePath, BOOL save, char* dstBuffReplaceFilePath);
};
