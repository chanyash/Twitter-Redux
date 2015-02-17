//
//  LoginViewController.m
//  Twitter
//
//  Created by Joanna Chan on 2/7/15.
//  Copyright (c) 2015 yahoo. All rights reserved.
//

#import "LoginViewController.h"
#import "TwitterClient.h"
#import "TweetsViewController.h"
#import "MainViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *logo;

@end

@implementation LoginViewController

- (IBAction)onLogin:(id)sender {
    
    [[TwitterClient sharedInstance] loginWithCompletion:^(User *user, NSError *error) {
        if(user != nil){
            //Modally present tweets view
            NSLog(@"Welcome to %@", user.name);
            
            //UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:[[TweetsViewController alloc] init]];
            MainViewController *nvc = [[MainViewController alloc] init];
            [self presentViewController:nvc animated:YES completion:nil];
        } else {
            // Present error view
        }
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.logo setImage: [UIImage imageNamed:@"Twitter_logo_white_48.png"]];
    self.title = @"Login";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
