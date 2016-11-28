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
#import "NLDynamicPropertyPrefix.h"

DynamicPropertySetPrefix("demo_");



@interface NLUIViewController : ViewController

@end

@interface ViewController (demo_ex)

@property (nonatomic, assign) int demo_int;
@property (nonatomic, strong) id demo_object;
@property (nonatomic, assign) BOOL demo_bool;
@property (nonatomic, assign) char demo_char;
@property (nonatomic, assign) float demo_float;
@property (nonatomic, assign) double demo_double;
@property (nonatomic, assign) long demo_long;
@property (nonatomic, assign) uint demo_uint;

@property (nonatomic, assign) CGRect demo_rect;
@property (nonatomic, assign) CGPoint demo_point;
@property (nonatomic, assign) CGSize demo_size;
@property (nonatomic, assign) CGVector demo_vector;
@property (nonatomic, assign) CGAffineTransform demo_affineTransform;
@property (nonatomic, assign) UIEdgeInsets demo_edgeInsets;
@property (nonatomic, assign) UIOffset demo_offset;
@property (nonatomic, assign) CATransform3D demo_transform3D;


@property (nonatomic, assign) CMTime demo_cmtime;
@property (nonatomic, assign) CMTimeRange demo_cmtimeRange;
@property (nonatomic, assign) CMTimeMapping demo_cmtimeMapping;

@property (nonatomic, assign) CLLocationCoordinate2D demo_coordinate;
@property (nonatomic, assign) MKCoordinateSpan demo_coordinateSpan;

@property (nonatomic, assign) SCNVector3 demo_scnvector3;
@property (nonatomic, assign) SCNVector4 demo_scnvector4;
@property (nonatomic, assign) SCNMatrix4 demo_matrix4;

@property (nonatomic, copy) void (^demo_copyBlock)(void);
@property (nonatomic, weak) id demo_weakObject;

@property (nonatomic, strong) id demo_strongObject;

@end

@interface ViewController ()

@property (nonatomic, strong) id obj;

@property (nonatomic, strong) NLUIViewController *subVC;
@end

@implementation ViewController

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
  id value = [object valueForKeyPath:keyPath];
  fprintf(stdout, "observe %s = %s\n", [keyPath cStringUsingEncoding:NSUTF8StringEncoding], [[value description] cStringUsingEncoding:NSUTF8StringEncoding]);
}


- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self addObserver:self forKeyPath:@"demo_int" options:NSKeyValueObservingOptionNew context:nil];
  [self addObserver:self forKeyPath:@"demo_object" options:NSKeyValueObservingOptionNew context:nil];
  [self addObserver:self forKeyPath:@"demo_bool" options:NSKeyValueObservingOptionNew context:nil];
  [self addObserver:self forKeyPath:@"demo_char" options:NSKeyValueObservingOptionNew context:nil];
  [self addObserver:self forKeyPath:@"demo_float" options:NSKeyValueObservingOptionNew context:nil];
  [self addObserver:self forKeyPath:@"demo_double" options:NSKeyValueObservingOptionNew context:nil];
  [self addObserver:self forKeyPath:@"demo_long" options:NSKeyValueObservingOptionNew context:nil];
  [self addObserver:self forKeyPath:@"demo_uint" options:NSKeyValueObservingOptionNew context:nil];
  [self addObserver:self forKeyPath:@"demo_point" options:NSKeyValueObservingOptionNew context:nil];
  [self addObserver:self forKeyPath:@"demo_rect" options:NSKeyValueObservingOptionNew context:nil];
  [self addObserver:self forKeyPath:@"demo_size" options:NSKeyValueObservingOptionNew context:nil];
  [self addObserver:self forKeyPath:@"demo_vector" options:NSKeyValueObservingOptionNew context:nil];
  [self addObserver:self forKeyPath:@"demo_offset" options:NSKeyValueObservingOptionNew context:nil];
  [self addObserver:self forKeyPath:@"demo_edgeInsets" options:NSKeyValueObservingOptionNew context:nil];
  [self addObserver:self forKeyPath:@"demo_affineTransform" options:NSKeyValueObservingOptionNew context:nil];
  [self addObserver:self forKeyPath:@"demo_transform3D" options:NSKeyValueObservingOptionNew context:nil];
  /**
   *  @brief 注意，当观察动态生成的 weak 属性时，不会接收到 weak 自动设置为 nil 的通知（在 weak 指向的对象被
   *         销毁时，weak 属性会自动设置为 nil）。
   */
  [self addObserver:self forKeyPath:@"demo_weakObject" options:NSKeyValueObservingOptionNew context:nil];
  [self addObserver:self forKeyPath:@"demo_copyBlock" options:NSKeyValueObservingOptionNew context:nil];
  [self addObserver:self forKeyPath:@"demo_coordinate" options:NSKeyValueObservingOptionNew context:nil];
  [self addObserver:self forKeyPath:@"demo_coordinateSpan" options:NSKeyValueObservingOptionNew context:nil];
  [self addObserver:self forKeyPath:@"demo_cmtime" options:NSKeyValueObservingOptionNew context:nil];
  [self addObserver:self forKeyPath:@"demo_cmtimeRange" options:NSKeyValueObservingOptionNew context:nil];
  [self addObserver:self forKeyPath:@"demo_scnvector3" options:NSKeyValueObservingOptionNew context:nil];
  [self addObserver:self forKeyPath:@"demo_scnvector4" options:NSKeyValueObservingOptionNew context:nil];
  [self addObserver:self forKeyPath:@"demo_matrix4" options:NSKeyValueObservingOptionNew context:nil];
  [self addObserver:self forKeyPath:@"demo_strongObject" options:NSKeyValueObservingOptionNew context:nil];
  
  
  self.subVC = [NLUIViewController new];
  self.subVC.demo_int = 30;
  self.subVC.demo_object = [UIView new];
  [self setValue:@40 forKeyPath:@"subVC.demo_int"];
  
  self.demo_int = 20;
  self.demo_object = [UIView new];
  [self setValue:@34 forKey:@"demo_int"];
  [self setValue:@"new demo_object string" forKey:@"demo_object"];
  
  self.demo_bool = YES;
  self.demo_char = 'c';
  self.demo_float = 32.2;
  self.demo_double = 51351654411243.3;
  self.demo_long = 31124L;
  self.demo_uint = 24;
  
  self.demo_rect = CGRectMake(10, 10, 100, 100);
  [self setValue:[NSValue valueWithCGRect:CGRectMake(0, 0, 200, 200)] forKey:@"demo_rect"];
  
  self.demo_point = CGPointMake(10, 10);
  self.demo_size = CGSizeMake(100, 100);
  self.demo_vector = CGVectorMake(20.0, 20.0);
  self.demo_offset = UIOffsetMake(10.0, 20.0);
  self.demo_edgeInsets = UIEdgeInsetsMake(10, 20, 30, 40);
  self.demo_affineTransform = CGAffineTransformMake(1.0, 2.0, 3.0, 4.0, 5.0, 6.0);
  self.demo_transform3D = CATransform3DMakeRotation(90, 1, 1, 1);
  
  UIButton *tempButton = [UIButton new];
  self.obj = tempButton;
  self.demo_weakObject = self.obj;
  self.demo_strongObject = [NSObject new];
  self.demo_copyBlock = ^{
    fprintf(stdout, "demo_object: just printf call copy block\n");
  };
  
  self.demo_coordinate = CLLocationCoordinate2DMake(21.016f, 135.05135f);
  self.demo_coordinateSpan = MKCoordinateSpanMake(32.51f, 145.6156f);
  // KVC
  [self setValue:[NSValue valueWithMKCoordinate:CLLocationCoordinate2DMake(32.051f, 154.053f)] forKey:@"demo_coordinate"];
  
  self.demo_cmtime = CMTimeMake(1000, 24);
  self.demo_cmtimeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithEpoch(2400, 24, 0));
  
  CMTimeRange timeRangeTarget = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithEpoch(3600, 12, 0));
  CMTimeMapping timeMapping = {self.demo_cmtimeRange, timeRangeTarget};
  self.demo_cmtimeMapping = timeMapping;
  
  self.demo_scnvector3 = SCNVector3Make(1.f, 2.f, 3.f);
  self.demo_scnvector4 = SCNVector4Make(4.f, 6.f, 8.f, 10.f);
  self.demo_matrix4 = SCNMatrix4MakeScale(1.0, 1.0, 1.0);
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  self.obj = nil;
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  fprintf(stdout, "\nsub class demo_int = %d\n", self.subVC.demo_int);
  fprintf(stdout, "sub class demo_object = %s\n\n", [[self.subVC.demo_object description] cStringUsingEncoding:NSUTF8StringEncoding]);
  
  fprintf(stdout, "demo_int = %d\n", self.demo_int);
  fprintf(stdout, "demo_object = %s\n", [[self.demo_object description] cStringUsingEncoding:NSUTF8StringEncoding]);
  fprintf(stdout, "demo_bool = %d\n", self.demo_bool);
  fprintf(stdout, "demo_char = %c\n", self.demo_char);
  fprintf(stdout, "demo_float = %f\n", self.demo_float);
  fprintf(stdout, "demo_double = %f\n", self.demo_double);
  fprintf(stdout, "demo_long = %ld\n", self.demo_long);
  fprintf(stdout, "demo_uint = %d\n", self.demo_uint);
  
  fprintf(stdout, "demo_rect = %s\n", [NSStringFromCGRect(self.demo_rect) cStringUsingEncoding:NSUTF8StringEncoding]);
  fprintf(stdout, "demo_point = %s\n", [NSStringFromCGPoint(self.demo_point) cStringUsingEncoding:NSUTF8StringEncoding]);
  fprintf(stdout, "demo_size = %s\n", [NSStringFromCGSize(self.demo_size) cStringUsingEncoding:NSUTF8StringEncoding]);
  fprintf(stdout, "demo_vector = %s\n", [NSStringFromCGVector(self.demo_vector) cStringUsingEncoding:NSUTF8StringEncoding]);
  fprintf(stdout, "demo_offset = %s\n", [NSStringFromUIOffset(self.demo_offset) cStringUsingEncoding:NSUTF8StringEncoding]);
  fprintf(stdout, "demo_edgeInsets = %s\n", [NSStringFromUIEdgeInsets(self.demo_edgeInsets) cStringUsingEncoding:NSUTF8StringEncoding]);
  fprintf(stdout, "demo_affineTransform = %s\n", [NSStringFromCGAffineTransform(self.demo_affineTransform) cStringUsingEncoding:NSUTF8StringEncoding]);
  fprintf(stdout, "demo_transform3D is equal CATransform3DMakeRotation(90, 1, 1, 1) = %s\n", CATransform3DEqualToTransform(self.demo_transform3D, CATransform3DMakeRotation(90, 1, 1, 1)) ? "YES" : "NO");
  
  fprintf(stdout, "demo_weakObject = %s\n", [[self.demo_weakObject description] cStringUsingEncoding:NSUTF8StringEncoding]);
  
  
  self.demo_copyBlock();
  
  fprintf(stdout, "demo_coordinate = {%f, %f}\n", self.demo_coordinate.latitude, self.demo_coordinate.longitude);
  fprintf(stdout, "demo_coordinateSpan = {%f, %f}\n", self.demo_coordinateSpan.latitudeDelta, self.demo_coordinateSpan.longitudeDelta);
  
  fprintf(stdout, "demo_cmtime = ");
  CMTimeShow(self.demo_cmtime);
  
  fprintf(stdout, "demo_cmtimeRange = ");
  CMTimeRangeShow(self.demo_cmtimeRange);
  
  CFStringRef sourceStringRef = CMTimeRangeCopyDescription(CFAllocatorGetDefault(), self.demo_cmtimeMapping.source);
  CFStringRef targetStringRef = CMTimeRangeCopyDescription(CFAllocatorGetDefault(), self.demo_cmtimeMapping.target);
  fprintf(stdout, "demo_cmtimeMapping = {%s,%s}\n", [((__bridge NSString *)sourceStringRef) cStringUsingEncoding:NSUTF8StringEncoding], [((__bridge NSString *)targetStringRef) cStringUsingEncoding:NSUTF8StringEncoding]);
  
  fprintf(stdout, "demo_scnvector3 = {%f, %f, %f}\n", self.demo_scnvector3.x, self.demo_scnvector3.y, self.demo_scnvector3.z);
  fprintf(stdout, "demo_scnvector4 = {%f, %f, %f, %f}\n", self.demo_scnvector4.x, self.demo_scnvector4.y, self.demo_scnvector4.z, self.demo_scnvector4.w);
  fprintf(stdout, "demo_matrix4 is equal SCNMatrix4MakeScale(1.0, 1.0, 1.0) = %s\n", SCNMatrix4EqualToMatrix4(self.demo_matrix4, SCNMatrix4MakeScale(1.0, 1.0, 1.0)) ? "YES" : "NO");
  
  fprintf(stdout, "demo_strongObject = {%s}\n", [[self.demo_strongObject description] cStringUsingEncoding:NSUTF8StringEncoding]);
  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    self.demo_strongObject = nil;
    self.demo_weakObject = nil;
  });
}

@end



@implementation ViewController (demo_ex)

@dynamic demo_uint;
@dynamic demo_long;
@dynamic demo_double;
@dynamic demo_float;
@dynamic demo_char;
@dynamic demo_bool;
@dynamic demo_object;
@dynamic demo_int;

@dynamic demo_rect;
@dynamic demo_point;
@dynamic demo_size;
@dynamic demo_affineTransform;
@dynamic demo_vector;
@dynamic demo_offset;
@dynamic demo_transform3D;
@dynamic demo_edgeInsets;

@dynamic demo_cmtime;
@dynamic demo_cmtimeMapping;
@dynamic demo_cmtimeRange;

@dynamic demo_coordinate;
@dynamic demo_coordinateSpan;

@dynamic demo_copyBlock;
@dynamic demo_weakObject;
@dynamic demo_strongObject;

@dynamic demo_matrix4;
@dynamic demo_scnvector4;
@dynamic demo_scnvector3;

@end



@implementation NLUIViewController

@end
