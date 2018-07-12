//
//  PostCell.h
//  instagrap-parse-app
//
//  Created by Tiffany Ma on 7/9/18.
//  Copyright © 2018 Tiffany Ma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

@protocol PostCellDelegate
-(void)segueToProfileFromUser:(PFUser*)user;
@end

@interface PostCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *numLikesLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailUserNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) Post *post;
@property (strong, nonatomic) id<PostCellDelegate> delegate;
- (void)setPostDetail:(Post*)post;
@end
