//
//  Tweet.m
//  Twitter
//
//  Created by Joanna Chan on 2/7/15.
//  Copyright (c) 2015 yahoo. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

- (id) initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    
    if(self){
        if(dictionary[@"retweeted_status"] != nil){
            self.user = [[User alloc] initWithDictionary:dictionary[@"retweeted_status"][@"user"]];
            self.text = dictionary[@"retweeted_status"][@"text"];
            
            NSString *createdAtString = dictionary[@"retweeted_status"][@"created_at"];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
            self.createdAt = [formatter dateFromString:createdAtString];
            
            self.replyCount = 0;
            self.retweetCount =  (int) [dictionary[@"retweeted_status"][@"retweet_count"] integerValue];
            self.favoriteCount = (int) [dictionary[@"retweeted_status"][@"favorite_count"] integerValue];
            
            self.retweeted_user = [[User alloc] initWithDictionary:dictionary[@"user"]];
            self.tweetId = dictionary[@"id"];
        }else{
            self.user = [[User alloc] initWithDictionary:dictionary[@"user"]];
            self.text = dictionary[@"text"];
            
            NSString *createdAtString = dictionary[@"created_at"];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
            self.createdAt = [formatter dateFromString:createdAtString];
            
            self.replyCount = 0;
            self.retweetCount =  (int) [dictionary[@"retweet_count"] integerValue];
            self.favoriteCount = (int) [dictionary[@"favorite_count"] integerValue];
            self.retweeted_user = nil;
            self.tweetId = dictionary[@"id"];
        }
       
    }
    
    return self;
}

+ (NSArray *)tweetsWithArray:(NSArray *)array{
    NSMutableArray *tweets = [NSMutableArray array];
    
    for (NSDictionary *dictionary in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:dictionary]];
        
    }
    
    return tweets;
}

+ (Tweet *)tweetWithDictionary:(NSDictionary *)dictionary{
    return [[Tweet alloc] initWithDictionary:dictionary];
}

@end
