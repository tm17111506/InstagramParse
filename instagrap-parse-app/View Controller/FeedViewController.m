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

@interface FeedViewController () <UITableViewDelegate, UITableViewDataSource, PostCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray<Post*> *posts;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) PFUser *profileUser;
@property (strong, nonatomic) Post *commentPost;
@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self fetchPosts];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchPosts) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTapLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {}];
    NSLog(@"User has logged out!");
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
}

- (void)fetchPosts{
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    postQuery.limit = 20;
    
    [SVProgressHUD show];
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray <Post*> * _Nullable posts, NSError * _Nullable error) {
        if(posts){
            NSLog(@"Retrived Data");
            self.posts = posts;
            [self.tableView reloadData];
        }
        else{
            NSLog(@"Unable to fetch Posts: %@", error.localizedDescription);
        }
    }];
    [SVProgressHUD dismiss];
    [self.refreshControl endRefreshing];
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

-(void)segueToProfileFromUser:(PFUser *)user{
    self.profileUser = user;
    [self performSegueWithIdentifier:@"SpecificUserProfile" sender:nil];
}

-(void)segueToCommentFromUser:(Post *)post{
    self.commentPost = post;
    [self performSegueWithIdentifier:@"CommentSegue" sender:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
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
