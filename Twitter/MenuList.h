//
//  MenuList.h
//  Twitter
//
//  Created by Joanna Chan on 2/15/15.
//  Copyright (c) 2015 yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuList : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *menuIcon;
@property (strong, nonatomic) NSString *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *menuList;

@end
