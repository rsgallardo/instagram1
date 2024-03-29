//
//  HomeFeedViewController.h
//  instagram1
//
//  Created by rgallardo on 7/9/19.
//  Copyright © 2019 rgallardo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "ComposeViewController.h"
#import "PostCell.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface HomeFeedViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UINavigationControllerDelegate, ComposeViewControllerDelegate, PostCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *posts;
- (IBAction)didTapLogout:(id)sender;
- (IBAction)didTapCamera:(id)sender;

@end

NS_ASSUME_NONNULL_END
