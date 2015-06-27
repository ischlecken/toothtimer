//
//  Created by Stefan Thomas on 15.01.2015.
//  Copyright (c) 2015 LSSi Europe. All rights reserved.
//

@interface NSString(Date)
+(NSString*) stringISODate;
+(NSString*) stringISOTimestamp;

+(NSString*) stringISODateForDate:(NSDate*)date;
+(NSString*) stringISOTimestampForDate:(NSDate*)date;


+(NSDate*)   timestampValue:(NSString*)ts;
+(NSDate*)   isoTimestampValue:(NSString*)ts;
@end
/*===============================================END-OF-FILE=================================================*/
