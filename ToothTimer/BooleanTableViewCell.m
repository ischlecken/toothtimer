#import "BooleanTableViewCell.h"
#import "ToothTimer-swift.h"

@implementation BooleanTableViewCell


/**
 *
 */
-(void) awakeFromNib
{ [super awakeFromNib];
  
  self.option.onTintColor = [UIColor colorWithName:@"optionOnColor"];
}

/**
 *
 */
-(IBAction) flipOption:(UISwitch*)sender
{
  [self.delegate optionFlipped:sender.on forBooleanTableViewCell:self andContext:self.context];
}
@end
