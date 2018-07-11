//
//  SettingViewController.m
//  instagrap-parse-app
//
//  Created by Tiffany Ma on 7/10/18.
//  Copyright © 2018 Tiffany Ma. All rights reserved.
//

#import "SettingViewController.h"
#import "Parse.h"
#import "CaptureViewController.h"

@interface SettingViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) PFUser *user;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getImageFromData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getImageFromData{
    [[PFUser currentUser] fetchInBackground];
    self.user = [PFUser currentUser];

    PFFile *file = (PFFile *)self.user[@"profilePicture"];
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        self.profileImageView.image = [UIImage imageWithData:data];
    }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    CaptureViewController *captureVC = [segue destinationViewController];
    captureVC.fromUserProfile = YES;
}


@end
