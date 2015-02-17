//
//  MenuList.m
//  Twitter
//
//  Created by Joanna Chan on 2/15/15.
//  Copyright (c) 2015 yahoo. All rights reserved.
//

#import "MenuList.h"
#import "UIImageView+AFNetworking.h"

@implementation MenuList

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setIconImage:(NSString *)iconImage {
    [self.menuIcon setImage:[UIImage imageNamed:iconImage]];
}

@end
