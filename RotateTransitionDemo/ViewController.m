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

- (POPBasicAnimation *)basicAnimationToValue:(id)value duration:(CGFloat)duration propertyName:(NSString *)name {
    POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:name];
    animation.toValue = value;
    animation.duration = duration;
    animation.removedOnCompletion = YES;
    
    return animation;
}

- (void)openAnimation {
    [_imageView pop_addAnimation:[self basicAnimationToValue:[NSValue valueWithCGPoint:self.view.center] duration:0.5 propertyName:kPOPViewCenter] forKey:@"positionAnimation"];
    
    [_imageView pop_addAnimation:[self basicAnimationToValue:[NSValue valueWithCGRect:CGRectMake(0, 0, self.view.bounds.size.height, self.view.bounds.size.width)] duration:0.5 propertyName:kPOPViewBounds] forKey:@"boundsAnimation"];

    [_imageView.layer pop_addAnimation:[self basicAnimationToValue:@(M_PI_2) duration:0.5 propertyName:kPOPLayerRotation] forKey:@"transformAnimation"];
    
    [[_imageView.layer pop_animationForKey:@"transformAnimation"] setCompletionBlock:^{
        [self presentViewController:_imageViewController animated:NO completion:nil];
    }];
}

- (void)closeAnimation {
    [_imageView pop_addAnimation:[self basicAnimationToValue:[NSValue valueWithCGPoint:CGPointMake(_bakFrame.origin.x + _bakFrame.size.width / 2, _bakFrame.origin.y + _bakFrame.size.height / 2)] duration:0.5 propertyName:kPOPViewCenter] forKey:@"positionAnimation"];
    
    [_imageView pop_addAnimation:[self basicAnimationToValue:[NSValue valueWithCGRect:_bakFrame] duration:0.5 propertyName:kPOPViewBounds] forKey:@"boundsAnimation"];
    
    [_imageView.layer pop_addAnimation:[self basicAnimationToValue:@(0) duration:0.5 propertyName:kPOPLayerRotation] forKey:@"transformAnimation"];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate {
    return NO;
}

@end
