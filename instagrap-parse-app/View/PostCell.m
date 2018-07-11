//
//  PostCell.m
//  instagrap-parse-app
//
//  Created by Tiffany Ma on 7/9/18.
//  Copyright © 2018 Tiffany Ma. All rights reserved.
//

#import "PostCell.h"
#import "Post.h"
#import "UIImageView+AFNetworking.h"
#import "DateTools.h"
#import "Parse.h"

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setPostDetail:(Post *)post{
    self.numLikesLabel.text = [NSString stringWithFormat:@"%@",post.likeCount];
    self.detailUserNameLabel.text = post.author.username;
    self.detailDescriptionLabel.text = post.caption;
    [self.detailDescriptionLabel sizeToFit];
    self.userNameLabel.text = post.author.username;
    NSDate *createdDate = post.createdAt;
    
    if(createdDate.timeIntervalSinceNow < -43200){
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"MMM d YYYY";
        self.detailTimeLabel.text = [formatter stringFromDate:createdDate];
    }
    else{
        self.detailTimeLabel.text = createdDate.timeAgoSinceNow;
    }
    [self.detailTimeLabel sizeToFit];
    NSURL *url = [NSURL URLWithString:post.image.url];
    [self.postImageView setImageWithURL:url];
    
    [[PFUser currentUser] fetchInBackground];
    PFUser *user = [PFUser currentUser];
    
    PFFile *file = (PFFile *)user[@"profilePicture"];
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        self.userProfileImageView.image = [UIImage imageWithData:data];
    }];
    
    self.userProfileImageView.layer.cornerRadius = self.userProfileImageView.layer.bounds.size.height/2;
    self.userProfileImageView.layer.masksToBounds = YES;
}

@end
