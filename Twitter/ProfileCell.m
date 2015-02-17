//
//  ProfileCell.m
//  Twitter
//
//  Created by Joanna Chan on 2/15/15.
//  Copyright (c) 2015 yahoo. All rights reserved.
//

#import "UIImageView+AFNetworking.h"
#import "ProfileCell.h"

@interface ProfileCell ()
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userId;
@property (weak, nonatomic) IBOutlet UIImageView *userBgImage;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;

@end

@implementation ProfileCell

- (void)awakeFromNib {
    // Initialization code
    
    self.userImage.layer.cornerRadius = 3;
    self.userImage.clipsToBounds = YES;
    
    self.currentUser = [User currentUser];
    self.userName.text = self.currentUser.name;
    self.userId.text = [NSString stringWithFormat:@"@%@", self.currentUser.screenname ];
    [self.userImage setImageWithURL:[NSURL URLWithString:self.currentUser.profileImageUrl]];
    
    if([self.showBgImage isEqual: @"YES"]){
        NSLog(@"hihihi");
        [self.bgImage setImageWithURL:[NSURL URLWithString:self.currentUser.profileBgImageUrl]];
        [self.userBgImage setImageWithURL:[NSURL URLWithString:self.currentUser.profileBgImageUrl]];
    }
    
}

- (void) setShowBgImage:(NSString *)showBgImage {
    NSLog(@"hihihi %@", showBgImage);
    _showBgImage = showBgImage;
    if([showBgImage isEqual: @"YES"]){
        [self.bgImage setImageWithURL:[NSURL URLWithString:self.currentUser.profileBgImageUrl]];
        [self.userBgImage setImageWithURL:[NSURL URLWithString:self.currentUser.profileBgImageUrl]];
        self.backgroundColor = [UIColor colorWithRed:85.0f/255.0f green:172.0f/255.0f blue:238.0f/255.0f alpha:1.0f];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
