#import "TextfieldBooleanTableViewCell.h"
#import "ToothTimer-swift.h"

@interface TextfieldBooleanTableViewCell ()<UITextFieldDelegate>

@end

@implementation TextfieldBooleanTableViewCell

/**
 *
 */
-(void) awakeFromNib
{ [super awakeFromNib];
  
  self.optionSwitch.onTintColor = [UIColor colorWithName:@"tintColor"];
}

/**
 *
 */
-(IBAction) flipOption:(UISwitch*)sender
{ if( !sender.on )
  { [self.delegate inputFieldChanged:self.inputField.text forTextfieldBooleanTableViewCell:self andContext:self.context];
    [self.inputField resignFirstResponder];
  } /* of if */
  
  [self enableUI:sender.on];
  
  if( sender.on )
    [self.inputField becomeFirstResponder];
  
  [self.delegate optionFlipped:sender.on forTextfieldBooleanTableViewCell:self andContext:self.context];
}

/**
 *
 */
-(void) setEnabled:(BOOL)enabled
{ self.optionSwitch.on    = enabled;
  
  [self enableUI:enabled];
}


/**
 *
 */
-(void) enableUI:(BOOL)enabled
{ //self.inputField.enabled = enabled;
  
  if( enabled )
  { self.inputField.textColor = [UIColor colorWithName:@"tintColor"];
  } /* of if */
  else
  { self.inputField.textColor = [UIColor colorWithName:@"disabledColor"];
  } /* of else */
}


#pragma mark UITextFieldDelegate

/**
 *
 */
-(void) textFieldDidEndEditing:(UITextField *)textField
{ _NSLOG_SELECTOR;
  
  [self.delegate inputFieldChanged:textField.text forTextfieldBooleanTableViewCell:self andContext:self.context];
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
