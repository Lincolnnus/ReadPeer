//
//  DetailViewController.h
//  SplitView
//
//  Created by Shaohuan Li on 14/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnnotationModel.h"
#import "MasterViewController.h"
#import "MBProgressHUD.h"
#import "baseapi.h"

@interface DetailViewController : UIViewController<UISplitViewControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    tesseract::TessBaseAPI *tess;
    MBProgressHUD *progressHud;
}

@property (nonatomic, strong) UIPopoverController *popoverController;
@property (nonatomic,strong) IBOutlet UIToolbar *toolbar;
@property (nonatomic) UIImage *selectedImg;
@property (nonatomic) tesseract::TessBaseAPI *tess;
@property (strong, nonatomic) IBOutlet UIView *bookView;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) MBProgressHUD *progressHud;

-(void)getAnnotations;
@end
