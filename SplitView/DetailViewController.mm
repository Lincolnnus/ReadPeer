//
//  DetailViewController.m
//  SplitView
//
//  Created by Shaohuan Li on 14/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//
#import "DetailViewController.h"
#import "MasterViewController.h"
#import "Tesseract.h"

@implementation DetailViewController
{
    UIPopoverController *masterPopoverController;
    NSMutableArray *annotations;
}


@synthesize toolbar;
@synthesize popoverController;
@synthesize selectedImg;
@synthesize bookView;
@synthesize spinner;
@synthesize progressHud;
@synthesize tess;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // UISplitViewControllerDelegate
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = @"Get Annotations";
    NSMutableArray *items = [[self.toolbar items] mutableCopy];
    [items insertObject:barButtonItem atIndex:0];
    [self.toolbar setItems:items animated:YES];
    
    masterPopoverController = pc;
}

- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)button
{
    NSMutableArray *items = [[self.toolbar items] mutableCopy];
    [items removeObject:button];
    [self.toolbar setItems:items animated:YES];
    masterPopoverController = nil;
}
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    for(UIView *subview in [bookView subviews]) {
        [subview removeFromSuperview];
    }
    selectedImg = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImageView *pageView = [[UIImageView alloc] initWithImage:selectedImg];
    [bookView addSubview: pageView];
    [popoverController dismissPopoverAnimated:YES];
     [picker dismissModalViewControllerAnimated:YES];
    //[self getTextfromImage:image];
    [self getAnnotations];
    
}
- (IBAction)takePhoto:(id)sender {
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    imagePickerController.sourceType =UIImagePickerControllerSourceTypeCamera;
    imagePickerController.delegate = self;
    
    popoverController=[[UIPopoverController alloc] initWithContentViewController:imagePickerController];
    
    [popoverController presentPopoverFromRect:CGRectMake(650.0, 0.0, 150.0, 100.0)
                                       inView:self.view
                     permittedArrowDirections:UIPopoverArrowDirectionAny
                                     animated:YES];
}

- (IBAction)loadPhoto:(id)sender {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    imagePickerController.sourceType =UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    
    popoverController=[[UIPopoverController alloc] initWithContentViewController:imagePickerController];
    
    [popoverController presentPopoverFromRect:CGRectMake(650.0, 0.0, 150.0, 30.0)
                                       inView:self.view
                     permittedArrowDirections:UIPopoverArrowDirectionAny
                                     animated:YES];
}

- (void)getAnnotations
{
    self.progressHud = [[MBProgressHUD alloc] initWithView:self.view];
    self.progressHud.labelText = @"Processing OCR";
    
    [self.view addSubview:self.progressHud];
    [self.progressHud showWhileExecuting:@selector(processOcrAt:) onTarget:self withObject:selectedImg animated:YES];
}
#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.toolbar = nil;
    
}

- (void)processOcrAt:(UIImage *)image
{
    
     Tesseract* tesseract = [[Tesseract alloc] initWithDataPath:@"tessdata" language:@"eng"];
     [tesseract setImage:image];
     [tesseract recognize];
     
     [self performSelectorOnMainThread:@selector(ocrProcessingFinished:)
     withObject:[tesseract recognizedText]
     waitUntilDone:NO];
   /* [self performSelectorOnMainThread:@selector(ocrProcessingFinished:)
                           withObject:@"haha"
                        waitUntilDone:NO];*/
}

- (void)ocrProcessingFinished:(NSString *)result
{
    NSURL *aUrl = [NSURL URLWithString:@"http://54.251.118.233/annot/index.php/annotation"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request
                                                                 delegate:self];
    
    [request setHTTPMethod:@"GET"];
    NSString *postString = [@"data=" stringByAppendingString:result];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    if (connection) {
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        [[[UIAlertView alloc] initWithTitle:@"Tesseract Sample"
         message:[NSString stringWithFormat:@"Recognized:\n%@", result]
         delegate:nil
         cancelButtonTitle:nil
         otherButtonTitles:@"OK", nil] show];
        
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Tesseract Sample"
                                    message:@"Fail to Connect to the Server"
                                   delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:@"OK", nil] show];
        // Inform the user that the connection failed.
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    
   // NSError *error = nil;
    /*  NSString* decoded = [NSString stringWithUTF8String:(const char *)[data bytes]];
     //NSString* decoded = [[NSString alloc] initWithData:data   encoding:NSUTF8StringEncoding];
     decoded=[decoded stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]];
     id response =[NSJSONSerialization JSONObjectWithData:[decoded dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments|NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error];*/
   /* annotations =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments|NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error];
    for ( int i= 0; i < [annotations count]; i++){
        [self addAnnotation:annotations[i]];
    }*/
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
