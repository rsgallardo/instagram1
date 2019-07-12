//
//  ProfileViewController.h
//  instagram1
//
//  Created by rgallardo on 7/10/19.
//  Copyright © 2019 rgallardo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) PFUser *user;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) NSMutableArray *posts;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet PFImageView *profilePicture;
- (IBAction)didTapProfileImage:(id)sender;

@end

NS_ASSUME_NONNULL_END
