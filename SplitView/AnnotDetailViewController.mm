//
//  AnnotDetailViewController.m
//  SplitView
//
//  Created by Shaohuan Li on 15/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "AnnotDetailViewController.h"
#import "Comment.h"

@interface AnnotDetailViewController ()

@end

@implementation AnnotDetailViewController

@synthesize currentAnnot;
@synthesize contentView;
@synthesize commentView;
@synthesize annotView;
@synthesize comments;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    comments = [[NSMutableArray alloc] init];
    commentView.dataSource = self;
    commentView.delegate = self;
    contentView.text=currentAnnot.content;
    [contentView setTextColor:[UIColor grayColor]];
    [annotView setFont:[UIFont boldSystemFontOfSize:25]];
    annotView.text=currentAnnot.annot;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [comments count];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*[self.delegate didSelectCustomer:selectedCustomer];*/
    /*[self.navController pushViewController:animated:YES];
     [tableView deselectRowAtIndexPath:indexPath animated:YES];*/
    [self performSegueWithIdentifier:@"segueToCommentDetails" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"segueToCommentDetails"])
    {
        // AnnotationViewController *vc = [segue destinationViewController];
        //  [vc setMyObjectHere:object];
        /* AnnotationViewController *annotController= [segue destinationViewController];*/
        // annotController.aid =1;
        NSIndexPath *selectedRowIndex = [commentView indexPathForSelectedRow];
        Comment *selectedComment = [comments objectAtIndex:[selectedRowIndex row]];
        CommentDetailViewController *commentController=[segue destinationViewController];
        commentController.currentComment=selectedComment;
    }
}

-(void)updateComments:(NSMutableArray*)cms
{
    comments = cms;
    [commentView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CommentCell";
    
    Comment *comment = [comments objectAtIndex:[indexPath row]];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    }
    
    [[cell textLabel] setText:comment.commentDetail];
    return cell;
}

- (void)viewDidUnload {
    [self setAnnotView:nil];
    [super viewDidUnload];
}
@end
