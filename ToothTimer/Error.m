//  Created by Feldmaus on 19.12.12.
//  Copyright (c) 2012 Feldmaus. All rights reserved.
//
#import "Error.h"

NSString *const appErrorDomain     = @"ttErrorDomain";
NSString *const appErrorCoreDomain = @"ttErrorCoreDomain";
NSArray*        gErrorList         = nil;

@implementation ErrorDescription

/**
 *
 */
-(NSString*) errorMessage
{ NSString* message =  nil;
  
  if( self.error.userInfo && self.error.userInfo[@"reason"] )
    message = self.error.userInfo[@"reason"];
  
  if( message==nil )
    message = [self.error localizedFailureReason];
  
  if( message==nil )
    message = [self.error localizedDescription];

  return message;
}
@end

/**
 *
 */
NSError* createError0GUI(int errCode,NSString* description,int internalErrCode)
{ NSError* underlyingError = nil;

  if( internalErrCode!=0 )
    underlyingError = [[NSError alloc] initWithDomain:appErrorCoreDomain code:internalErrCode userInfo:nil];

  return createError1GUI(errCode, description, underlyingError);
} /* of createtkrError0() */

/**
 *
 */
NSError* createError1GUI(int errCode,NSString* description,NSError* underlyingError)
{ NSString* localizedDescription = NSLocalizedStringFromTable(description,@"ttErrors",@"");

  NSArray* objArray        = nil;
  NSArray* keyArray        = nil;
  
  NSLog(@"createError1GUI(errCode=%d,description=%@,underlyingError=%@)",errCode,description,underlyingError);

  if( underlyingError!=nil )
  { objArray        = [NSArray      arrayWithObjects     :localizedDescription     ,underlyingError     ,nil];
    keyArray        = [NSArray      arrayWithObjects     :NSLocalizedDescriptionKey,NSUnderlyingErrorKey,nil];
  } /* of if */
  else
  { objArray        = [NSArray      arrayWithObjects     :localizedDescription     ,nil];
    keyArray        = [NSArray      arrayWithObjects     :NSLocalizedDescriptionKey,nil];
  } /* of if */

  NSDictionary* eDict = [NSDictionary dictionaryWithObjects:objArray forKeys:keyArray];

  return [[NSError alloc] initWithDomain:appErrorDomain code:errCode userInfo:eDict];
} /* of createError1GUI() */

/**
 *
 */
void addToErrorList(NSString* msg,NSError* error)
{ if( error!=nil )
  { NSLog(@"addToErrorList(msg=%@,error=%@)",msg,error);
  
    ErrorDescription* ed = [[ErrorDescription alloc] init];
    
    ed.error     = error;
    ed.timestamp = [NSDate date];
    ed.msg       = msg;
    
    @synchronized(ed)
    { if( gErrorList==nil )
        gErrorList = [[NSMutableArray alloc] initWithCapacity:128];
      
      [((NSMutableArray*)gErrorList) addObject:ed];
    }
    
    dispatch_async(dispatch_get_main_queue(),^
    { [[NSNotificationCenter defaultCenter] postNotificationName:kErrorListAdded object:ed];
    });
  } /* of if */
}
/*======================================END-OF-FILE====================================================================*/
