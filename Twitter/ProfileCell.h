//
//  ProfileCell.h
//  Twitter
//
//  Created by Joanna Chan on 2/15/15.
//  Copyright (c) 2015 yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface ProfileCell : UITableViewCell

@property (nonatomic, strong) User *currentUser;
@property (nonatomic, strong) NSString *showBgImage;

@end
