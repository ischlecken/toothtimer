#import "NSString+Date.h"

@implementation NSString(Date)


/**
 *
 */
+(NSString*) stringISODate
{ return [NSString stringISODateForDate:[NSDate date]]; }

/**
 *
 */
+(NSString*) stringISOTimestamp
{ return [NSString stringISOTimestampForDate:[NSDate date]]; }

/**
 *
 */
+(NSString*) stringISODateForDate:(NSDate*)date;
{ static NSDateFormatter* sformatter = nil;
  
  if( sformatter==nil )
  { sformatter = [[NSDateFormatter alloc] init];
    
    [sformatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [sformatter setDateFormat:@"yyyy'-'MM'-'dd"];
    [sformatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
  } /* of if */
  
  return [sformatter stringFromDate:date];
}

/**
 *
 */
+(NSString*) stringISOTimestampForDate:(NSDate*)date;
{ static NSDateFormatter* sformatter = nil;
  
  if( sformatter==nil )
  { sformatter = [[NSDateFormatter alloc] init];
    
    [sformatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [sformatter setDateFormat:@"yyyy'-'MM'-'dd' 'HH':'mm':'ss"];
    [sformatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
  } /* of if */
  
  return [sformatter stringFromDate:date];
}


/**
 *
 */
+(NSDate*) isoTimestampValue:(NSString*)ts
{ static NSDateFormatter* sformatter = nil;
  
  if( sformatter==nil )
  { sformatter = [[NSDateFormatter alloc] init];
    
    [sformatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [sformatter setDateFormat:@"yyyy'-'MM'-'dd' 'HH':'mm':'ss"];
    [sformatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
  } /* of if */
  
  NSDate* result = [sformatter dateFromString:ts];
  
  return result;
}


/**
 *
 */
+(NSDate*) timestampValue:(NSString*)ts
{ static NSDateFormatter* sformatter = nil;
  
  if( sformatter==nil )
  { sformatter = [[NSDateFormatter alloc] init];
    
    [sformatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [sformatter setDateFormat:@"yyyy'-'MM'-'dd' 'HH':'mm':'ss"];
    [sformatter setTimeZone:[NSTimeZone localTimeZone]];
  } /* of if */
  
  NSDate* result = [sformatter dateFromString:ts];
  
  return result;
}

@end
/*=================================================END-OF-FILE============================================================================*/
