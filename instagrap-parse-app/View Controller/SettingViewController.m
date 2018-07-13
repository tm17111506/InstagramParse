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
}

- (void)viewWillAppear:(BOOL)animated{
    [self getImageFromData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)getImageFromData{
    [[PFUser currentUser] fetchInBackground];
    self.user = [PFUser currentUser];

    PFFile *file = (PFFile *)self.user[@"profilePicture"];
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        self.profileImageView.image = [UIImage imageWithData:data];
        self.profileImageView.layer.cornerRadius = self.profileImageView.layer.bounds.size.width/2;
        self.profileImageView.layer.masksToBounds = YES;
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    CaptureViewController *captureVC = [segue destinationViewController];
    captureVC.fromUserProfile = YES;
}


@end
