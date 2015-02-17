//
//  TwitterClient.h
//  Twitter
//
//  Created by Joanna Chan on 2/7/15.
//  Copyright (c) 2015 yahoo. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "User.h"
#import "Tweet.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *)sharedInstance;

- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion;
- (void)openURL: (NSURL *)url;

-(void)homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion;
-(void)composeWithParams:(NSDictionary *)params completion:(void (^)(Tweet *tweet, NSError *error))completion;
-(void)retweetWithParams:(NSDictionary *)params completion:(void (^)(Tweet *tweet, NSError *error))completion;
-(void)favWithParams:(NSDictionary *)params completion:(void (^)(Tweet *tweet, NSError *error))completion;

@end
