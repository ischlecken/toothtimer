//
//  Created by Feldmaus on 19.12.12.
//  Copyright (c) 2012 Feldmaus. All rights reserved.
//

#ifndef APPERROR_H
#define APPERROR_H

#define kErrorListAdded @"errorListAdded"

extern NSString *const appErrorDomain;
extern NSString *const appErrorCoreDomain;

extern NSArray* gErrorList;

@interface ErrorDescription : NSObject
@property(nonatomic,strong) NSString* msg;
@property(nonatomic,strong) NSError*  error;
@property(nonatomic,strong) NSDate*   timestamp;

-(NSString*) errorMessage;
@end

typedef enum
{ tkrErrorUnknown             = -1,
  tkrErrorUnknownVaultVersion = -8,
  tkrErrorSAXFailed           = -9,
  tkrErrorEnvelopeMissing     = -10,
  tkrErrorMissingIV           = -11,
  tkrErrorDecryptedData       = -12,
  tkrErrorWrongPassword       = -13,
  tkrErrorLastError           = -99
} tkrErrorType;

NSError*     createError0GUI(int errCode,NSString* description,int internalErrCode);
NSError*     createError1GUI(int errCode,NSString* description,NSError* underlyingError);
void         addToErrorList(NSString* msg,NSError* error);
#endif
/*=======================================END-OF-FILE===============================================*/
