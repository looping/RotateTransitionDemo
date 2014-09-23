//
//  ViewController.m
//  RotateTransitionDemo
//
//  Created by Looping on 14/9/23.
//  Copyright (c) 2014年 RidgeCorn. All rights reserved.
//

#import "ViewController.h"
#import "FullscreenImageViewController.h"

@interface ViewController ()

@property (nonatomic) UIImageView *imageView;
@property (nonatomic) UIImageView *animationImageView;
@property (nonatomic) FullscreenImageViewController *imageViewController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [_imageView setImage:[UIImage imageNamed:@"avatar"]];
    [self.view addSubview:_imageView];
    [_imageView setCenter:self.view.center];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openView:)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_animationImageView && _animationImageView.superview) {
        [_animationImageView setHidden:NO];

        [self closeAnimation];
    }
}

- (void)openView:(id)sender {
    if ( !(_animationImageView && _animationImageView.superview)) {
        _imageViewController = [[FullscreenImageViewController alloc] init];
        _imageViewController.transitionImageView = _imageView;
        [self presentViewController:_imageViewController animated:NO completion:nil];
        
        [self openAnimation];
    }
}

- (void)openAnimation {
    _animationImageView = [[UIImageView alloc] initWithFrame:_imageView.frame];

    _animationImageView.image = _imageView.image;
    [_imageView setHidden:YES];
    
    [[[UIApplication sharedApplication] keyWindow] addSubview: _animationImageView];
    
    CABasicAnimation *center = [CABasicAnimation animationWithKeyPath:@"position"];
    center.fromValue = [NSValue valueWithCGPoint:_animationImageView.layer.position];
    center.toValue = [NSValue valueWithCGPoint:self.view.center];
    
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"bounds"];
    scale.fromValue = [NSValue valueWithCGRect:_animationImageView.layer.bounds];
    
    CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform"];
    rotate.fromValue = [NSValue valueWithCATransform3D:_animationImageView.layer.transform];
    
    scale.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, self.view.bounds.size.height, self.view.bounds.size.width)];
    
    rotate.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(_animationImageView.layer.transform, M_PI_2, 0, 0, 1)];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 0.5;
    group.delegate = self;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    group.animations = @[scale,rotate,center];
    [group setValue:@"open" forKey:@"animationType"];
    
    _animationImageView.layer.position = [center.toValue CGPointValue];
    _animationImageView.layer.bounds = [scale.toValue CGRectValue];
    _animationImageView.layer.transform = [rotate.toValue CATransform3DValue];
    [_animationImageView.layer addAnimation:group forKey:nil];
}

- (void)closeAnimation {
    CABasicAnimation *center = [CABasicAnimation animationWithKeyPath:@"position"];
    center.fromValue = [NSValue valueWithCGPoint:_animationImageView.layer.position];
    center.toValue = [NSValue valueWithCGPoint:_imageView.center];
    
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"bounds"];
    scale.fromValue = [NSValue valueWithCGRect:_animationImageView.layer.bounds];
    CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform"];
    rotate.fromValue = [NSValue valueWithCATransform3D:_animationImageView.layer.transform];
    
    scale.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, _imageView.frame.size.width, _imageView.frame.size.height)];
    
    rotate.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(_animationImageView.layer.transform, -M_PI_2, 0, 0, 1)];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    group.duration = 0.5;
    group.delegate = self;
    group.animations = @[scale,rotate,center];
    [group setValue:@"close" forKey:@"animationType"];
    
    _animationImageView.layer.position = [center.toValue CGPointValue];
    _animationImageView.layer.bounds = [scale.toValue CGRectValue];
    _animationImageView.layer.transform = [rotate.toValue CATransform3DValue];
    [_animationImageView.layer addAnimation:group forKey:nil];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if ([[anim valueForKey:@"animationType"] isEqual:@"close"]) {
        [_animationImageView removeFromSuperview];
        _animationImageView = nil;
        [_imageView setHidden:NO];
    } else if ([[anim valueForKey:@"animationType"] isEqual:@"open"]) {
        [_animationImageView setHidden:YES];
        [_imageViewController animationStopped];
    }
}

@end
