#import "BEBHomeViewController.h"
#import "BEBMyStoriesViewController.h"
#import "BEBAppDelegate.h"
#import "BEBDataManager.h"

@interface BEBHomeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *pregnancyImageView;
@property (weak, nonatomic) IBOutlet UILabel *pregnancyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *newbornImageView;
@property (weak, nonatomic) IBOutlet UILabel *newbornLabel;

@end

@implementation BEBHomeViewController

- (void)viewDidLoad;
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.pregnancyLabel.layer.cornerRadius = CGRectGetHeight(self.pregnancyLabel.frame)/2;
    self.newbornLabel.layer.cornerRadius = CGRectGetHeight(self.newbornLabel.frame)/2;
    self.pregnancyLabel.clipsToBounds = YES;
    self.newbornLabel.clipsToBounds = YES;
    
    [self.pregnancyImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(tapPregnancy)]];
    [self.pregnancyLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(tapPregnancy)]];
    
    [self.newbornImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(tapNewborn)]];
    [self.newbornLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(tapNewborn)]];

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:@(YES) forKey:kSkipShowTutorial];
}

- (void)viewWillAppear:(BOOL)animated;
{
    [super viewWillAppear:animated];
    
    // Update local story number from app delegate
    BEBAppDelegate *appDelegate = (BEBAppDelegate *)[UIApplication sharedApplication].delegate;
    if (appDelegate.localNotification) {
        
        NSArray *stories = [BEBDataManager sharedManager].stories;
        NSNumber *storyId = appDelegate.localNotification.userInfo[kStoryIdKey];
        for (NSInteger index = 0; index < stories.count; index++) {
            BEBStory *story = stories[index];
            if (story.storyId == [storyId integerValue]) {
                BEBMyStoriesViewController *myStoriesVC = [self.storyboard instantiateViewControllerWithIdentifier:kMyStoriesViewControllerIdentifier];
                if ([story isPregnancy]) {
                    myStoriesVC.pregnancyStories = YES;
                }
                else {
                    myStoriesVC.pregnancyStories = NO;
                }
                [self.navigationController pushViewController:myStoriesVC animated:NO];
                break;
            }
        }
    }
}


- (void)didReceiveMemoryWarning;
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tapPregnancy;
{
    BEBMyStoriesViewController *myStoriesVC = [self.storyboard instantiateViewControllerWithIdentifier:kMyStoriesViewControllerIdentifier];
    myStoriesVC.pregnancyStories = YES;
    
    [self.navigationController pushViewController:myStoriesVC animated:YES];
}

- (void)tapNewborn;
{
    BEBMyStoriesViewController *myStoriesVC = [self.storyboard instantiateViewControllerWithIdentifier:kMyStoriesViewControllerIdentifier];
    myStoriesVC.pregnancyStories = NO;
    
    [self.navigationController pushViewController:myStoriesVC animated:YES];
}

@end
