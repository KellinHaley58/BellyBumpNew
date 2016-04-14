#import <MessageUI/MessageUI.h>
#import "BEBSettingsViewController.h"
#import "BEBSettingsCell.h"
#import "BEBDataManager.h"
#import "BEBSettings.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface BEBSettingsViewController () <BEBSettingsCellDelegate, MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation BEBSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getSocialUsername:)
                                                 name:kGetUserNameFacebookNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getSocialUsername:)
                                                 name:kGetUserNameTwitterNotification
                                               object:nil];
    
    if (!IS_IPHONE_4) {
        self.tableView.scrollEnabled = NO;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    BEBSettings *settings = [BEBDataManager sharedManager].settings;
    [settings getSocialUsernameFacebook];
    [settings getSocialUsernameTwitter];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//*****************************************************************************
#pragma mark -
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 3;
        case 1:
            return 1;
        case 2:
            return 2;
        default:
            return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BEBSettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingsCellIdentifier forIndexPath:indexPath];
    CGFloat scale = IS_IPHONE_5 ? 0.7f : IS_IPHONE_6 ? 0.77f : 0.8f;
    cell.settingsSwitch.transform = CGAffineTransformMakeScale(scale, scale);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.facebookImageView setHidden:YES];
    [cell.twitterImageView setHidden:YES];
    [cell.socialUsername setHidden:YES];
    [cell.settingsSwitch setHidden:NO];
    [cell.titleLabel setHidden:NO];
    cell.indexPath = indexPath;
    cell.delegate = self;
    
    BEBSettings *settings = [BEBDataManager sharedManager].settings;
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"daily";
            cell.containerView.backgroundColor = RGB(250, 218, 229, 1);
            cell.settingsSwitch.on = settings.reminderDaily;
        }
        else if (indexPath.row == 1) {
            cell.titleLabel.text = @"weekly";
            cell.containerView.backgroundColor = RGB(255, 245, 230, 1);
            cell.settingsSwitch.on = settings.reminderWeekly;
        }
        else {
            cell.titleLabel.text = @"bi-weekly";
            cell.containerView.backgroundColor = RGB(199, 224, 228, 1);
            cell.settingsSwitch.on = settings.reminderBiWeekly;
        }
    }
    else if (indexPath.section == 1) {
        cell.titleLabel.text = @"auto save";
        cell.containerView.backgroundColor = RGB(252, 220, 206, 1);
        cell.settingsSwitch.on = settings.autoSave;
    }
    else if (indexPath.section == 2) {
        
        [cell.socialUsername setHidden:NO];
        [cell.titleLabel setHidden:YES];
        [cell.settingsSwitch setHidden:YES];
        
        if (indexPath.row == 0) {
            [cell.facebookImageView setHidden:NO];
            cell.socialUsername.text = settings.usernameFacebook;
            cell.containerView.backgroundColor = RGB(150, 185, 212, 1);
        }
        else {
            [cell.twitterImageView setHidden:NO];
            if (![settings.usernameTwitter isEqualToString:@""]) {
                cell.socialUsername.text = [NSString stringWithFormat:@"@%@", settings.usernameTwitter];
            }
            else {
                cell.socialUsername.text = @"";
            }
            cell.containerView.backgroundColor = RGB(185, 212, 232, 1);
        }
    }
    else {
        [cell.settingsSwitch setHidden:YES];
        
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"have an idea?";
            cell.containerView.backgroundColor = RGB(199, 224, 228, 1);
        }
        else {
            cell.titleLabel.text = @"find a bug?";
            cell.containerView.backgroundColor = RGB(250, 218, 229, 1);
        }
    }
    
    return cell;
}

