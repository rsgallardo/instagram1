//
//  ProfileViewController.h
//  instagram1
//
//  Created by rgallardo on 7/10/19.
//  Copyright © 2019 rgallardo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (strong, nonatomic) NSMutableArray *posts;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

NS_ASSUME_NONNULL_END
