//
//  FullscreenImageViewController.m
//  RotateTransitionDemo
//
//  Created by Looping on 14/9/23.
//  Copyright (c) 2014年 RidgeCorn. All rights reserved.
//

#import "FullscreenImageViewController.h"

@interface FullscreenImageViewController ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic) UIButton *button;

@end

@implementation FullscreenImageViewController

- (void)viewDidLoad {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];

    [self.view setBackgroundColor:[UIColor whiteColor]];
    CGRect frame = self.view.bounds;
    CGFloat tmp = frame.size.width;
    frame.size.width = frame.size.height;
    frame.size.height = tmp;
    
    _imageView = [[UIImageView alloc] initWithFrame:frame];
    [_imageView setImage:_transitionImageView.image];
    
    [self.view addSubview:_imageView];
    
    _button = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.height - 120, self.view.frame.size.width - 50, 100, 40)];

    [self.view addSubview:_button];
    [_button setBackgroundColor:[UIColor redColor]];
    [_button setTitle:@"关闭" forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:NO completion:^{
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
    }];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

@end
