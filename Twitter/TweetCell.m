//
//  TweetCell.m
//  Twitter
//
//  Created by Joanna Chan on 2/7/15.
//  Copyright (c) 2015 yahoo. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"
#import "UserProfileViewController.h"

@interface TweetCell ()

@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userId;
@property (weak, nonatomic) IBOutlet UILabel *tweetTime;
@property (weak, nonatomic) IBOutlet UILabel *tweetText;
@property (weak, nonatomic) IBOutlet UIButton *replyIcon;

@property (weak, nonatomic) IBOutlet UILabel *nReply;
@property (weak, nonatomic) IBOutlet UIButton *retweetIcon;
@property (weak, nonatomic) IBOutlet UILabel *nRetweet;
@property (weak, nonatomic) IBOutlet UIButton *favIcon;
@property (weak, nonatomic) IBOutlet UILabel *nFav;
@property (weak, nonatomic) IBOutlet UIImageView *userRetweetIcon;
@property (weak, nonatomic) IBOutlet UILabel *userRetweetName;

@end

@implementation TweetCell

- (void)awakeFromNib {
    // Initialization code
    
    [self.userRetweetIcon setImage: [UIImage imageNamed:@"retweet.png"]];
    self.userImage.layer.cornerRadius = 3;
    self.userImage.clipsToBounds = YES;
    
    self.userRetweetIcon.hidden = YES;
    self.userRetweetName.hidden = YES;
    
    
}

- (IBAction)onReteet:(id)sender {
    
    if ([sender isSelected]) {
        [sender setImage:[UIImage imageNamed:@"retweet.png"] forState:UIControlStateNormal];
        self.nRetweet.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount ];
        [sender setSelected:NO];
    } else {
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        [params setObject:self.tweet.tweetId forKey:@"id"];
        
        [[TwitterClient sharedInstance] retweetWithParams:params completion:^(Tweet *tweet, NSError *error) {
            self.nRetweet.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount + 1 ];
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setTweet:(Tweet *)tweet {
    _tweet = tweet;
    
    NSDate * now = [NSDate date];
    
    NSTimeInterval secondsBetween = [now timeIntervalSinceDate:self.tweet.createdAt];
    NSString *timeFromNow = @"";
    
    int hours = (int)secondsBetween / 3600;
    int minutes = (secondsBetween - (hours*3600)) / 60;
    int second = (secondsBetween - (hours*3600) - (minutes*60));
    
    if(hours < 24){
        if(hours > 0){
            timeFromNow = [NSString stringWithFormat:@"%dh", hours];
        }
        
        if(minutes > 0){
            timeFromNow = [NSString stringWithFormat:@"%@%dm", timeFromNow, minutes];
        }
        
        if(second > 0){
            timeFromNow = [NSString stringWithFormat:@"%@%ds", timeFromNow, second];
        }
        
    }else{
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"MMM/dd/yy";
        timeFromNow = [formatter stringFromDate:self.tweet.createdAt];
    }
    
    self.tweetTime.text = timeFromNow;
    
    [self.userImage setImageWithURL:[NSURL URLWithString:self.tweet.user.profileImageUrl]];
    self.userName.text = self.tweet.user.name;
    self.userId.text = [NSString stringWithFormat:@"@%@", self.tweet.user.screenname ];
    self.tweetText.text = self.tweet.text;
    
    self.nRetweet.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount ];
    self.nFav.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount ];
    self.nReply.text = @"";
    
    if(self.tweet.retweeted_user != nil){
        self.userRetweetName.text = [NSString stringWithFormat:@"%@ retweeted", self.tweet.retweeted_user.name ];
        self.userRetweetIcon.hidden = NO;
        self.userRetweetName.hidden = NO;
    }else{
       //[self.userRetweetNa;me removeFromSuperview];
       //[self.userRetweetIcon removeFromSuperview];
        
    }
    
}

- (IBAction)onTapUser:(id)sender {
    
    [self.delegate tweetCell:self didSelectUser:self.tweet.user];
    
}



@end
