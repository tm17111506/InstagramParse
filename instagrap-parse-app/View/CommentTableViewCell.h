//
//  CommentTableViewCell.h
//  instagrap-parse-app
//
//  Created by Tiffany Ma on 7/11/18.
//  Copyright © 2018 Tiffany Ma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@end
