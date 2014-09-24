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
@property (nonatomic) FullscreenImageViewController *imageViewController;
@property (nonatomic) CGRect bakFrame;
@property (nonatomic) BOOL presenting;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor lightGrayColor]];

    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [_imageView setImage:[UIImage imageNamed:@"avatar"]];
    [self.view addSubview:_imageView];
    [_imageView setCenter:self.view.center];
    _bakFrame = _imageView.frame;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openView:)];
    [self.view addGestureRecognizer:tapGesture];
    
    _presenting = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (_presenting) {
        [self closeAnimation];
        _presenting = NO;
    }
}

- (void)openView:(id)sender {
    if ( !_presenting) {
        _presenting = YES;
        [self openAnimation];

        _imageViewController = [[FullscreenImageViewController alloc] init];
        _imageViewController.transitionImageView = _imageView;
    }
}

- (void)openAnimation {
    CABasicAnimation *center = [CABasicAnimation animationWithKeyPath:@"position"];
    center.fromValue = [NSValue valueWithCGPoint:_imageView.layer.position];
    center.toValue = [NSValue valueWithCGPoint:self.view.center];
    
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"bounds"];
    scale.fromValue = [NSValue valueWithCGRect:_imageView.layer.bounds];
    
    CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform"];
    rotate.fromValue = [NSValue valueWithCATransform3D:_imageView.layer.transform];

    scale.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, self.view.bounds.size.height, self.view.bounds.size.width)];
    
    rotate.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(_imageView.layer.transform, M_PI_2, 0, 0, 1)];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 0.5;
    group.delegate = self;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    group.animations = @[scale,rotate,center];
    [group setValue:@"open" forKey:@"animationType"];
    
    _imageView.layer.position = [center.toValue CGPointValue];
    _imageView.layer.bounds = [scale.toValue CGRectValue];
    _imageView.layer.transform = [rotate.toValue CATransform3DValue];
    [_imageView.layer addAnimation:group forKey:nil];
}

- (void)closeAnimation {
    CABasicAnimation *center = [CABasicAnimation animationWithKeyPath:@"position"];
    center.fromValue = [NSValue valueWithCGPoint:_imageView.layer.position];
    center.toValue = [NSValue valueWithCGPoint:CGPointMake(_bakFrame.origin.x + _bakFrame.size.width / 2, _bakFrame.origin.y + _bakFrame.size.height / 2)];
    
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"bounds"];
    scale.fromValue = [NSValue valueWithCGRect:_imageView.layer.bounds];
    CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform"];
    rotate.fromValue = [NSValue valueWithCATransform3D:_imageView.layer.transform];
    
    scale.toValue = [NSValue valueWithCGRect:_bakFrame];
    
    rotate.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(_imageView.layer.transform, -M_PI_2, 0, 0, 1)];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    group.duration = 0.5;
    group.delegate = self;
    group.animations = @[scale,rotate,center];
    [group setValue:@"close" forKey:@"animationType"];
    
    _imageView.layer.position = [center.toValue CGPointValue];
    _imageView.layer.bounds = [scale.toValue CGRectValue];
    _imageView.layer.transform = [rotate.toValue CATransform3DValue];
    [_imageView.layer addAnimation:group forKey:nil];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if ([[anim valueForKey:@"animationType"] isEqual:@"open"]) {
        [self presentViewController:_imageViewController animated:NO completion:nil];
    }
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate {
    return NO;
}

@end
