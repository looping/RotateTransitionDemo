//
//  ViewController.m
//  RotateTransitionDemo
//
//  Created by Looping on 14/9/23.
//  Copyright (c) 2014年 RidgeCorn. All rights reserved.
//

#import "ViewController.h"
#import "FullscreenImageViewController.h"
#import <POP.h>

typedef NS_ENUM(NSUInteger, AnimationType) {
    AnimationTypeBasic = 0,
    AnimationTypeSpring,
};

@interface ViewController ()

@property (nonatomic) UIImageView *imageView;
@property (nonatomic) FullscreenImageViewController *imageViewController;
@property (nonatomic) CGRect bakFrame;
@property (nonatomic) BOOL presenting;
@property (nonatomic) AnimationType animationType;

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
    
    [self.view addSubview:({
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        [button addTarget:self action:@selector(openView:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = AnimationTypeBasic;
        [button setBackgroundColor:[UIColor orangeColor]];
        [button setTitle:@"Basic" forState:UIControlStateNormal];
        [button setCenter:CGPointMake(100, self.view.frame.size.height - 120)];
        button;
    })];
    
    [self.view addSubview:({
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        [button addTarget:self action:@selector(openView:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = AnimationTypeSpring;
        [button setBackgroundColor:[UIColor purpleColor]];
        [button setTitle:@"Spring" forState:UIControlStateNormal];
        [button setCenter:CGPointMake(self.view.frame.size.width - 100, self.view.frame.size.height - 120)];

        button;
    })];
    
    _presenting = NO;
    
    [self.view bringSubviewToFront:_imageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (_presenting) {
        if (_animationType == AnimationTypeBasic) {
            [self closeAnimationBasic];
        } else {
            [self closeAnimationSpring];
        }
        _presenting = NO;
    }
}

- (void)openView:(id)sender {
    if ( !_presenting) {
        _presenting = YES;
        _animationType = [(UIButton *)sender tag];
        if (_animationType == AnimationTypeBasic) {
            [self openAnimationBasic];
        } else {
            [self openAnimationSpring];
        }

        _imageViewController = [[FullscreenImageViewController alloc] init];
        _imageViewController.transitionImageView = _imageView;
    }
}

- (POPBasicAnimation *)basicAnimationToValue:(id)value propertyName:(NSString *)name {
    POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:name];
    animation.toValue = value;
    animation.duration = 0.5f;
    animation.removedOnCompletion = YES;
    
    return animation;
}

- (POPSpringAnimation *)springAnimationToValue:(id)value propertyName:(NSString *)name {
    POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:name];
    animation.toValue = value;
    animation.springBounciness = 8;
    animation.springSpeed = 4;
    animation.removedOnCompletion = YES;
    
    return animation;
}

- (void)openAnimationBasic {
    [_imageView pop_addAnimation:[self basicAnimationToValue:[NSValue valueWithCGPoint:self.view.center] propertyName:kPOPViewCenter] forKey:@"positionAnimation"];
    
    [_imageView pop_addAnimation:[self basicAnimationToValue:[NSValue valueWithCGRect:CGRectMake(0, 0, self.view.bounds.size.height, self.view.bounds.size.width)] propertyName:kPOPViewBounds] forKey:@"boundsAnimation"];

    [_imageView.layer pop_addAnimation:[self basicAnimationToValue:@(M_PI_2) propertyName:kPOPLayerRotation] forKey:@"transformAnimation"];
    
    [[_imageView.layer pop_animationForKey:@"transformAnimation"] setCompletionBlock:^{
        [self presentViewController:_imageViewController animated:NO completion:nil];
    }];
}

- (void)openAnimationSpring {
    [_imageView pop_addAnimation:[self springAnimationToValue:[NSValue valueWithCGPoint:self.view.center] propertyName:kPOPViewCenter] forKey:@"positionAnimation"];
    
    [_imageView pop_addAnimation:[self springAnimationToValue:[NSValue valueWithCGRect:CGRectMake(0, 0, self.view.bounds.size.height, self.view.bounds.size.width)] propertyName:kPOPViewBounds] forKey:@"boundsAnimation"];
    
    [_imageView.layer pop_addAnimation:[self springAnimationToValue:@(M_PI_2) propertyName:kPOPLayerRotation] forKey:@"transformAnimation"];
    
    [[_imageView.layer pop_animationForKey:@"transformAnimation"] setCompletionBlock:^{
        [self presentViewController:_imageViewController animated:NO completion:nil];
    }];
}

- (void)closeAnimationBasic {
    [_imageView pop_addAnimation:[self basicAnimationToValue:[NSValue valueWithCGPoint:CGPointMake(_bakFrame.origin.x + _bakFrame.size.width / 2, _bakFrame.origin.y + _bakFrame.size.height / 2)] propertyName:kPOPViewCenter] forKey:@"positionAnimation"];
    
    [_imageView pop_addAnimation:[self basicAnimationToValue:[NSValue valueWithCGRect:_bakFrame] propertyName:kPOPViewBounds] forKey:@"boundsAnimation"];
    
    [_imageView.layer pop_addAnimation:[self basicAnimationToValue:@(0) propertyName:kPOPLayerRotation] forKey:@"transformAnimation"];
}

- (void)closeAnimationSpring {
    [_imageView pop_addAnimation:[self springAnimationToValue:[NSValue valueWithCGPoint:CGPointMake(_bakFrame.origin.x + _bakFrame.size.width / 2, _bakFrame.origin.y + _bakFrame.size.height / 2)] propertyName:kPOPViewCenter] forKey:@"positionAnimation"];
    
    [_imageView pop_addAnimation:[self springAnimationToValue:[NSValue valueWithCGRect:_bakFrame] propertyName:kPOPViewBounds] forKey:@"boundsAnimation"];
    
    [_imageView.layer pop_addAnimation:[self springAnimationToValue:@(0) propertyName:kPOPLayerRotation] forKey:@"transformAnimation"];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate {
    return NO;
}

@end
