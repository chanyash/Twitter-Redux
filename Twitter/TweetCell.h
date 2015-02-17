//
//  TweetCell.h
//  Twitter
//
//  Created by Joanna Chan on 2/7/15.
//  Copyright (c) 2015 yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "User.h"

@class TweetCell;

@protocol TweetCellDelegate <NSObject>

- (void) tweetCell:(TweetCell *) tweetCell didSelectUser:(User *)user;

@end

@interface TweetCell : UITableViewCell

@property (nonatomic, strong) Tweet *tweet;
@property (nonatomic, weak) id<TweetCellDelegate> delegate;

@end