//*****************************************************************************
#pragma mark -
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (IS_IPHONE_5 ? 33.0f : IS_IPHONE_6 ? 36.0f : 38.0f);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSArray *heights = nil;
    if (IS_IPHONE_5) {
        heights = @[@24, @43, @43, @43];
    }
    else if (IS_IPHONE_6) {
        heights = @[@30, @52, @52, @52];
    }
    else {
        heights = @[@38, @60, @60, @60];
    }
    return [heights[section] floatValue];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *heights = nil;
    CGFloat labelX, labelH, fontSize;
    if (IS_IPHONE_5) {
        heights = @[@24, @43, @43, @43];
        labelX = 14.0f;
        labelH = 14.0f;
        fontSize = 11.0f;
    }
    else if (IS_IPHONE_6) {
        heights = @[@30, @52, @52, @52];
        labelX = 14.0f;
        labelH = 16.0f;
        fontSize = 11.0f;
    }
    else {
        heights = @[@38, @60, @60, @60];
        labelX = 15.0f;
        labelH = 18.0f;
        fontSize = 12.0f;
    }
    CGFloat rectHeight = [heights[section] floatValue];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, rectHeight)];
    view.backgroundColor = RGB(236, 239, 241, 1);
    
    NSArray *texts = @[@"REMINDERS", @"PHOTOS", @"LINKED ACCOUNTS", @"HELP US IMPROVE"];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelX, rectHeight - labelH, 150, labelH)];
    label.font = [UIFont fontWithName:@"OpenSans-Light" size:fontSize];
    label.backgroundColor = RGB(236, 239, 241, 1);
    label.textColor = RGB(139, 139, 138, 1);
    label.text = texts[section];
    
    [view addSubview:label];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 3 && [MFMailComposeViewController canSendMail]) {
        
        NSString *subject;
        if (indexPath.row == 0) {
            subject = @"Have an idea";
        }
        else {
            subject = @"Find a bug";
        }
        
        MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] init];
        composeViewController.mailComposeDelegate = self;
        
        [composeViewController setSubject:subject];
        [composeViewController setMessageBody:@"" isHTML:NO];
        [composeViewController setToRecipients:@[kReceiveFeedbackEmail]];
        
        [self presentViewController:composeViewController animated:YES completion:nil];
    }else if(indexPath.section == 2){
        if(indexPath.row == 0){ // facebook
            [self FacebookLogin:nil];
           
        }else{ // twitter
            
        }
        
    }
}

- (IBAction)FacebookLogin:(id)sender {
    BEBSettings *settings = [BEBDataManager sharedManager].settings;
    if([settings.usernameFacebook isEqualToString:@""]){
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        if([FBSDKAccessToken currentAccessToken])
        {
            [self fetchUserInfo];
        }else{
            [login logInWithReadPermissions:@[@"email"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                if(error)
                {
                    NSLog(@"Login process error");
                }else if(result.isCancelled){
                    NSLog(@"User cancelled login");
                }else{
                    NSLog(@"Login success");
                    if([result.grantedPermissions containsObject:@"email"])
                    {
                        [self fetchUserInfo];
                    }else{
                        //                    [SVProgressHUD showErrorWithStatus:@"Facebook email permission error"];
                    }
                }
            }];
        }

        
    }
}
-(void)fetchUserInfo{
    if([FBSDKAccessToken currentAccessToken])
    {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields":@"id, name, email"}] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            if(!error)
            {
                
                //
                //                NSDictionary *userinfo = [result objectForKey:@"user"];
                //                NSNumber *userid = [result objectForKey:@"id"];
                //                NSString *username = [userinfo objectForKey:@"username"];
                //                [Common saveValueKey:@"user_id" Value:username];
                //                NSString *useremail = [userinfo objectForKey:@"email"];
                //                [Common saveValueKey:@"user_email" Value:useremail];
                //                [SVProgressHUD dismiss];
                
                
                NSString *email = [result objectForKey:@"email"];
                NSString *userId = [result objectForKey: @"id"];
                if(email.length > 0){
                    BEBSettings *settings = [BEBDataManager sharedManager].settings;
                    settings.usernameFacebook = email;
                    [self.tableView reloadData];
                }else{
                    NSLog(@"Facebook email is not verified");
                }
            }else
            {
                NSLog(@"Error %@", error);
            }
        }];
    }
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** BEBSettingsCellDelegate **
- (void)bebSettingsCell:(BEBSettingsCell *)cell didTurnOn:(BOOL)on atIndexPath:(NSIndexPath *)indexPath
{
    BEBDataManager *dataManager = [BEBDataManager sharedManager];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [dataManager updateReminderDailySettingsOn:on];
        }
        else if (indexPath.row == 1) {
            [dataManager updateReminderWeeklySettingsOn:on];
        }
        else {
            [dataManager updateReminderBiWeeklySettingsOn:on];
        }
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [dataManager updateAutoSaveSettingsOn:on];
        }
    }
}

//*****************************************************************************
#pragma mark -
#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    if (error) {
        DEBUG_LOG(@"Error: %@", error.localizedDescription);
    }
    
    switch (result) {
        case MFMailComposeResultCancelled:
            DEBUG_LOG(@"Result: canceled");
            break;
        case MFMailComposeResultSaved:
            DEBUG_LOG(@"Result: saved");
            break;
        case MFMailComposeResultSent:
            DEBUG_LOG(@"Result: sent");
            break;
        case MFMailComposeResultFailed:
            DEBUG_LOG(@"Result: failed");
            break;
        default:
            DEBUG_LOG(@"Result: not sent");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** Notification get social username **
- (void)getSocialUsername:(NSNotification *)notif
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

@end
