//
//  UserProfileViewController.m
//  Twitter
//
//  Created by Joanna Chan on 2/15/15.
//  Copyright (c) 2015 yahoo. All rights reserved.
//

#import "UserProfileViewController.h"
#import "UIImageView+AFNetworking.h"
#import "User.h"
#import "Tweet.h"
#import "TwitterClient.h"
#import "TweetCell.h"
#import "ComposeViewController.h"
#import "TweetViewController.h"
#import "AccountsViewController.h"

@interface UserProfileViewController () <UITableViewDataSource, UITableViewDelegate, ComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userId;
@property (weak, nonatomic) IBOutlet UILabel *tagline;

@property (weak, nonatomic) IBOutlet UILabel *nTweets;
@property (weak, nonatomic) IBOutlet UILabel *nFollowing;
@property (weak, nonatomic) IBOutlet UILabel *nFollower;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tweets;

@property (weak, nonatomic) IBOutlet UIView *userDetailView;
- (IBAction)onUserDetailSwipe:(UIPanGestureRecognizer *)sender;
@property (weak, nonatomic) IBOutlet UIView *userBadgeView;
@property (weak, nonatomic) IBOutlet UIView *descriptionView;
@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (nonatomic, assign) CGAffineTransform originBackground;

- (IBAction)onDragDown:(UIPanGestureRecognizer *)sender;

@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.backgroundImage setImageWithURL:[NSURL URLWithString:self.currentUser.profileBgImageUrl]];
    [self.userImage setImageWithURL:[NSURL URLWithString:self.currentUser.profileImageUrl]];
    
    self.userName.text = self.currentUser.name;
    self.userId.text = self.currentUser.screenname;
    self.tagline.text = self.currentUser.tagline;
    
    self.userBadgeView.translatesAutoresizingMaskIntoConstraints = YES;
    self.descriptionView.translatesAutoresizingMaskIntoConstraints = YES;
    CGRect dvframe = self.descriptionView.frame;
    dvframe.origin.x = 1000;
    self.descriptionView.frame = dvframe;
    
    
    self.nTweets.text = [NSString stringWithFormat:@"%@", self.currentUser.retweet_count ];
    
    self.nFollowing.text = [NSString stringWithFormat:@"%@", self.currentUser.friends_count];
    self.nFollower.text = [NSString stringWithFormat:@"%@", self.currentUser.followers_count];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.translucent = NO;
    
    self.title = self.currentUser.name;
    
    if(self.currentUser != [User currentUser]){
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(onCancel)];
        
    }else{
    
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(onLogout)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self action:@selector(onCompose)];
    
    }
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tweets = [NSMutableArray array];
    [self onRefresh];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onCancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onLogout {
    [User logout];
}

- (void) composeViewController:(ComposeViewController *) composeViewController didNewCompose:(Tweet *)tweet{
    [self onRefresh];
}

- (void)onCompose {
    
    ComposeViewController *vc = [[ComposeViewController alloc] init];
    
    vc.delegate = self;
    
    UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:vc];
    
    nvc.navigationBar.barTintColor = [UIColor colorWithRed:85.0f/255.0f green:172.0f/255.0f blue:238.0f/255.0f alpha:1.0f];
    nvc.navigationBar.tintColor = [UIColor whiteColor];
    [nvc.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [self presentViewController:nvc animated:YES completion:nil];
    
}

- (void)onRefresh {
    [[TwitterClient sharedInstance] homeTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
        [self.tweets removeAllObjects];
        [self.tweets addObjectsFromArray:tweets];
        [self.tableView reloadData];
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    cell.tweet = self.tweets[indexPath.row];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TweetViewController *vc = [[TweetViewController alloc] init];
    
    vc.tweet = self.tweets[indexPath.row];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (IBAction)onUserDetailSwipe:(UIPanGestureRecognizer *)sender {
    NSLog(@"scroll");
    CGPoint velocity = [sender velocityInView:self.view];
    
    if(sender.state == UIGestureRecognizerStateBegan){
        
    }else if(sender.state == UIGestureRecognizerStateChanged){
        
    }else if(sender.state == UIGestureRecognizerStateEnded){
        if(velocity.x < 0){
            self.pageControl.currentPage = 1;
            
            CGRect bgframe = self.userBadgeView.frame;
            bgframe.origin.x = -1000;
            self.userBadgeView.frame = bgframe;
            
            CGRect dvframe = self.descriptionView.frame;
            dvframe.origin.x = 0;
            
            [UIView animateWithDuration:0.3 animations:^{
                self.descriptionView.frame = dvframe;
                self.backgroundImage.alpha = 0.6;
            }];
            
        }else{
            self.pageControl.currentPage = 0;
            
            CGRect dvframe = self.descriptionView.frame;
            dvframe.origin.x = 1000;
            self.descriptionView.frame = dvframe;
            
            CGRect bgframe = self.userBadgeView.frame;
            bgframe.origin.x = 0;
            
            [UIView animateWithDuration:0.3 animations:^{
                self.userBadgeView.frame = bgframe;
                self.backgroundImage.alpha = 1;
            }];

        }
    }
    
}

- (IBAction)onDragDown:(UIPanGestureRecognizer *)sender {
    
    CGPoint translation = [sender translationInView:self.view];
    CGPoint velocity = [sender velocityInView:self.view];
    
    CGRect frame = self.mainView.frame;
    frame.origin.y = translation.y;
    self.mainView.frame = frame;
    
    
    if(sender.state == UIGestureRecognizerStateBegan){
        self.originBackground = self.backgroundImage.transform;
    }else if(sender.state == UIGestureRecognizerStateChanged){
        
        if(velocity.y > 0){
            self.backgroundImage.transform = CGAffineTransformScale(self.backgroundImage.transform, 1.005, 1.005);
        }
        
    }else if(sender.state == UIGestureRecognizerStateEnded){
        
        if(velocity.y > 200 && self.currentUser == [User currentUser]){
            
            CGRect finalframe = self.mainView.frame;
            finalframe.origin.y = 0;
            self.mainView.frame = finalframe;
            self.backgroundImage.transform = self.originBackground;
            
            AccountsViewController *vc = [[AccountsViewController alloc] init];
            
            [self presentViewController:vc animated:YES completion:nil];
            
        }else{
        
            CGRect finalframe = self.mainView.frame;
            finalframe.origin.y = 0;
            
            [UIView animateWithDuration:0.6 animations:^{
                self.mainView.frame = finalframe;
                self.backgroundImage.transform = self.originBackground;
            }];
        
        }
        
    }
    
}


/*
#p
ragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
