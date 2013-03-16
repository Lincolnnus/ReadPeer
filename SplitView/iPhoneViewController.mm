//
//  iPhoneViewController.m
//  SplitView
//
//  Created by Shaohuan Li on 16/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "iPhoneViewController.h"

@interface iPhoneViewController ()

@end

@implementation iPhoneViewController

@synthesize popoverController;
@synthesize bookView;
@synthesize selectedImg;

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
}
- (IBAction)takePhoto:(id)sender {
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
	[self presentModalViewController:picker animated:YES];

}
- (IBAction)loadPhoto:(id)sender {
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
	[self presentModalViewController:picker animated:YES];

}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissModalViewControllerAnimated:YES];
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    for(UIView *subview in [bookView subviews]) {
        [subview removeFromSuperview];
    }
    selectedImg = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImageView *pageView = [[UIImageView alloc] initWithImage:selectedImg];
    pageView.frame = CGRectMake(0, 0, bookView.frame.size.width, bookView.frame.size.height);
    [bookView addSubview: pageView];
    [popoverController dismissPopoverAnimated:YES];
    [picker dismissModalViewControllerAnimated:YES];
    //[self getTextfromImage:image];*/

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setBookView:nil];
    [self setBookView:nil];
    [super viewDidUnload];
}
@end
