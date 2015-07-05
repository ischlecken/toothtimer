#import <UIKit/UIKit.h>


@class TextfieldTableViewCell;

@protocol TextfieldTableViewCellDelegate <NSObject>
-(void) inputFieldChanged:(NSString*)text forTextfieldTableViewCell:(TextfieldTableViewCell*)tableViewCell andContext:(id)context;
@end


@interface TextfieldTableViewCell : UITableViewCell
@property (weak  , nonatomic) IBOutlet UILabel*     titleLabel;
@property (weak  , nonatomic) IBOutlet UITextField* inputField;

@property (weak  , nonatomic)          id<TextfieldTableViewCellDelegate> delegate;
@property (strong, nonatomic)          id                                 context;
@end
