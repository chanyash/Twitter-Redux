//
//  MenuViewController.h
//  Twitter
//
//  Created by Joanna Chan on 2/15/15.
//  Copyright (c) 2015 yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@class MenuViewController;

@protocol MenuViewControllerDelegate <NSObject>

- (void) menuViewController:(MenuViewController *) menuViewController selectionOpt:(NSString *)menuList;

@end


@interface MenuViewController : UIViewController

@property (nonatomic, weak) id<MenuViewControllerDelegate> delegate;

@end
