//
//  Tweet.h
//  Twitter
//
//  Created by Joanna Chan on 2/7/15.
//  Copyright (c) 2015 yahoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) User *user;
@property (nonatomic, assign) int retweetCount;
@property (nonatomic, assign) int favoriteCount;
@property (nonatomic, assign) int replyCount;
@property (nonatomic, strong) User *retweeted_user;
@property (nonatomic, strong) NSString *tweetId;


- (id) initWithDictionary:(NSDictionary *)dictionary;

+ (NSArray *)tweetsWithArray:(NSArray *)array;
+ (Tweet *)tweetWithDictionary:(NSDictionary *)dictionary;

@end
