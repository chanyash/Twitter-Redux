//
//  ComposeViewController.m
//  Twitter
//
//  Created by Joanna Chan on 2/8/15.
//  Copyright (c) 2015 yahoo. All rights reserved.
//

#import "UIImageView+AFNetworking.h"
#import "ComposeViewController.h"
#import "TwitterClient.h"

@interface ComposeViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textArea;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userId;
@property (weak, nonatomic) IBOutlet UILabel *wordCount;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(onTweet)];
    
    self.title = @"New";
    self.textArea.text = @"What's happening?";
    self.textArea.textColor = [UIColor lightGrayColor];
    self.textArea.delegate = self;
    
    self.currentUser = [User currentUser];
    [self.userImage setImageWithURL:[NSURL URLWithString:self.currentUser.profileImageUrl]];
    self.userName.text = self.currentUser.name;
    self.userId.text = [NSString stringWithFormat:@"@%@", self.currentUser.screenname ];
    
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    self.textArea.text = @"";
    self.textArea.textColor = [UIColor blackColor];
    return YES;
}

- (void) onCancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) onTweet {
    NSLog(@"on Tweet Btn");
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:self.textArea.text forKey:@"status"];

    
    [[TwitterClient sharedInstance] composeWithParams:params completion:^(Tweet *tweet, NSError *error) {
        
        [self.delegate composeViewController:self didNewCompose:tweet];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    // "Length of existing text" - "Length of replaced text" + "Length of replacement text"
    NSInteger newTextLength =  140 - ([textView.text length] - range.length + [text length]);
    
    if (newTextLength < 0) {
        // don't allow change
        return NO;
    }
    self.wordCount.text = [NSString stringWithFormat:@"%d", (int) newTextLength ];
    return YES;
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
