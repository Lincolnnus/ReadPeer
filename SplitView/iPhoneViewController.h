//
//  iPhoneViewController.h
//  SplitView
//
//  Created by Shaohuan Li on 16/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iPhoneViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITableViewDataSource,UITableViewDelegate>{
}

@property (strong, nonatomic) IBOutlet UIScrollView *bookView;
@property (nonatomic, strong) UIPopoverController *popoverController;
@property (nonatomic) UIImage *selectedImg;
@end
