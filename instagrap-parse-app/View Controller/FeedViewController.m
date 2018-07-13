//
//  FeedViewController.m
//  instagrap-parse-app
//
//  Created by Tiffany Ma on 7/9/18.
//  Copyright © 2018 Tiffany Ma. All rights reserved.
//

#import "FeedViewController.h"
#import "Parse.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "Post.h"
#import "PostCell.h"
#import "SVProgressHUD.h"
#import "ProfileViewController.h"
#import "CommentViewController.h"

@interface FeedViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, PostCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray<Post*> *posts;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) PFUser *profileUser;
@property (strong, nonatomic) Post *commentPost;
@property (strong, nonatomic) NSDate *lastDate;
@property int newPostCount;
@property BOOL isMoreDataLoading;
@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD show];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self fetchPosts];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchPosts) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    self.isMoreDataLoading = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [SVProgressHUD show];
    [self fetchPosts];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTapLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {}];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
}

- (void)fetchPosts{
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    postQuery.limit = 15;
    
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray <Post*> * _Nullable posts, NSError * _Nullable error) {
        if(posts){
            self.posts = posts;
            [self.tableView reloadData];
            [SVProgressHUD dismiss];
        }
        else{
            NSLog(@"Unable to fetch Posts: %@", error.localizedDescription);
        }
    }];
    [self.refreshControl endRefreshing];
}

-(void)fetchMorePosts:(NSDate *)lastDate{
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    [postQuery whereKey:@"createdAt" lessThan:lastDate];
    postQuery.limit = 5;
    
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.posts];
            self.newPostCount = posts.count;
            for(int j = 0; j < self.newPostCount; j++){
                [tempArray insertObject:posts[j] atIndex:(self.posts.count+j)];
            }
            
            self.posts = [tempArray copy];
            NSMutableArray *indexPathArray = [[NSMutableArray alloc] init];

            for(int i=0; i<self.newPostCount; i++){
                NSIndexPath *idxPath = [NSIndexPath indexPathForRow:self.posts.count - 1 - i inSection:0];
                [indexPathArray addObject:idxPath];
            }
            
            NSArray *indexPathOrgArray = [indexPathArray copy];
            [self.tableView insertRowsAtIndexPaths:indexPathOrgArray withRowAnimation:UITableViewRowAnimationNone];
            
            if(self.newPostCount == 5) self.isMoreDataLoading = NO;
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    Post *post = self.posts[indexPath.row];
    [cell setPostDetail:post];
    cell.delegate = self;
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(!self.isMoreDataLoading){
        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
        
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
            self.isMoreDataLoading = YES;
            Post *latestPost = self.posts[self.posts.count - 1];
            [self fetchMorePosts:latestPost.createdAt];
        }
    }
}

-(void)segueToProfileFromUser:(PFUser *)user{
    self.profileUser = user;
    [self performSegueWithIdentifier:@"SpecificUserProfile" sender:nil];
}

-(void)segueToCommentFromUser:(Post *)post{
    self.commentPost = post;
    [self performSegueWithIdentifier:@"CommentSegue" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"SpecificUserProfile"]){
        ProfileViewController *profileVC = [segue destinationViewController];
        profileVC.user = self.profileUser;
        profileVC.currentUser = NO;
    }
    else if([segue.identifier isEqualToString:@"CommentSegue"]){
        CommentViewController *commentVC = [segue destinationViewController];
        commentVC.post = self.commentPost;
    }
}

@end
