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
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@protocol PostCellDelegate;
@interface PostCell : UITableViewCell

@property (nonatomic, weak) id<PostCellDelegate> delegate;
@property (weak, nonatomic) Post *post;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *usernameTop;
@property (weak, nonatomic) IBOutlet UILabel *usernameBottom;
@property (weak, nonatomic) IBOutlet UILabel *caption;
@property (weak, nonatomic) IBOutlet PFImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *timeStamp;

@end

@protocol PostCellDelegate

- (void)postCell:(PostCell *) postCell didTap: (PFUser *)user;

@end

NS_ASSUME_NONNULL_END
