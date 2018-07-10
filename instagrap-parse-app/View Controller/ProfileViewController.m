//
//  ProfileViewController.m
//  instagrap-parse-app
//
//  Created by Tiffany Ma on 7/10/18.
//  Copyright © 2018 Tiffany Ma. All rights reserved.
//

#import "ProfileViewController.h"
#import "Parse.h"
#import "PostCollectionCell.h"
#import "UIImageView+AFNetworking.h"

@interface ProfileViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) PFUser *user;
@property (strong, nonatomic) NSArray *posts;
@property (weak, nonatomic) IBOutlet UICollectionView *postCollectionView;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.user = [PFUser currentUser];
    [self fetchPosts];
    self.userNameLabel.text = self.user.username;
    
    self.postCollectionView.delegate = self;
    self.postCollectionView.dataSource = self;
    
    UICollectionViewFlowLayout *layout = self.postCollectionView.collectionViewLayout;
    
    CGFloat posterPerLine = 3;
    CGFloat posterWidth = self.postCollectionView.frame.size.width/posterPerLine - 3;
    
    layout.itemSize = CGSizeMake(posterWidth, posterWidth);
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchPosts{
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    postQuery.limit = 20;
    
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray <Post*> * _Nullable posts, NSError * _Nullable error) {
        if(posts){
            NSLog(@"Retrived Data");
            self.posts = posts;
            [self.postCollectionView reloadData];
        }
        else{
            NSLog(@"Unable to fetch Posts: %@", error.localizedDescription);
        }
    }];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PostCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PostCollectionCell" forIndexPath:indexPath];
    Post *post = self.posts[indexPath.row];
    NSURL *url = [NSURL URLWithString:post.image.url];
    [cell.postImageView setImageWithURL:url];
    NSLog(@"%@", url);
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.posts.count;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
