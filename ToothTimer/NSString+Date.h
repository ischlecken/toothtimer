
@interface NSString(Date)
+(NSString*) stringISODate;
+(NSString*) stringISOTimestamp;

+(NSString*) stringISODateForDate:(NSDate*)date;
+(NSString*) stringISOTimestampForDate:(NSDate*)date;


+(NSDate*)   timestampValue:(NSString*)ts;
+(NSDate*)   isoTimestampValue:(NSString*)ts;
@end
/*===============================================END-OF-FILE=================================================*/
