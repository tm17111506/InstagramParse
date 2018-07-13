//
//  CommentViewController.m
//  instagrap-parse-app
//
//  Created by Tiffany Ma on 7/11/18.
//  Copyright © 2018 Tiffany Ma. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentTableViewCell.h"

@interface CommentViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;
@property (weak, nonatomic) IBOutlet UILabel *commentUsernameLabel;
@property (strong, nonatomic) PFUser *commentUser;
@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (IBAction)onTapPost:(id)sender {
    NSMutableDictionary *singleComment = [[NSMutableDictionary alloc]init];
    [singleComment setObject:[PFUser currentUser] forKey:@"author"];
    [singleComment setObject:self.commentTextField.text forKey:@"commentText"];

    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.post.comments];
    [tempArray insertObject:singleComment atIndex:0];
    self.post.comments = [tempArray copy];
    
    [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded){
            self.commentTextField.text = @"";
            [self.tableView reloadData];
        }
        else NSLog(@"%@", error.localizedDescription);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.post.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    NSMutableArray *commentsArray = [NSMutableArray arrayWithArray:self.post.comments];
    NSDictionary *comment = commentsArray[indexPath.row];
    
    PFUser *orgUser = comment[@"author"];
    PFUser *user = [PFQuery getUserObjectWithId:orgUser.objectId];
    
    cell.commentLabel.text = comment[@"commentText"];
    cell.usernameLabel.text = user.username;
    
    PFFile *file = (PFFile *)(user[@"profilePicture"]);
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        cell.profileImageView.image = [UIImage imageWithData:data];
    }];
    
    cell.profileImageView.layer.cornerRadius = cell.profileImageView.layer.bounds.size.height/2;
    cell.profileImageView.layer.masksToBounds = YES;
    
    [cell.commentLabel sizeToFit];
    [cell.usernameLabel sizeToFit];
    return cell;
}

/*
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
