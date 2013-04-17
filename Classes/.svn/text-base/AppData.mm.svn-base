#import "AppData.h"

#ifdef DEBUG
//#define DATA_CLEAR
#endif

//--------------------------------
AppData* AppData::instance = NULL;

//--------------------------------
AppData::AppData():
defaults(NULL)
{
	ASSERT(!instance);
	instance = this;
}
//--------------------------------
AppData::~AppData(){
	[defaults synchronize];
	[defaults release];	
	ASSERT(instance);
	instance = NULL;
}
//--------------------------------
void AppData::init(){
	{
		ASSERT(!defaults);
		defaults = [NSUserDefaults standardUserDefaults];
		ASSERT(defaults);
	}
	// 初期値を設定
	{
		NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
									 @"0",		kUserDefaultsExecCount,
									 @"0",		kUserDefaultsLastScene,
									 @"",		kUserDefaultsLastBook,
									 DOWNLOAD_URL_DEFAULT, kUserDefaultsDownloadURL,
									 ADD_WEB_URL_DEFAULT, kUserDefaultsAddWebURL,
									 nil];
		[defaults registerDefaults:dict];
	}
#ifdef DATA_CLEAR
	{
		removeData();
	}
#endif
	// データの取得
	{
		execCount		= [defaults integerForKey:kUserDefaultsExecCount];
	}
#ifndef DATA_CLEAR
	// 起動回数のカウント
	{
		int count = getExecCountValue();
		setExecCountValue(count+1);
	}
