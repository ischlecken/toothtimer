#import "TextfieldTableViewCell.h"

@interface TextfieldTableViewCell ()<UITextFieldDelegate>

@end

@implementation TextfieldTableViewCell


#pragma mark UITextFieldDelegate

/**
 *
 */
-(void) textFieldDidEndEditing:(UITextField *)textField
{ _NSLOG_SELECTOR;
  
  [self.delegate inputFieldChanged:textField.text forTextfieldTableViewCell:self andContext:self.context];
}

/**
 *
 */
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{ _NSLOG_SELECTOR;
  
  [textField resignFirstResponder];
  
  return YES;
}
@end
