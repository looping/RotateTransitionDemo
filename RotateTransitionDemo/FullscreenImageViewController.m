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
    [self.view setBackgroundColor:[UIColor whiteColor]];
    CGRect frame = self.view.bounds;
    CGFloat tmp = frame.size.width;
    frame.size.width = frame.size.height;
    frame.size.height = tmp;
    
    _imageView = [[UIImageView alloc] initWithFrame:frame];
    [_imageView setImage:_transitionImageView.image];
    
    [_imageView setHidden:YES];
    
    [self.view addSubview:_imageView];
    
    _button = [[UIButton alloc] initWithFrame:CGRectMake(-25, self.view.frame.size.height - 100, 100, 40)];
    [_button setHidden:YES];
    [self.view addSubview:_button];
    [_button setBackgroundColor:[UIColor redColor]];
    [_button setTitle:@"关闭" forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    _imageView.layer.position = self.view.layer.position;
    CGAffineTransform rotation = CGAffineTransformMakeRotation(M_PI_2);
    _imageView.layer.transform = CATransform3DIdentity;
    [_imageView setTransform:rotation];
    [_button setTransform:rotation];
}

- (void)animationStopped {
    [_imageView setHidden:NO];
    [_button setHidden:NO];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