/*
	for(int i = 0; i < Picture::PICTURE_COUNT; i++){
		setMyHeartCountValue(i, i);
		setWorldHeartCountValue(i, 980+i);
	}
*/
#endif
}
//--------------------------------
void AppData::removeData(){
	[defaults removeObjectForKey:kUserDefaultsExecCount];
	[defaults removeObjectForKey:kUserDefaultsLastScene];
	[defaults removeObjectForKey:kUserDefaultsLastBook];
	[defaults removeObjectForKey:kUserDefaultsDownloadURL];
	[defaults removeObjectForKey:kUserDefaultsAddWebURL];
	[defaults synchronize];
}
//--------------------------------
void AppData::setExecCountValue(int value){
	ASSERT(instance);
	instance->execCount = value;
	[instance->defaults setInteger:value forKey:kUserDefaultsExecCount];
	[instance->defaults synchronize];
}
//--------------------------------
void AppData::setLastScene(SCENE scene){
	ASSERT(instance);
	[instance->defaults setInteger:scene forKey:kUserDefaultsLastScene];
	[instance->defaults synchronize];
}
//--------------------------------
int AppData::getLastScene(){
	return [instance->defaults integerForKey:kUserDefaultsLastScene];
}
//--------------------------------
void AppData::setLastBook(NSString* bookName){
	ASSERT(instance);
	[instance->defaults setObject:bookName forKey:kUserDefaultsLastBook];
	[instance->defaults synchronize];
}
//--------------------------------
NSString* AppData::getLastBook(){
	return [instance->defaults stringForKey:kUserDefaultsLastBook];
}
//--------------------------------
void AppData::setDownloadURL(NSString* url){
	ASSERT(instance);
	[instance->defaults setObject:url forKey:kUserDefaultsDownloadURL];
	[instance->defaults synchronize];
}
//--------------------------------
NSString* AppData::getDownloadURL(){
	ASSERT(instance);
	return [instance->defaults stringForKey:kUserDefaultsDownloadURL];
}
//--------------------------------
void AppData::setAddWebURL(NSString* url){
	ASSERT(instance);
	[instance->defaults setObject:url forKey:kUserDefaultsAddWebURL];
	[instance->defaults synchronize];
}
//--------------------------------
NSString* AppData::getAddWebURL(){
	ASSERT(instance);
	return [instance->defaults stringForKey:kUserDefaultsAddWebURL];
}
//--------------------------------
void AppData::setupBook(NSString* bookTitle){
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								 @"0.05",	[NSString stringWithFormat:@"%@%@", kUserDefaultsBookAreaLeftHead, bookTitle],
								 @"0.05",	[NSString stringWithFormat:@"%@%@", kUserDefaultsBookAreaTopHead, bookTitle],
								 @"0.9",	[NSString stringWithFormat:@"%@%@", kUserDefaultsBookAreaWidthHead, bookTitle],
								 @"0.9",	[NSString stringWithFormat:@"%@%@", kUserDefaultsBookAreaHeightHead, bookTitle],
								 @"0",		[NSString stringWithFormat:@"%@%@", kUserDefaultsBookPageCountHead, bookTitle],
								 @"0",		[NSString stringWithFormat:@"%@%@", kUserDefaultsBookPageIndexHead, bookTitle],
								 @"0",		[NSString stringWithFormat:@"%@%@", kUserDefaultsBookViewerModeHead, bookTitle],
								 @"10000",	[NSString stringWithFormat:@"%@%@", kUserDefaultsBookPosXHead, bookTitle],
								 @"",		[NSString stringWithFormat:@"%@%@", kUserDefaultsBookAmazonCode, bookTitle],
								 @"",		[NSString stringWithFormat:@"%@%@", kUserDefaultsBookAmazonTinyURL, bookTitle],
								 @"",		[NSString stringWithFormat:@"%@%@", kUserDefaultsBookNotePageNo, bookTitle],
								 @"",		[NSString stringWithFormat:@"%@%@", kUserDefaultsBookNoteIcon, bookTitle],
								 @"",		[NSString stringWithFormat:@"%@%@", kUserDefaultsBookNoteText, bookTitle],
								 nil];
	[instance->defaults registerDefaults:dict];
}
//--------------------------------
void AppData::setBookAreaLeft(NSString* bookTitle, float value){
	NSString* key = [NSString stringWithFormat:@"%@%@", kUserDefaultsBookAreaLeftHead, bookTitle];
	[instance->defaults setFloat:value forKey:key];
	[instance->defaults synchronize];
}
//--------------------------------
float AppData::getBookAreaLeft(NSString* bookTitle){
	NSString* key = [NSString stringWithFormat:@"%@%@", kUserDefaultsBookAreaLeftHead, bookTitle];
	return [instance->defaults floatForKey:key];
}
//--------------------------------
void AppData::setBookAreaTop(NSString* bookTitle, float value){
	NSString* key = [NSString stringWithFormat:@"%@%@", kUserDefaultsBookAreaTopHead, bookTitle];
	[instance->defaults setFloat:value forKey:key];
	[instance->defaults synchronize];
}
//--------------------------------
float AppData::getBookAreaTop(NSString* bookTitle){
	NSString* key = [NSString stringWithFormat:@"%@%@", kUserDefaultsBookAreaTopHead, bookTitle];
	return [instance->defaults floatForKey:key];
}
//--------------------------------
void AppData::setBookAreaWidth(NSString* bookTitle, float value){
	NSString* key = [NSString stringWithFormat:@"%@%@", kUserDefaultsBookAreaWidthHead, bookTitle];
	[instance->defaults setFloat:value forKey:key];
	[instance->defaults synchronize];
}
//--------------------------------
float AppData::getBookAreaWidth(NSString* bookTitle){
	NSString* key = [NSString stringWithFormat:@"%@%@", kUserDefaultsBookAreaWidthHead, bookTitle];
	return [instance->defaults floatForKey:key];
}
//--------------------------------
void AppData::setBookAreaHeight(NSString* bookTitle, float value){
	NSString* key = [NSString stringWithFormat:@"%@%@", kUserDefaultsBookAreaHeightHead, bookTitle];
	[instance->defaults setFloat:value forKey:key];
	[instance->defaults synchronize];
}
//--------------------------------
float AppData::getBookAreaHeight(NSString* bookTitle){
	NSString* key = [NSString stringWithFormat:@"%@%@", kUserDefaultsBookAreaHeightHead, bookTitle];
	return [instance->defaults floatForKey:key];
}
//--------------------------------
void AppData::setBookPageCount(NSString* bookTitle, int value){
	NSString* key = [NSString stringWithFormat:@"%@%@", kUserDefaultsBookPageCountHead, bookTitle];
	[instance->defaults setInteger:value forKey:key];
	[instance->defaults synchronize];
}
//--------------------------------
int AppData::getBookPageCount(NSString* bookTitle){
	NSString* key = [NSString stringWithFormat:@"%@%@", kUserDefaultsBookPageCountHead, bookTitle];
	return [instance->defaults integerForKey:key];
}
//--------------------------------
void AppData::setBookPageIndex(NSString* bookTitle, int value){
	NSString* key = [NSString stringWithFormat:@"%@%@", kUserDefaultsBookPageIndexHead, bookTitle];
	[instance->defaults setInteger:value forKey:key];
	[instance->defaults synchronize];
}
//--------------------------------
int AppData::getBookPageIndex(NSString* bookTitle){
	NSString* key = [NSString stringWithFormat:@"%@%@", kUserDefaultsBookPageIndexHead, bookTitle];
	return [instance->defaults integerForKey:key];
}
//--------------------------------
void AppData::setBookViewerMode(NSString* bookTitle, VIEWER_MODE _mode){
	if(_mode < (VIEWER_MODE)0 ||
	   _mode >= VIEWER_MODE_COUNT)
	{
		_mode = (VIEWER_MODE)0;
	}
	NSString* key = [NSString stringWithFormat:@"%@%@", kUserDefaultsBookViewerModeHead, bookTitle];
	[instance->defaults setInteger:_mode forKey:key];
	[instance->defaults synchronize];
}
//--------------------------------
VIEWER_MODE AppData::getBookViewerMode(NSString* bookTitle){
	NSString* key = [NSString stringWithFormat:@"%@%@", kUserDefaultsBookViewerModeHead, bookTitle];
	VIEWER_MODE mode = (VIEWER_MODE)[instance->defaults integerForKey:key];
	if(mode < (VIEWER_MODE)0 ||
	   mode >= VIEWER_MODE_COUNT)
	{
		mode = (VIEWER_MODE)0;
		setBookViewerMode(bookTitle, mode);
	}
	return mode;
}
//--------------------------------
void AppData::setBookPosX(NSString* bookTitle, float value){
	NSString* key = [NSString stringWithFormat:@"%@%@", kUserDefaultsBookPosXHead, bookTitle];
	[instance->defaults setFloat:value forKey:key];
	[instance->defaults synchronize];
}
//--------------------------------
float AppData::getBookPosX(NSString* bookTitle){
	NSString* key = [NSString stringWithFormat:@"%@%@", kUserDefaultsBookPosXHead, bookTitle];
	return [instance->defaults floatForKey:key];
}
//--------------------------------
void AppData::setBookAmazonCode(NSString* bookTitle, NSString* value){
	NSString* key = [NSString stringWithFormat:@"%@%@", kUserDefaultsBookAmazonCode, bookTitle];
	[instance->defaults setObject:value forKey:key];
	[instance->defaults synchronize];
}
//--------------------------------
NSString* AppData::getBookAmazonCode(NSString* bookTitle){
	NSString* key = [NSString stringWithFormat:@"%@%@", kUserDefaultsBookAmazonCode, bookTitle];
	return [instance->defaults stringForKey:key];
}
//--------------------------------
void AppData::setBookAmazonTinyURL(NSString* bookTitle, NSString* value){
	NSString* key = [NSString stringWithFormat:@"%@%@", kUserDefaultsBookAmazonTinyURL, bookTitle];
	[instance->defaults setObject:value forKey:key];
	[instance->defaults synchronize];
}
//--------------------------------
NSString* AppData::getBookAmazonTinyURL(NSString* bookTitle){
	NSString* key = [NSString stringWithFormat:@"%@%@", kUserDefaultsBookAmazonTinyURL, bookTitle];
	return [instance->defaults stringForKey:key];
}
/*
//--------------------------------
void AppData::setBookNote(NSString* bookTitle, NSArray* value){
	NSString* key = [NSString stringWithFormat:@"%@%@", kUserDefaultsBookNote, bookTitle];
	[instance->defaults setObject:value forKey:key];
	[instance->defaults synchronize];
}
//--------------------------------
NSArray* AppData::getBookNote(NSString* bookTitle){
	NSString* key = [NSString stringWithFormat:@"%@%@", kUserDefaultsBookNote, bookTitle];
	return [instance->defaults arrayForKey:key];
}
*/
//--------------------------------
void AppData::setBookNote(NSString* bookTitle, NSArray* pageNo, NSArray* icon, NSArray* text){
	NSString* key = [NSString stringWithFormat:@"%@%@", kUserDefaultsBookNotePageNo, bookTitle];
	[instance->defaults setObject:pageNo forKey:key];

	key = [NSString stringWithFormat:@"%@%@", kUserDefaultsBookNoteIcon, bookTitle];
	[instance->defaults setObject:icon forKey:key];

	key = [NSString stringWithFormat:@"%@%@", kUserDefaultsBookNoteText, bookTitle];
	[instance->defaults setObject:text forKey:key];

	[instance->defaults synchronize];
}
//--------------------------------
NSArray* AppData::getBookNotePageNo(NSString* bookTitle){	
	NSString* key = [NSString stringWithFormat:@"%@%@", kUserDefaultsBookNotePageNo, bookTitle];
	return [instance->defaults arrayForKey:key];
}
//--------------------------------
NSArray* AppData::getBookNoteIcon(NSString* bookTitle){
	NSString* key = [NSString stringWithFormat:@"%@%@", kUserDefaultsBookNoteIcon, bookTitle];
	return [instance->defaults arrayForKey:key];
}
//--------------------------------
NSArray* AppData::getBookNoteText(NSString* bookTitle){
	NSString* key = [NSString stringWithFormat:@"%@%@", kUserDefaultsBookNoteText, bookTitle];
	return [instance->defaults arrayForKey:key];
}





















