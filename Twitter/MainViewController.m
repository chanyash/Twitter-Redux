//
//  MainViewController.m
//  Twitter
//
//  Created by Joanna Chan on 2/15/15.
//  Copyright (c) 2015 yahoo. All rights reserved.
//

#import "MainViewController.h"
#import "MenuViewController.h"
#import "TweetsViewController.h"
#import "UserProfileViewController.h"
#import "User.h"

@interface MainViewController () <MenuViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (nonatomic, strong) UINavigationController *mnvc;
@property (nonatomic, strong) UINavigationController *pnvc;
@property (nonatomic, strong) UINavigationController *tnvc;

@property (nonatomic, strong) UserProfileViewController *pvc;

@property (strong, nonatomic) UIViewController *currentVC;

- (IBAction)onPanGesture:(UIPanGestureRecognizer *)sender;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //Menu View
    MenuViewController *mvc = [[MenuViewController alloc] init];
    self.mnvc = [[UINavigationController alloc] initWithRootViewController:mvc];
    self.mnvc.navigationBar.barTintColor = [UIColor colorWithRed:85.0f/255.0f green:172.0f/255.0f blue:238.0f/255.0f alpha:1.0f];
    self.mnvc.navigationBar.tintColor = [UIColor whiteColor];
    [self.mnvc.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.mnvc.navigationBar.translucent = NO;
    
    [self addChildViewController:self.mnvc];
    [self.menuView addSubview: self.mnvc.view];
    mvc.delegate = self;
    
    // Profile View
    self.pvc = [[UserProfileViewController alloc] init];
    self.pnvc = [[UINavigationController alloc] initWithRootViewController:self.pvc];
    self.pnvc.navigationBar.barTintColor = [UIColor colorWithRed:85.0f/255.0f green:172.0f/255.0f blue:238.0f/255.0f alpha:1.0f];
    self.pnvc.navigationBar.tintColor = [UIColor whiteColor];
    [self.pnvc.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.pnvc.navigationBar.translucent = NO;
    
    // Tweets View
    TweetsViewController *tvc = [[TweetsViewController alloc] init];
    self.tnvc = [[UINavigationController alloc] initWithRootViewController:tvc];
    self.tnvc.navigationBar.barTintColor = [UIColor colorWithRed:85.0f/255.0f green:172.0f/255.0f blue:238.0f/255.0f alpha:1.0f];
    self.tnvc.navigationBar.tintColor = [UIColor whiteColor];
    [self.tnvc.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.tnvc.navigationBar.translucent = NO;
    
    self.currentVC = self.tnvc;
    self.currentVC.view.frame = self.contentView.bounds;
    [self addChildViewController:self.currentVC];
    [self.contentView addSubview:self.currentVC.view];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onPanGesture:(UIPanGestureRecognizer *)sender {
    
    CGPoint translation = [sender translationInView:self.view];
    CGPoint velocity = [sender velocityInView:self.view];
    
    CGRect frame = self.contentView.frame;
    
    if( (velocity.x > 0) || (frame.origin.x >= 0) ){
        
        if(frame.origin.x + translation.x > 0){
            frame.origin.x = translation.x;
        }else{
            frame.origin.x = 0;
        }
        
        self.contentView.frame = frame;
        
    }
    
    if(sender.state == UIGestureRecognizerStateBegan){
        
    }else if(sender.state == UIGestureRecognizerStateChanged){
        
    }else if(sender.state == UIGestureRecognizerStateEnded){
        if(velocity.x > 0){
            CGRect frame = self.contentView.frame;
            frame.origin.x = 300;
            
            [UIView animateWithDuration:0.6 animations:^{
                self.contentView.frame = frame;
            }];
            
        }else{
            CGRect frame = self.contentView.frame;
            frame.origin.x = 0;
            
            [UIView animateWithDuration:0.6 animations:^{
                self.contentView.frame = frame;
            }];
        }
    }
    
}

- (void) menuViewController:(MenuViewController *) menuViewController selectionOpt:(NSString *)menuList {
    NSLog(@"selected %@", menuList);
    if([menuList  isEqual: @"Profile"]){
        self.pvc.currentUser = [User currentUser];
        self.currentVC = self.pnvc;
    }else if ([menuList  isEqual: @"Home Timeline"]){
        self.currentVC = self.tnvc;
    }
    
    self.currentVC.view.frame = self.contentView.bounds;
    [self addChildViewController:self.currentVC];
    [self.contentView addSubview:self.currentVC.view];
    
    CGRect frame = self.contentView.frame;
    frame.origin.x = 0;
    
    [UIView animateWithDuration:0.6 animations:^{
        self.contentView.frame = frame;
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
