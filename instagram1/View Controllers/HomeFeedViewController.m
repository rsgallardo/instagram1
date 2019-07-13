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
#import "ProfileViewController.h"
#import "UIImageView+AFNetworking.h"


@interface HomeFeedViewController ()

@property (assign, nonatomic) BOOL isMoreDataLoading;

@end

@implementation HomeFeedViewController

static int queryLimit = 20;

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
    query.limit = queryLimit;
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            // (6) View controller stores data passed into completion handler do something with the array of objects returned by the call
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
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    cell.delegate = self;
    // assign the values for the post cell
    Post *post = self.posts[indexPath.row];
    cell.post = post;
    cell.usernameTop.text = post.author[@"username"];
    cell.usernameBottom.text = post.author[@"username"];
    cell.caption.text = post[@"caption"];
    NSURL *postURL = [NSURL URLWithString:post.image.url];
    [cell.image setImageWithURL:postURL];
    //set profile image if user has one
    if(post.author[@"profilePhoto"]) {
        cell.profilePicture.file = post.author[@"profilePhoto"];
        [cell.profilePicture loadInBackground];
    }
    //Set timestamp label
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // Configure the input format to parse the date string
    formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
    // Configure output format
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterNoStyle;
    cell.timeStamp.text = [formatter stringFromDate:cell.post.createdAt];
    
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
    } else if ([segue.identifier isEqualToString:@"profileSegue"]) {
        ProfileViewController *profileController = [segue destinationViewController];
        profileController.user = sender;
        NSLog(@"User being passed: %@", profileController.user.username);
    }
}

- (void)didPost {
    [self getHomeFeed];
}

-(void)loadMoreData{
    // get oldest post currently on feed
    Post *lastPost = self.posts[self.posts.count - 1];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"createdAt < %@", lastPost.createdAt];
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post" predicate:predicate];
    query.limit = queryLimit;
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *olderPosts, NSError *error) {
        if (olderPosts != nil) {
            // append older posts to end of self.posts
            [self.posts addObjectsFromArray:olderPosts];
            NSLog(@"😎😎😎 Successfully loaded older posts");
            for (Post *post in self.posts) {
                NSString *text = post.caption;
                NSLog(@"%@", text);
            }
            // Update flag
            self.isMoreDataLoading = false;
            
            // reload table view with new data
            [self.tableView reloadData];
        } else {
            NSLog(@"Couldn't load older posts: %@", error.localizedDescription);
        }
    }];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(!self.isMoreDataLoading){
        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
            self.isMoreDataLoading = true;
            // ... Code to load more results ...
            [self loadMoreData];
        }
    }
}

//method for going to user profile from photo
- (void)postCell:(PostCell *)postCell didTap: (PFUser *)user{
    [self performSegueWithIdentifier:@"profileSegue" sender:user];
}

@end
