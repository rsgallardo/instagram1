//
//  PostCell.h
//  instagram1
//
//  Created by rgallardo on 7/9/19.
//  Copyright © 2019 rgallardo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostCell : UITableViewCell

@property (weak, nonatomic) Post *post;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *usernameTop;
@property (weak, nonatomic) IBOutlet UILabel *usernameBottom;
@property (weak, nonatomic) IBOutlet UILabel *caption;

@end

NS_ASSUME_NONNULL_END
