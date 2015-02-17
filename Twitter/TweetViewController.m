//
//  TweetViewController.m
//  Twitter
//
//  Created by Joanna Chan on 2/8/15.
//  Copyright (c) 2015 yahoo. All rights reserved.
//

#import "TweetViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"

@interface TweetViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *userRetweetIcon;
@property (weak, nonatomic) IBOutlet UILabel *userRetweetName;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userId;
@property (weak, nonatomic) IBOutlet UILabel *tweetText;
@property (weak, nonatomic) IBOutlet UILabel *tweetTime;
@property (weak, nonatomic) IBOutlet UILabel *nRetweets;
@property (weak, nonatomic) IBOutlet UILabel *nFav;
@property (weak, nonatomic) IBOutlet UIButton *replyIcon;
@property (weak, nonatomic) IBOutlet UIButton *retweetIcon;
@property (weak, nonatomic) IBOutlet UIButton *favIcon;

@end

@implementation TweetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Reply" style:UIBarButtonItemStylePlain target:self action:@selector(onReply)];
    self.title = @"Tweet";
    
    [self.userRetweetIcon setImage: [UIImage imageNamed:@"retweet.png"]];
    self.userImage.layer.cornerRadius = 3;
    self.userImage.clipsToBounds = YES;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM/d/y HH:mm a";
    self.tweetTime.text = [formatter stringFromDate:self.tweet.createdAt];
    
    [self.userImage setImageWithURL:[NSURL URLWithString:self.tweet.user.profileImageUrl]];
    self.userName.text = self.tweet.user.name;
    self.userId.text = [NSString stringWithFormat:@"@%@", self.tweet.user.screenname ];
    self.tweetText.text = self.tweet.text;
    
    self.nRetweets.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount ];
    self.nFav.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount ];
    
    if(self.tweet.retweeted_user != nil){
        self.userRetweetName.text = [NSString stringWithFormat:@"%@ retweeted", self.tweet.retweeted_user.name ];
        self.userRetweetIcon.hidden = NO;
        self.userRetweetName.hidden = NO;
    }else{
        self.userRetweetIcon.hidden = YES;
        self.userRetweetName.hidden = YES;
    }
    
}

- (void) setTweet:(Tweet *)tweet {
    NSLog(@"set tweet");
    _tweet = tweet;
    
}

- (void) onReply {
    NSLog(@"on Reply btn");
}

- (IBAction)onRetweet:(id)sender {
    
    if ([sender isSelected]) {
        [sender setImage:[UIImage imageNamed:@"retweet.png"] forState:UIControlStateNormal];
        self.nRetweets.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount ];
        [sender setSelected:NO];
    } else {
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:self.tweet.tweetId forKey:@"id"];
        
        [[TwitterClient sharedInstance] retweetWithParams:params completion:^(Tweet *tweet, NSError *error) {
            self.nRetweets.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount + 1 ];
            [sender setImage:[UIImage imageNamed:@"retweet_on.png"] forState:UIControlStateSelected];
            [sender setSelected:YES];
        }];
        
    }
    
}

- (IBAction)onFav:(id)sender {
    
    if ([sender isSelected]) {
        [sender setImage:[UIImage imageNamed:@"favorite.png"] forState:UIControlStateNormal];
        self.nFav.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount ];
        [sender setSelected:NO];
    } else {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        [params setObject:self.tweet.tweetId forKey:@"id"];
        
        [[TwitterClient sharedInstance] favWithParams:params completion:^(Tweet *tweet, NSError *error) {
            self.nFav.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount + 1 ];
            [sender setImage:[UIImage imageNamed:@"favorite_on.png"] forState:UIControlStateSelected];
            [sender setSelected:YES];
        }];
    }
    
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
