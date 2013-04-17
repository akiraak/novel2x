#include <dirent.h>
#import "BookUtil.h"

static void asyncWriteCallBack(CFWriteStreamRef stream,
							   CFStreamEventType eventType,
							   void *clientCallBackInfo);

namespace BookUtil {
	//--------------------------------
	ms::Sint32 getPageCountWithBookPath(NSString* bookPath){
		ms::Sint32 pageCount = -1;
		DIR *dp;
		struct dirent *dir;
		NSLog(@"%@", bookPath);
		const char* dirPath= [bookPath UTF8String];
		NSLog(@"%s", dirPath);
		if((dp=opendir(dirPath)) != NULL){
			pageCount = 0;
			while((dir = readdir(dp)) != NULL){
				if(dir->d_type == DT_REG){
					NSString* fileExt = [[NSString stringWithUTF8String:dir->d_name] pathExtension];
					if([fileExt caseInsensitiveCompare:@"jpg"] == NSOrderedSame ||
                       [fileExt caseInsensitiveCompare:@"jpeg"] == NSOrderedSame ||
					   [fileExt caseInsensitiveCompare:@"png"] == NSOrderedSame)
					{
						pageCount++;
					}
				}
			}
			closedir(dp);
		}
		return pageCount;
	}
	//--------------------------------
	ms::Sint32 getPageCountWithBookName(NSString* bookName){
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsPath = [paths objectAtIndex:0];
		NSString *dirPathString = [NSString stringWithFormat:@"%@/Books/%@", documentsPath, bookName];
		return getPageCountWithBookPath(dirPathString);
	}
	//--------------------------------
	NSString* getFilePathWithIndex(NSString* bookPath, int index){
		NSString* filePath = NULL;
		ms::Sint32 pageCount = 0;
		DIR *dp;
		struct dirent *dir;
		const char* dirPath= [bookPath UTF8String];
		if((dp=opendir(dirPath)) != NULL){
			while((dir = readdir(dp)) != NULL){
				if(dir->d_type == DT_REG){
					int nameLen = strlen(dir->d_name);
					if(nameLen >= 5 &&
					   (strcmp((char*)&dir->d_name[nameLen-4], ".png") == 0 ||
						strcmp((char*)&dir->d_name[nameLen-4], ".jpg") == 0))
					{
						if(pageCount == index){
							filePath = [NSString stringWithUTF8String:dir->d_name];
							break;
						}
						pageCount++;
					}
				}
			}
			closedir(dp);
		}
		return filePath;
	}
	//--------------------------------
	BOOL existBook(NSString* bookName){
		BOOL exist = FALSE;
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsPath = [paths objectAtIndex:0];
		NSString *dirPathString = [NSString stringWithFormat:@"%@/Books/%@", documentsPath, bookName];
		const char* dirPath= [dirPathString UTF8String];
		DIR *dp;
		if((dp=opendir(dirPath)) != NULL){
			exist = TRUE;
			closedir(dp);
		}
		return exist;
	}
	//--------------------------------
	void remove(NSString* bookName){
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsPath = [paths objectAtIndex:0];
		NSString *dirPathString = [NSString stringWithFormat:@"%@/Books/%@", documentsPath, bookName];
		NSError* error = NULL;
		[[NSFileManager defaultManager] removeItemAtPath:dirPathString error:&error];
	}
	//--------------------------------
	BOOL resizeTextureFile(UIImage* srcImage, UIImage** dstImage, NSString* filePath, BOOL save, char* dstBuffReplaceFilePath){
		CGSize orgSize = [srcImage size];
		ms::Uint32 textureMaxSize = ms::GLTexture::getTextureMaxSize();
		if(orgSize.width > textureMaxSize ||
		   orgSize.height > textureMaxSize)
		{
			float scaleRate;
			if(orgSize.width > orgSize.height){
				scaleRate = textureMaxSize / orgSize.width;
			}else{
				scaleRate = textureMaxSize / orgSize.height;
			}
			if(scaleRate < 1.0f){
				size_t w = orgSize.width * scaleRate;
				size_t h = orgSize.height * scaleRate;
				UIGraphicsBeginImageContext(CGSizeMake(w, h));
				[srcImage drawInRect:CGRectMake(0, 0, w, h)];
				srcImage = UIGraphicsGetImageFromCurrentImageContext();  
				UIGraphicsEndImageContext(); 				
				
				if(save){
					NSData* saveData=UIImageJPEGRepresentation(srcImage, 0.8);
					//				NSData* saveData = UIImagePNGRepresentation(srcImage);  
					NSString* replaceFilePath = [filePath stringByDeletingPathExtension];
					replaceFilePath = [NSString stringWithFormat:@"%@.jpg", replaceFilePath];
					//				replaceFilePath = [NSString stringWithFormat:@"%@.png", replaceFilePath];
					ASSERT(saveData);
					BOOL result=[[NSFileManager defaultManager] createFileAtPath:replaceFilePath contents:saveData attributes:nil];
					if(!result){
						ASSERT(FALSE);
					}
					// 既存ファイルの削除
					if(![filePath isEqualToString:replaceFilePath]){
						NSError* error = NULL;
						[[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
					}
					
					if(dstBuffReplaceFilePath){
						strcpy(dstBuffReplaceFilePath, [replaceFilePath UTF8String]);
					}
				}
			}
			if(dstImage){
				*dstImage = srcImage;
			}
			return TRUE;
		}
		return FALSE;
	}
};
