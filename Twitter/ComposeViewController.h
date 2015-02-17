//
//  ComposeViewController.h
//  Twitter
//
//  Created by Joanna Chan on 2/8/15.
//  Copyright (c) 2015 yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Tweet.h"

@class ComposeViewController;

@protocol ComposeViewControllerDelegate <NSObject>

- (void) composeViewController:(ComposeViewController *) composeViewController didNewCompose:(Tweet *)tweet;

@end

@interface ComposeViewController : UIViewController

@property (nonatomic, strong) User *currentUser;
@property (nonatomic, weak) id<ComposeViewControllerDelegate> delegate;

@end
