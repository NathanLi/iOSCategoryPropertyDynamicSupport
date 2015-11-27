//
//  ViewController.m
//  NLActivityDemo
//
//  Created by 听榆大叔 on 15/10/20.
//  Copyright © 2015年 NL. All rights reserved.
//

#import "ViewController.h"
@import AVFoundation;
@import MapKit;
@import SceneKit;
@import CoreMedia;
#import <MapKit/MKGeometry.h>
#import <CoreMedia/CMTimeRange.h>

@interface NLUIViewController : ViewController

@end

@interface ViewController (nl_ex)

@property (nonatomic, assign) int nl_int;
@property (nonatomic, strong) id nl_object;
@property (nonatomic, assign) BOOL nl_bool;
@property (nonatomic, assign) char nl_char;
@property (nonatomic, assign) float nl_float;
@property (nonatomic, assign) double nl_double;
@property (nonatomic, assign) long nl_long;
@property (nonatomic, assign) uint nl_uint;

@property (nonatomic, assign) CGRect nl_rect;
@property (nonatomic, assign) CGPoint nl_point;
@property (nonatomic, assign) CGSize nl_size;
@property (nonatomic, assign) CGVector nl_vector;
@property (nonatomic, assign) CGAffineTransform nl_affineTransform;
@property (nonatomic, assign) UIEdgeInsets nl_edgeInsets;
@property (nonatomic, assign) UIOffset nl_offset;
@property (nonatomic, assign) CATransform3D nl_transform3D;


@property (nonatomic, assign) CMTime nl_cmtime;
@property (nonatomic, assign) CMTimeRange nl_cmtimeRange;
@property (nonatomic, assign) CMTimeMapping nl_cmtimeMapping;

@property (nonatomic, assign) CLLocationCoordinate2D nl_coordinate;
@property (nonatomic, assign) MKCoordinateSpan nl_coordinateSpan;

@property (nonatomic, assign) SCNVector3 nl_scnvector3;
@property (nonatomic, assign) SCNVector4 nl_scnvector4;
@property (nonatomic, assign) SCNMatrix4 nl_matrix4;

@property (nonatomic, copy) void (^nl_copyBlock)(void);
@property (nonatomic, weak) id nl_weakObject;

@end

@interface ViewController ()

@property (nonatomic, assign) int intB;
@property (nonatomic, copy) UIView *viewString;
@property (nonatomic, strong) id obj;

@property (nonatomic, strong) NLUIViewController *subVC;

