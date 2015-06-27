//
//  Created by Stefan Thomas on 15.01.2015.
//  Copyright (c) 2015 LSSi Europe. All rights reserved.
//
#import "SectionInfo.h"

@implementation SectionInfo

/**
 *
 */
+(SectionInfo*) sectionWithTitle:(NSString*)title andItems:(NSArray*)items
{ SectionInfo* result = [[SectionInfo alloc] init];
  
  result.title = title;
  result.items = items;

  return result;
}

@end

@implementation MutableSectionInfo
@dynamic items;

/**
 *
 */
+(MutableSectionInfo*) mutableSectionWithTitle:(NSString*)title andItems:(NSArray*)items
{ MutableSectionInfo* result = [[MutableSectionInfo alloc] init];
  
  result.title = title;
  result.items = [[NSMutableArray alloc] initWithArray:items];
  
  return result;
}

/**
 *
 */
+(MutableSectionInfo*) mutableSectionWithTitle:(NSString*)title
{ MutableSectionInfo* result = [[MutableSectionInfo alloc] init];
  
  result.title = title;
  result.items = [[NSMutableArray alloc] initWithCapacity:13];
  
  return result;
}

@end

@implementation SectionItem

/**
 *
 */
+(SectionItem*) sectionItemWithIndex:(int)index
{ SectionItem* result = [[SectionItem alloc] init];
  
  result.index          = index;
  result.height         = 44.0f;
  result.cellIdentifier = @"Cell";
  
  return result;
}

/**
 *
 */
+(SectionItem*) sectionItemWithIndex:(int)index andHeight:(CGFloat)height
{ SectionItem* result = [[SectionItem alloc] init];
  
  result.index          = index;
  result.height         = height;
  result.cellIdentifier = @"Cell";
  
  return result;
}

/**
 *
 */
+(SectionItem*) sectionItemWithIndex:(int)index andHeight:(CGFloat)height andCellIdentifier:(NSString*)cellIdentifier
{ SectionItem* result = [[SectionItem alloc] init];
  
  result.index          = index;
  result.height         = height;
  result.cellIdentifier = cellIdentifier;
  
  return result;
}

/**
 *
 */
+(SectionItem*) sectionItemWithIndex:(int)index andHeight:(CGFloat)height andCellIdentifier:(NSString*)cellIdentifier andSectionItemContext:(id)sectionItemContext
{ SectionItem* result = [[SectionItem alloc] init];
  
  result.index              = index;
  result.height             = height;
  result.cellIdentifier     = cellIdentifier;
  result.sectionItemContext = sectionItemContext;
  
  return result;
}

/**
 *
 */
+(SectionItem*) sectionItemWithName:(NSString*)itemName
{ SectionItem* result = [[SectionItem alloc] init];
  
  result.itemName       = itemName;
  result.height         = 44.0f;
  result.cellIdentifier = @"Cell";
  
  return result;
}

/**
 *
 */
+(SectionItem*) sectionItemWithName:(NSString*)itemName andHeight:(CGFloat)height
{ SectionItem* result = [[SectionItem alloc] init];
  
  result.itemName       = itemName;
  result.height         = height;
  result.cellIdentifier = @"Cell";
  
  return result;
}

/**
 *
 */
+(SectionItem*) sectionItemWithName:(NSString*)itemName andHeight:(CGFloat)height andCellIdentifier:(NSString*)cellIdentifier
{ SectionItem* result = [[SectionItem alloc] init];
  
  result.itemName       = itemName;
  result.height         = height;
  result.cellIdentifier = cellIdentifier;
  
  return result;
}

/**
 *
 */
+(SectionItem*) sectionItemWithName:(NSString*)itemName andHeight:(CGFloat)height andCellIdentifier:(NSString*)cellIdentifier andSectionItemContext:(id)sectionItemContext
{ SectionItem* result = [[SectionItem alloc] init];
  
  result.itemName       = itemName;
  result.height             = height;
  result.cellIdentifier     = cellIdentifier;
  result.sectionItemContext = sectionItemContext;
  
  return result;
}


@end