//
//  PostCollectionViewCell.h
//  instagram1
//
//  Created by rgallardo on 7/10/19.
//  Copyright © 2019 rgallardo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) Post *post;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

NS_ASSUME_NONNULL_END
