#import <MessageUI/MFMailComposeViewController.h>

#import "SettingsViewController.h"
#import "BooleanTableViewCell.h"
#import "TextfieldTableViewCell.h"
#import "PickerTableViewCell.h"
#import "SettingsItem.h"
#import "SectionInfo.h"
#import "NSArray+SectionInfo.h"
#import "AppConfig.h"
#import "AppUtil.h"
#import "ToothTimer-swift.h"

#define kSectionTitleTimer        @"timer"
#define kSectionTitleNotification @"notification"
#define kSectionTitleAbout        @"about"
#define kSectionTitleGUI          @"gui"


@interface SettingsViewController () <MFMailComposeViewControllerDelegate,
                                      TextfieldTableViewCellDelegate,
                                      BooleanTableViewCellDelegate,
                                      UITableViewDelegate,UITableViewDataSource,
                                      UIPickerViewDataSource,UIPickerViewDelegate>

@property(nonatomic, strong)          NSArray*         sections;
@property(nonatomic, strong)          NSIndexPath*     pickerIndexPath;
@property(nonatomic, strong)          NSArray*         configParameter;
@property(nonatomic, weak  ) IBOutlet UITableView*     tableView;
@property(nonatomic, copy  )          SelectActionType pickerSelectAction;
@end

@implementation SettingsViewController

/**
 *
 */
