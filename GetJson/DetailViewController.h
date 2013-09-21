//
//  DetailViewController.h
//  GetJson
//
//  Created by naotaro on H.25/09/21.
//  Copyright (c) 平成25年 All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
