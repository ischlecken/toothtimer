#import "SectionInfo.h"

@interface NSArray(SectionInfo)
-(SectionInfo*) findSectionInfo:(NSString*)title;
-(NSUInteger)   findSectionInfoIndex:(NSString*)title;
-(NSIndexPath*) findFirstSettingItemWithCellId:(NSString*)cellId;

@end