-(void) viewDidLoad
{ [super viewDidLoad];

  [self.tableView registerNib:[UINib nibWithNibName:@"TextfieldTableViewCell" bundle:nil] forCellReuseIdentifier:@"TextfieldCell"];
  [self.tableView registerNib:[UINib nibWithNibName:@"BooleanTableViewCell"   bundle:nil] forCellReuseIdentifier:@"BooleanCell"];
  [self.tableView registerNib:[UINib nibWithNibName:@"PickerTableViewCell"    bundle:nil] forCellReuseIdentifier:@"PickerCell"];

  self.tableView.rowHeight = UITableViewAutomaticDimension;
  self.tableView.estimatedRowHeight = 56.0f;

  NSMutableArray* sectionInfo   = [[NSMutableArray alloc] initWithCapacity:3];
  BOOL            useImperial   = NO;

  __weak __typeof(self)weakSelf = self;
  
  self.pickerSelectAction = ^(NSIndexPath* indexPath,SettingsItem* item)
  { [weakSelf.tableView beginUpdates];
    
    BOOL                addPicker = YES;
    NSIndexPath*        pip       = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
    MutableSectionInfo* msi       = weakSelf.sections[indexPath.section];
    SettingsItem*       si        = msi.items[indexPath.row];
    id                  rowValue  = [_APPCONFIG getConfigValue:si.title];
    
    if( pip.row<msi.items.count && [[msi.items[pip.row] cellId] isEqualToString:@"PickerCell"] )
      addPicker = NO;
    
    if( addPicker )
    { NSIndexPath* openPickerIndexPath = [weakSelf.sections findFirstSettingItemWithCellId:@"PickerCell"];
      
      //_NSLOG(@"openPickerIndexPath:%@",openPickerIndexPath);
      
      SettingsItem* pickerSetting = [SettingsItem settingItemWithTitle:si.title andCellId:@"PickerCell" andSelectAction:NULL andPickerValues:si.pickerValues];
      
      for( NSInteger i=0;i<si.pickerValues.count;i++ )
      { id v = si.pickerValues[i];
        
        if( [v isEqual:rowValue] )
        { pickerSetting.selectedPickerValue = i;
          
          break;
        } /* of if */
      } /* of for */
      
      if( openPickerIndexPath )
      { NSMutableArray* openPickerItems = (NSMutableArray*)[weakSelf.sections[openPickerIndexPath.section] items];
        
        if( openPickerIndexPath.section!=pip.section || openPickerIndexPath.row>pip.row )
        { [openPickerItems removeObjectAtIndex:openPickerIndexPath.row];
          [weakSelf.tableView deleteRowsAtIndexPaths:@[openPickerIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
          
          [msi.items insertObject:pickerSetting atIndex:pip.row];
          [weakSelf.tableView insertRowsAtIndexPaths:@[pip] withRowAnimation:UITableViewRowAnimationFade];
        } /* of if */
        else
        { [openPickerItems removeObjectAtIndex:openPickerIndexPath.row];
          [weakSelf.tableView deleteRowsAtIndexPaths:@[openPickerIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
          
          [msi.items insertObject:pickerSetting atIndex:pip.row-1];
          [weakSelf.tableView insertRowsAtIndexPaths:@[pip] withRowAnimation:UITableViewRowAnimationFade];
        } /* of else */
      } /* of if */
      else
      { [msi.items insertObject:pickerSetting atIndex:pip.row];
        [weakSelf.tableView insertRowsAtIndexPaths:@[pip] withRowAnimation:UITableViewRowAnimationFade];
      } /* of else */
    } /* of if */
    else
    { [msi.items removeObjectAtIndex:pip.row];
      
      [weakSelf.tableView deleteRowsAtIndexPaths:@[pip] withRowAnimation:UITableViewRowAnimationFade];
    } /* of else */
    
    [weakSelf.tableView endUpdates];
  };
  
  NSArray* timerSectionItems =
  @[ [SettingsItem settingItemWithTitle:@"timerInSeconds"
                              andCellId:@"DetailCell"
                        andSelectAction:self.pickerSelectAction
                        andPickerValues:@[@60,@120,@180,@240,@300,@360,@420,@480,@540,@600]],
     
     [SettingsItem settingItemWithTitle:@"noOfSlices"
                              andCellId:@"DetailCell"
                        andSelectAction:self.pickerSelectAction
                        andPickerValues:@[@1,@2,@3,@4,@4,@5,@6]],
     
  ];
  [sectionInfo addObject:[MutableSectionInfo sectionWithTitle:kSectionTitleTimer andItems:[[NSMutableArray alloc] initWithArray:timerSectionItems]]];
  
  NSMutableArray* notificationSectionItems = [[NSMutableArray alloc] initWithArray:
                                             @[ [SettingsItem settingItemWithTitle:@"notificationEnabled" andCellId:@"BooleanCell"] ]];
  
  if( _APPCONFIG.notificationEnabled )
    [notificationSectionItems addObjectsFromArray:
    @[
     [SettingsItem settingItemWithTitle:useImperial ? @"notificationRadiusInYard" : @"notificationRadiusInMeter"
                              andCellId:@"DetailCell"
                        andSelectAction:self.pickerSelectAction
                        andPickerValues:useImperial ? @[@50,@100,@200,@500,@1000,@1760,@3520,@8800,@17600] : @[@50,@100,@200,@500,@1000,@2000,@5000,@10000]],

     [SettingsItem settingItemWithTitle:@"notificationDurationInMinutes"
                              andCellId:@"DetailCell"
                        andSelectAction:self.pickerSelectAction
                        andPickerValues:@[@10,@30,@60,@120]],
  
  ]];
  
  [sectionInfo addObject:[MutableSectionInfo sectionWithTitle:kSectionTitleNotification andItems:[[NSMutableArray alloc] initWithArray:notificationSectionItems]]];

  NSArray* guiSectionItems =
  @[
    [SettingsItem settingItemWithTitle:@"colorSchemeName"
                             andCellId:@"DetailCell"
                       andSelectAction:self.pickerSelectAction
                       andPickerValues:[UIColor colorSchemeNames]],
   ];
  [sectionInfo addObject:[MutableSectionInfo sectionWithTitle:kSectionTitleGUI andItems:[[NSMutableArray alloc] initWithArray:guiSectionItems]]];

  NSArray* aboutSectionItems =
  @[
     [SettingsItem settingItemWithTitle:@"contact"
                              andCellId:@"BasicCell"
                        andSelectAction:^(NSIndexPath* indexPath,SettingsItem *item)
      { if( [MFMailComposeViewController canSendMail] )
        { MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
          
          NSString* subject = _LSTR(@"contact.subject");
          NSString* message = _LSTR(@"contact.message");
          
          controller.mailComposeDelegate = self;
          [controller setToRecipients:@[[Constant kContactEMail]]];
          [controller setSubject:[NSString stringWithFormat:subject,[Constant appName]]];
          [controller setMessageBody:[NSString stringWithFormat:message,[Constant appName]] isHTML:NO];
          
          [self presentViewController:controller animated:YES completion:NULL];
          
        }
        else
          _NSLOG(@"can not send email");
        
        
      }],
     
     [SettingsItem settingItemWithTitle:@"rate"
                              andCellId:@"BasicCell"
                        andSelectAction:^(NSIndexPath* indexPath,SettingsItem *item)
      {
      }],
     
     [SettingsItem settingItemWithTitle:@"about"
                              andCellId:@"BasicCell"
                        andSelectAction:^(NSIndexPath* indexPath,SettingsItem *item)
      { [[AppUtil class] performSelector:@selector(aboutDialogue) withObject:nil afterDelay:1.0];
      }],
  ];
  [sectionInfo addObject:[MutableSectionInfo sectionWithTitle:kSectionTitleAbout andItems:[[NSMutableArray alloc] initWithArray:aboutSectionItems]]];
  
  self.sections = sectionInfo;
  
  self.configParameter = @[@"serviceNames"];
  
  for( NSString* configKeyPath in self.configParameter )
    [[AppConfig sharedInstance] addObserver:self
                                      forKeyPath:configKeyPath
                                         options:NSKeyValueObservingOptionNew
                                         context:NULL];
  
  self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithName:@"titleColor"]};
}

/**
 *
 */
-(void) viewDidDisappear:(BOOL)animated
{ [super viewDidDisappear:animated];
  
  [self closePickerCells];
}

/**
 *
 */
-(NSArray*) loadServiceNames
{ NSMutableArray* serviceNames = [[NSMutableArray alloc] initWithCapacity:3];
  [serviceNames addObject:@"bla"];
  [serviceNames addObject:@"fasel"];
  [serviceNames addObject:@"label"];
  
  return serviceNames;
}

/**
 *
 */
-(void) closePickerCells
{ NSIndexPath* openPickerIndexPath = [self.sections findFirstSettingItemWithCellId:@"PickerCell"];
  
  if( openPickerIndexPath )
  { NSMutableArray* openPickerItems = (NSMutableArray*)[self.sections[openPickerIndexPath.section] items];
    
    [self.tableView beginUpdates];
    [openPickerItems removeObjectAtIndex:openPickerIndexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[openPickerIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
  } /* of if */
}


/**
 *
 */
-(void) dealloc
{ for( NSString* configKeyPath in self.configParameter )
    [[AppConfig sharedInstance] removeObserver:self forKeyPath:configKeyPath];
}


#pragma mark Datamodel

/**
 *
 */
-(id) valueForConfig:(NSString*)title
{ id result = nil;
  
  if( [_APPCONFIG configValueExists:title] )
    result = [_APPCONFIG getConfigValue:title];
  
  return result;
}

/**
 *
 */
-(NSString*) stringValueForConfig:(NSString*)title
{ NSString* result = nil;
  
  if( [_APPCONFIG configValueExists:title] )
    result = [_APPCONFIG getConfigValue:title];
  
  return result;
}

/**
 *
 */
-(void) updateStringValue:(NSString*)value forConfig:(NSString*)title
{ if( [_APPCONFIG configValueExists:title] )
    [_APPCONFIG setConfigValue:value forKey:title];
  
}


/**
 *
 */
-(BOOL) boolValueForConfig:(NSString*)title
{ BOOL result = NO;
  
  if( [_APPCONFIG configValueExists:title] )
  { NSNumber* value = [_APPCONFIG getConfigValue:title];
    
    result = [value boolValue];
  } /* of if */
  
  return result;
}

/**
 *
 */
-(void) updateBoolValue:(BOOL)value forConfig:(NSString*)title
{ if( [_APPCONFIG configValueExists:title] )
    [_APPCONFIG setConfigValue:[NSNumber numberWithBool:value] forKey:title];
  
  if( [title isEqualToString:@"notificationEnabled"] )
  { SectionInfo* si = [self.sections findSectionInfo:kSectionTitleNotification];
    
    if( value )
    {
      if( si.items.count==1 )
      { MutableSectionInfo* msi         = (MutableSectionInfo*)si;
        BOOL                useImperial = NO;

        [msi.items addObjectsFromArray:
        @[
          [SettingsItem settingItemWithTitle:useImperial ? @"notificationRadiusInYard" : @"notificationRadiusInMeter"
                                   andCellId:@"DetailCell"
                             andSelectAction:self.pickerSelectAction
                             andPickerValues:useImperial ? @[@50,@100,@200,@500,@1000,@1760,@3520,@8800,@17600] : @[@50,@100,@200,@500,@1000,@2000,@5000,@10000]],
          
          [SettingsItem settingItemWithTitle:@"notificationDurationInMinutes"
                                   andCellId:@"DetailCell"
                             andSelectAction:self.pickerSelectAction
                             andPickerValues:@[@10,@30,@60,@120]],
          
          ]];
      } /* of if */
    } /* of if */
    else
    {
      if( si.items.count==3 )
      { MutableSectionInfo* msi = (MutableSectionInfo*)si;
        
        [msi.items removeLastObject];
        [msi.items removeLastObject];
      } /* of if */
    } /* of else */
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
  } /* of if */
}


#pragma mark - Table view data source delegate

/**
 *
 */
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{ return self.sections.count; }

/**
 *
 */
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{ NSString* result = nil;
  NSString* title  = [self.sections[section] title];
  
  if( title!=nil && title.length>0 )
  { NSString* key = [NSString stringWithFormat:@"settings.sectiontitle.%@",title];
    
    result = [[NSBundle mainBundle] localizedStringForKey:key value:@"" table:nil];
  } /* of if */
  
  return result;
}

/**
 *
 */
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{ SectionInfo* sectionInfo = self.sections[section];
  
  return sectionInfo.items.count;
}

/**
 *
 */
-(void) tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{ UITableViewHeaderFooterView* header = (UITableViewHeaderFooterView*)view;

  header.textLabel.textColor=[UIColor whiteColor];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{ UITableViewCell* cell          = nil;
  SectionInfo*     si            = self.sections[indexPath.section];
  NSInteger        dataRow       = indexPath.row;
  SettingsItem*    setting       = si.items[dataRow];
  NSString*        key           = [NSString stringWithFormat:@"settings.title.%@",setting.title];
  NSString*        cellId        = setting.cellId;
  NSString*        displayOption = [[NSBundle mainBundle] localizedStringForKey:key value:@"" table:nil];
  
  displayOption = [NSString stringWithFormat:displayOption,[Constant appName]];
  
  cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
  
  if( [cell isKindOfClass:[BooleanTableViewCell class]] )
  { BooleanTableViewCell* bcell = (BooleanTableViewCell*)cell;
    
    bcell.label.text      = displayOption;
    bcell.label.textColor = [UIColor whiteColor];
    bcell.option.on       = [self boolValueForConfig:setting.title];
    bcell.context         = setting;
    bcell.delegate        = self;
  } /* of if */
  else if( [cell isKindOfClass:[TextfieldTableViewCell class]] )
  { TextfieldTableViewCell* tbcell = (TextfieldTableViewCell*)cell;
    
    tbcell.titleLabel.text         = displayOption;
    tbcell.inputField.text         = [self stringValueForConfig:setting.title];
    tbcell.inputField.keyboardType = setting.keyboardType;
    tbcell.context                 = setting;
    tbcell.delegate                = self;
  } /* of if */
  else if( [cell isKindOfClass:[PickerTableViewCell class]] )
  { PickerTableViewCell* pcell = (PickerTableViewCell*)cell;
    
    pcell.pickerView.delegate = self;
    
    dispatch_async(dispatch_get_main_queue(), ^
    { [pcell.pickerView reloadAllComponents];
      
      [pcell.pickerView selectRow:setting.selectedPickerValue inComponent:0 animated:NO];
    });
    
  } /* of if */
  else
  { cell.textLabel.text       = displayOption;
    cell.detailTextLabel.text = setting.pickerValues ? [self pickerDisplayValueForSetting:setting andValue:[self valueForConfig:setting.title]] :
                                                       [[self valueForConfig:setting.title] description];
  } /* of else */
  
  cell.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3];
  
  return cell;
}



#pragma mark TableView delegate

/**
 *
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{ [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  SectionInfo*     si            = self.sections[indexPath.section];
  SettingsItem*    setting       = si.items[indexPath.row];
  
  if( setting.selectAction )
    setting.selectAction(indexPath,setting);
  
  if( setting.pickerValues )
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}


#pragma mark TextfieldTableViewCellDelegate

/**
 *
 */
-(void) inputFieldChanged:(NSString*)text forTextfieldTableViewCell:(TextfieldTableViewCell*)tableViewCell andContext:(id)context
{  }


#pragma mark BooleanTableViewCellDelegate
/**
 *
 */
-(void) optionFlipped:(BOOL)enabled forBooleanTableViewCell:(BooleanTableViewCell*)tableViewCell andContext:(id)context
{ SettingsItem* si = (SettingsItem*)context;
  
  [self updateBoolValue:enabled forConfig:si.title];
}


#pragma mark UIPickerViewDataSource

/**
 *
 */
-(NSIndexPath*) indexPathForView:(UIView*)v
{ NSIndexPath* result = nil;
  
  while( v!=nil && ![v isKindOfClass:[UITableViewCell class]] )
    v = v.superview;
  
  if( v!=nil )
    result = [self.tableView indexPathForCell:(UITableViewCell*)v];
  
  return result;
}

/**
 *
 */
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{ return 1; }


/**
 *
 */
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{ NSIndexPath* indexPath = [self indexPathForView:pickerView];
  NSInteger    result    = 0;
  
  if( indexPath!=nil )
  { SettingsItem* si = [self.sections[indexPath.section] items][indexPath.row];
    
    result = si.pickerValues.count;
  } /* of if */
  
  return result;
}


#pragma mark UIPickerViewDelegate

/**
 *
 */
-(NSString*) pickerDisplayValueForSetting:(SettingsItem*)si andValue:(id)rowValue
{ NSString* key    = [NSString stringWithFormat:@"settings.picker.%@.%@",si.title,rowValue];
  NSString* value  = [rowValue description];
  NSString* result = [[NSBundle mainBundle] localizedStringForKey:key value:value table:nil];

  //_NSLOG(@"si.title:%@ key:%@ value:%@ result:%@",si.title,key,value,result);
  
  return result;
}


/**
 *
 */
-(UIView*) pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{ if( view==nil )
    view = [[UILabel alloc] init];
  
  UILabel*     labelView = (UILabel*)view;
  NSIndexPath* indexPath = [self indexPathForView:pickerView];
  
  if( indexPath!=nil )
  { SettingsItem* si       = [self.sections[indexPath.section] items][indexPath.row];
    id            rowValue = si.pickerValues[row];
    
    labelView.text            = [self pickerDisplayValueForSetting:si andValue:rowValue];
    labelView.textColor       = [UIColor whiteColor];
    labelView.textAlignment   = NSTextAlignmentCenter;
    labelView.font            = [UIFont boldSystemFontOfSize:24];
  } /* of if */
  
  return view;
}


/**
 *
 */
-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{ NSIndexPath* indexPath = [self indexPathForView:pickerView];
  
  if( indexPath!=nil )
  { SettingsItem* si       = [self.sections[indexPath.section] items][indexPath.row];
    id            rowValue = si.pickerValues[row];
    
    [_APPCONFIG setConfigValue:rowValue forKey:si.title];
    
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section]]
                          withRowAnimation:UITableViewRowAnimationBottom];
  } /* of if */
}

#pragma mark MFMailComposeViewControllerDelegate

/**
 *
 */
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error;
{ if( result==MFMailComposeResultSent )
  { _NSLOG(@"It's away!");
  } /* of if */
  
  [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Navigation

/**
 *
 */
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{ if( [[segue identifier] isEqualToString:@"ShowHelpSegue"] )
  { 
  } /* of if */
}

#pragma mark Notifications

/**
 *
 */
-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{ _NSLOG(@"keyPath=%@",keyPath);
  
  if( [keyPath isEqualToString:@"serviceNames"] )
  {
  } /* of if */
}
@end
