//
//  HomeFeedViewController.m
//  instagram1
//
//  Created by rgallardo on 7/9/19.
//  Copyright © 2019 rgallardo. All rights reserved.
//

#import "HomeFeedViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "Parse/Parse.h"
#import "Post.h"
#import "PostCell.h"
#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"


@interface HomeFeedViewController ()

@end

@implementation HomeFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //(4) Make an API request
    [self getHomeFeed];
    //pull down to refresh home feed
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
}

- (void)getHomeFeed {
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    query.limit = 20;
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            // (6) View controller stores data passed into completion handler do something with the array of object returned by the call
            self.posts = [[NSMutableArray alloc] initWithArray:posts];
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            for (Post *post in posts) {
                NSString *text = post.caption;
                NSLog(@"%@", text);
            }
            // (7) Reload the table view
            [self.tableView reloadData];
        } else {
            NSLog(@"Couldn't load home timeline: %@", error.localizedDescription);
        }
    }];
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    [self getHomeFeed];
    [refreshControl endRefreshing];
}


- (IBAction)didTapLogout:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
    }];
}

- (IBAction)didTapCamera:(id)sender {
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    // Use identifier to set cell
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell" forIndexPath:indexPath];
    // assign the values for the post cell
    Post *post = self.posts[indexPath.row];
    cell.post = post;
    cell.usernameTop.text = post.author.username;
    cell.usernameBottom.text = post.author.username;
    cell.caption.text = post.caption;
    NSURL *postURL = [NSURL URLWithString:post.image.url];
    [cell.image setImageWithURL:postURL];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"detailsSegue"]) {
        // Get the new view controller using [segue destinationViewController].
        DetailsViewController *detailsViewController = [segue destinationViewController];
        // Pass the selected object to the new view controller.
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Post *post = self.posts[indexPath.row];
        detailsViewController.post = post;
    } else if ([segue.identifier isEqualToString:@"postSegue"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        // Pass the selected object to the new view controller.
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
    }
}

- (void)didPost {
    [self getHomeFeed];
}


@end
