//
//  CommentViewController.m
//  ReadPeer
//
//  Created by Shaohuan Li on 5/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "CommentViewController.h"
#import "AnnotationModel.h"
#import "Comment.h"

@interface CommentViewController ()

@end

@implementation CommentViewController
{
     NSMutableArray * comments;
    AnnotationModel *currentAnnot;
}

@synthesize commentView,contentView,annotView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data
{
    comments = [[NSMutableArray alloc]init];
    Comment *one = [[Comment alloc] init];
    one.commentDetail = @"first comment";
    
    [comments addObject:one];
    Comment *two = [[Comment alloc] init];
    two.commentDetail = @"second comment";
    
    [comments addObject:two];
    
    [commentView reloadData];
}

-(void)updateCurrentAnnotation : (AnnotationModel*)selectedAnnotation
{
    currentAnnot = selectedAnnotation;
    contentView.text=selectedAnnotation.content;
    NSLog(@"current%@",selectedAnnotation.content);
    [contentView setTextColor:[UIColor grayColor]];
    [annotView setFont:[UIFont boldSystemFontOfSize:25]];
    annotView.text=selectedAnnotation.annot;
    NSURL *aUrl = [NSURL URLWithString:@"http://54.251.118.233/annot/index.php/annotation"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request
                                                                 delegate:self];
    
    [request setHTTPMethod:@"GET"];
    NSString *postString = [@"data=" stringByAppendingString:selectedAnnotation.aid];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    if (connection) {
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        NSLog(@"success get comments");
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Network Error"
                                    message:@"Fail to Connect to the Server"
                                   delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:@"OK", nil] show];
        // Inform the user that the connection failed.
    }

}
- (void)loadView {
    NSArray *theView =  [[NSBundle mainBundle] loadNibNamed:@"commentView" owner:self options:nil];
    UIView *nv = [theView objectAtIndex:0];
    self.view = nv;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    commentView.dataSource = self;
    commentView.delegate = self;
    
}
- (IBAction)backButtonPressed:(id)sender {
    [self.view removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setCommentView:nil];
    [self setAnnotView:nil];
    [self setContentView:nil];
    [super viewDidUnload];
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
   // [self performSegueWithIdentifier:@"segueToCommentDetails" sender:self];
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

@end
