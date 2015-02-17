//
//  TwitterClient.m
//  Twitter
//
//  Created by Joanna Chan on 2/7/15.
//  Copyright (c) 2015 yahoo. All rights reserved.
//

#import "TwitterClient.h"
#import "Tweet.h"

NSString * const kTwitterConsumerKey = @"Eweb8iHzCwdhxlJMgTQ6n9IRi";
NSString * const kTwitterConsumerSecret = @"2blTr0N7QrTYSZaEly4zablrANh5oxFu3nswOKZe2urkU3e8wy";
NSString * const kTwitterBaseUrl = @"https://api.twitter.com";

@interface TwitterClient()

@property (nonatomic, strong) void (^loginCompletion)(User *user, NSError *error);

@end

@implementation TwitterClient

+ (TwitterClient *)sharedInstance {
    
    static TwitterClient *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if(instance == nil){
            instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:kTwitterBaseUrl] consumerKey:kTwitterConsumerKey consumerSecret:kTwitterConsumerSecret];
        }
    });
    
    return instance;
    
}

- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion{
    self.loginCompletion = completion;
    
    [self.requestSerializer removeAccessToken];
    
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"GET" callbackURL:[NSURL URLWithString:@"cptwitterdemo://oauth"] scope:nil
      success:^(BDBOAuth1Credential *requestToken) {
          NSLog(@"got the request token!");
          
          NSURL *authURL = [NSURL URLWithString:[NSString stringWithFormat: @"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token]];
          
          [[UIApplication sharedApplication] openURL:authURL];
          
      } failure:^(NSError *error) {
          NSLog(@"Failed to get the request token!");
          self.loginCompletion(nil, error);
      }];

}

- (void)openURL: (NSURL *)url{
    [self fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken: [BDBOAuth1Credential credentialWithQueryString: url.query] success:^(BDBOAuth1Credential *accessToken) {
        NSLog(@"got the access toketn!");
        
        [self.requestSerializer saveAccessToken:accessToken];
        [self GET:@"1.1/account/verify_credentials.json" parameters:nil
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"current user: %@", responseObject);
            User *user = [[User alloc] initWithDictionary:responseObject];
            [User setCurrentUser:user];
            NSLog(@"current user: %@", user.name);
            self.loginCompletion(user, nil);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failed getting current user");
            self.loginCompletion(nil, error);
        }];
        
    } failure:^(NSError *error) {
        NSLog(@"failed to get the access toketn!");
        self.loginCompletion(nil, error);
    }];

}

-(void)homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion{
    [self GET:@"1.1/statuses/home_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *tweets = [Tweet tweetsWithArray:responseObject];
        completion(tweets, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

-(void)composeWithParams:(NSDictionary *)params completion:(void (^)(Tweet *tweet, NSError *error))completion{
    [self POST:@"1.1/statuses/update.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        Tweet *tweet = [Tweet tweetWithDictionary:responseObject];
        completion(tweet, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

-(void)retweetWithParams:(NSDictionary *)params completion:(void (^)(Tweet *tweet, NSError *error))completion{
    NSString *endpoint = [NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", params[@"id"] ];
    [self POST:endpoint parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        Tweet *tweet = [Tweet tweetWithDictionary:responseObject];
        completion(tweet, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

-(void)favWithParams:(NSDictionary *)params completion:(void (^)(Tweet *tweet, NSError *error))completion{
    [self POST:@"1.1/favorites/create.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        Tweet *tweet = [Tweet tweetWithDictionary:responseObject];
        completion(tweet, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

@end
