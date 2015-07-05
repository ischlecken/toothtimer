#import <UIKit/UIKit.h>

@class BooleanTableViewCell;

@protocol BooleanTableViewCellDelegate <NSObject>
-(void) optionFlipped:(BOOL)enabled forBooleanTableViewCell:(BooleanTableViewCell*)tableViewCell andContext:(id)context;
@end

@interface BooleanTableViewCell : UITableViewCell
@property (weak  , nonatomic) IBOutlet UILabel*  label;
@property (weak  , nonatomic) IBOutlet UISwitch* option;

@property (weak  , nonatomic)          id<BooleanTableViewCellDelegate> delegate;
@property (strong, nonatomic)          id                               context;
@end
