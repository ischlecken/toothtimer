
@interface SectionInfo : NSObject
@property(strong,nonatomic) NSString* title;
@property(strong,nonatomic) NSString* footerText;
@property(strong,nonatomic) NSString* imageURL;
@property(strong,nonatomic) NSArray*  items;

+(SectionInfo*) sectionWithTitle:(NSString*)title andItems:(NSArray*)items;
@end

@interface MutableSectionInfo : SectionInfo
@property(strong,nonatomic) NSMutableArray* items;

+(MutableSectionInfo*) mutableSectionWithTitle:(NSString*)title andItems:(NSArray*)items;
+(MutableSectionInfo*) mutableSectionWithTitle:(NSString*)title;
@end

@interface SectionItem : NSObject
@property(assign,nonatomic) int       index;
@property(strong,nonatomic) NSString* itemName;
@property(assign,nonatomic) CGFloat   height;
@property(strong,nonatomic) NSString* cellIdentifier;
@property(strong,nonatomic) id        sectionItemContext;

+(SectionItem*) sectionItemWithIndex:(int)index;
+(SectionItem*) sectionItemWithIndex:(int)index andHeight:(CGFloat)height;
+(SectionItem*) sectionItemWithIndex:(int)index andHeight:(CGFloat)height andCellIdentifier:(NSString*)cellIdentifier;
+(SectionItem*) sectionItemWithIndex:(int)index andHeight:(CGFloat)height andCellIdentifier:(NSString*)cellIdentifier andSectionItemContext:(id)sectionItemContext;

+(SectionItem*) sectionItemWithName:(NSString*)itemName;
+(SectionItem*) sectionItemWithName:(NSString*)itemName andHeight:(CGFloat)height;
+(SectionItem*) sectionItemWithName:(NSString*)itemName andHeight:(CGFloat)height andCellIdentifier:(NSString*)cellIdentifier;
+(SectionItem*) sectionItemWithName:(NSString*)itemName andHeight:(CGFloat)height andCellIdentifier:(NSString*)cellIdentifier andSectionItemContext:(id)sectionItemContext;
@end