@property id name;
@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  // do not support KVO
//  [self addObserver:self forKeyPath:@"nl_int" options:NSKeyValueObservingOptionNew context:nil];
  
  self.subVC = [NLUIViewController new];
  self.subVC.nl_int = 30;
  self.subVC.nl_object = [UIView new];
  [self setValue:@40 forKeyPath:@"subVC.nl_int"];
  
  self.nl_int = 20;
  self.nl_object = [UIView new];
  [self setValue:@34 forKey:@"nl_int"];
  [self setValue:@"new nl_object string" forKey:@"nl_object"];
  
  self.nl_bool = YES;
  self.nl_char = 'c';
  self.nl_float = 32.2;
  self.nl_double = 51351654411243.3;
  self.nl_long = 31124L;
  self.nl_uint = 24;
  
  self.nl_rect = CGRectMake(10, 10, 100, 100);
  [self setValue:[NSValue valueWithCGRect:CGRectMake(0, 0, 200, 200)] forKey:@"nl_rect"];
  
  self.nl_point = CGPointMake(10, 10);
  self.nl_size = CGSizeMake(100, 100);
  self.nl_vector = CGVectorMake(20.0, 20.0);
  self.nl_offset = UIOffsetMake(10.0, 20.0);
  self.nl_edgeInsets = UIEdgeInsetsMake(10, 20, 30, 40);
  self.nl_affineTransform = CGAffineTransformMake(1.0, 2.0, 3.0, 4.0, 5.0, 6.0);
  self.nl_transform3D = CATransform3DMakeRotation(90, 1, 1, 1);
  
  UIButton *tempButton = [UIButton new];
  self.obj = tempButton;
  self.nl_weakObject = self.obj;
  self.nl_copyBlock = ^{
    fprintf(stdout, "nl_object: just printf call copy block\n");
  };
  
  self.nl_coordinate = CLLocationCoordinate2DMake(21.016f, 135.05135f);
  self.nl_coordinateSpan = MKCoordinateSpanMake(32.51f, 145.6156f);
  // KVC
  [self setValue:[NSValue valueWithMKCoordinate:CLLocationCoordinate2DMake(32.051f, 154.053f)] forKey:@"nl_coordinate"];
  
  self.nl_cmtime = CMTimeMake(1000, 24);
  self.nl_cmtimeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithEpoch(2400, 24, 0));
  
  CMTimeRange timeRangeTarget = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithEpoch(3600, 12, 0));
  CMTimeMapping timeMapping = {self.nl_cmtimeRange, timeRangeTarget};
  self.nl_cmtimeMapping = timeMapping;
  
  self.nl_scnvector3 = SCNVector3Make(1.f, 2.f, 3.f);
  self.nl_scnvector4 = SCNVector4Make(4.f, 6.f, 8.f, 10.f);
  self.nl_matrix4 = SCNMatrix4MakeScale(1.0, 1.0, 1.0);
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  self.obj = nil;
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  fprintf(stdout, "\nsub class nl_int = %d\n", self.subVC.nl_int);
  fprintf(stdout, "sub class nl_object = %s\n\n", [[self.subVC.nl_object description] cStringUsingEncoding:NSUTF8StringEncoding]);
  
  fprintf(stdout, "nl_int = %d\n", self.nl_int);
  fprintf(stdout, "nl_object = %s\n", [[self.nl_object description] cStringUsingEncoding:NSUTF8StringEncoding]);
  fprintf(stdout, "nl_bool = %d\n", self.nl_bool);
  fprintf(stdout, "nl_char = %c\n", self.nl_char);
  fprintf(stdout, "nl_float = %f\n", self.nl_float);
  fprintf(stdout, "nl_double = %f\n", self.nl_double);
  fprintf(stdout, "nl_long = %ld\n", self.nl_long);
  fprintf(stdout, "nl_uint = %d\n", self.nl_uint);
  
  fprintf(stdout, "nl_rect = %s\n", [NSStringFromCGRect(self.nl_rect) cStringUsingEncoding:NSUTF8StringEncoding]);
  fprintf(stdout, "nl_point = %s\n", [NSStringFromCGPoint(self.nl_point) cStringUsingEncoding:NSUTF8StringEncoding]);
  fprintf(stdout, "nl_size = %s\n", [NSStringFromCGSize(self.nl_size) cStringUsingEncoding:NSUTF8StringEncoding]);
  fprintf(stdout, "nl_vector = %s\n", [NSStringFromCGVector(self.nl_vector) cStringUsingEncoding:NSUTF8StringEncoding]);
  fprintf(stdout, "nl_offset = %s\n", [NSStringFromUIOffset(self.nl_offset) cStringUsingEncoding:NSUTF8StringEncoding]);
  fprintf(stdout, "nl_edgeInsets = %s\n", [NSStringFromUIEdgeInsets(self.nl_edgeInsets) cStringUsingEncoding:NSUTF8StringEncoding]);
  fprintf(stdout, "nl_affineTransform = %s\n", [NSStringFromCGAffineTransform(self.nl_affineTransform) cStringUsingEncoding:NSUTF8StringEncoding]);
  fprintf(stdout, "nl_transform3D is equal CATransform3DMakeRotation(90, 1, 1, 1) = %s\n", CATransform3DEqualToTransform(self.nl_transform3D, CATransform3DMakeRotation(90, 1, 1, 1)) ? "YES" : "NO");
  
  fprintf(stdout, "nl_weakObject = %s\n", [[self.nl_weakObject description] cStringUsingEncoding:NSUTF8StringEncoding]);
  
  
  self.nl_copyBlock();
  
  fprintf(stdout, "nl_coordinate = {%f, %f}\n", self.nl_coordinate.latitude, self.nl_coordinate.longitude);
  fprintf(stdout, "nl_coordinateSpan = {%f, %f}\n", self.nl_coordinateSpan.latitudeDelta, self.nl_coordinateSpan.longitudeDelta);
  
  fprintf(stdout, "nl_cmtime = ");
  CMTimeShow(self.nl_cmtime);
  
  fprintf(stdout, "nl_cmtimeRange = ");
  CMTimeRangeShow(self.nl_cmtimeRange);
  
  CFStringRef sourceStringRef = CMTimeRangeCopyDescription(CFAllocatorGetDefault(), self.nl_cmtimeMapping.source);
  CFStringRef targetStringRef = CMTimeRangeCopyDescription(CFAllocatorGetDefault(), self.nl_cmtimeMapping.target);
  fprintf(stdout, "nl_cmtimeMapping = {%s,%s}\n", [((__bridge NSString *)sourceStringRef) cStringUsingEncoding:NSUTF8StringEncoding], [((__bridge NSString *)targetStringRef) cStringUsingEncoding:NSUTF8StringEncoding]);
  
  fprintf(stdout, "nl_scnvector3 = {%f, %f, %f}\n", self.nl_scnvector3.x, self.nl_scnvector3.y, self.nl_scnvector3.z);
  fprintf(stdout, "nl_scnvector4 = {%f, %f, %f, %f}\n", self.nl_scnvector4.x, self.nl_scnvector4.y, self.nl_scnvector4.z, self.nl_scnvector4.w);
  fprintf(stdout, "nl_matrix4 is equal SCNMatrix4MakeScale(1.0, 1.0, 1.0) = %s\n", SCNMatrix4EqualToMatrix4(self.nl_matrix4, SCNMatrix4MakeScale(1.0, 1.0, 1.0)) ? "YES" : "NO");
}

@end



@implementation ViewController (nl_ex)

@dynamic nl_uint;
@dynamic nl_long;
@dynamic nl_double;
@dynamic nl_float;
@dynamic nl_char;
@dynamic nl_bool;
@dynamic nl_object;
@dynamic nl_int;

@dynamic nl_rect;
@dynamic nl_point;
@dynamic nl_size;
@dynamic nl_affineTransform;
@dynamic nl_vector;
@dynamic nl_offset;
@dynamic nl_transform3D;
@dynamic nl_edgeInsets;

@dynamic nl_cmtime;
@dynamic nl_cmtimeMapping;
@dynamic nl_cmtimeRange;

@dynamic nl_coordinate;
@dynamic nl_coordinateSpan;

@dynamic nl_copyBlock;
@dynamic nl_weakObject;

@dynamic nl_matrix4;
@dynamic nl_scnvector4;
@dynamic nl_scnvector3;

@end



@implementation NLUIViewController

@end
