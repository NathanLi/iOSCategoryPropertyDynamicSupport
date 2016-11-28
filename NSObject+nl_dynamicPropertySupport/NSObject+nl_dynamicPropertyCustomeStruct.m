//
//  NSObject+nl_dynamicPropertyPrivate.m
//  CategoryPropertyDynamicSupport
//
//  Created by 听榆大叔 on 15/11/24.
//  Copyright © 2015年 NL. All rights reserved.
//

#import "NSObject+nl_dynamicPropertyCustomeStruct.h"
#import "NSObject+nl_dynamicPropertyStore.h"
#import "NLPropertyDescriptor.h"
#import "NSObject+nl_dynamicPropertySupport.h"
#import <objc/runtime.h>
#import "NLDynamicPropertyPrefix.h"

typedef int64_t NLCMTimeValue;
typedef int32_t NLCMTimeScale;
typedef CF_OPTIONS( uint32_t, NLCMTimeFlags ) {
  kCMTimeFlags_Valid = 1UL<<0,
  kCMTimeFlags_HasBeenRounded = 1UL<<1,
  kCMTimeFlags_PositiveInfinity = 1UL<<2,
  kCMTimeFlags_NegativeInfinity = 1UL<<3,
  kCMTimeFlags_Indefinite = 1UL<<4,
  kCMTimeFlags_ImpliedValueFlagsMask = kCMTimeFlags_PositiveInfinity | kCMTimeFlags_NegativeInfinity | kCMTimeFlags_Indefinite
};
typedef int64_t NLCMTimeEpoch;

typedef struct
{
  NLCMTimeValue	value;
  NLCMTimeScale	timescale;
  NLCMTimeFlags	flags;
  NLCMTimeEpoch	epoch;
} NLCMTime;  // simulate for CMTime


typedef struct
{
  NLCMTime			start;
  NLCMTime			duration;
} NLCMTimeRange; // simulate for CMTimeRange

typedef struct
{
  NLCMTimeRange source;
  NLCMTimeRange target;
} NLCMTimeMapping; // simulate for CMTimeMapping

typedef double NLCLLocationDegrees;
typedef struct {
  NLCLLocationDegrees latitude;
  NLCLLocationDegrees longitude;
} NLCLLocationCoordinate2D; // simulate for CLLocationCoordinate2D

typedef struct {
  NLCLLocationDegrees latitudeDelta;
  NLCLLocationDegrees longitudeDelta;
} NLMKCoordinateSpan; // simulate for MKCoordinateSpan

typedef struct {
  float x, y, z;
} NLSCNVector3; // simulate for SCNVector3

typedef struct {
  float x, y, z, w;
} NLSCNVector4; // simuate for SCNVector4

typedef struct {
  float m11, m12, m13, m14;
  float m21, m22, m23, m24;
  float m31, m32, m33, m34;
  float m41, m42, m43, m44;
} NLSCNMatrix4; // simuate for SCNMatrix4

@interface NSValue (nl_NSValueMapKitAndAVFoundationAndSceneKitNLDynamicPropertySupport)

+ (NSValue *)valueWithNLCLLocationCoordinate2D:(NLCLLocationCoordinate2D)NLCLLocationCoordinate2D;
+ (NSValue *)valueWithNLMKCoordinateSpan:(NLMKCoordinateSpan)span;

@property (readonly) NLCLLocationCoordinate2D NLCLLocationCoordinate2DValue;
@property (readonly) NLMKCoordinateSpan NLMKCoordinateSpanValue;

+ (NSValue *)valueWithNLCMTime:(NLCMTime)time NS_AVAILABLE(10_7, 4_0);
@property (readonly) NLCMTime NLCMTimeValue NS_AVAILABLE(10_7, 4_0);

+ (NSValue *)valueWithNLCMTimeRange:(NLCMTimeRange)timeRange NS_AVAILABLE(10_7, 4_0);
@property (readonly) NLCMTimeRange NLCMTimeRangeValue NS_AVAILABLE(10_7, 4_0);

+ (NSValue *)valueWithNLCMTimeMapping:(NLCMTimeMapping)timeMapping NS_AVAILABLE(10_7, 4_0);
@property (readonly) NLCMTimeMapping NLCMTimeMappingValue NS_AVAILABLE(10_7, 4_0);

/**
 *  @brief  SceneKitAdditions
 */
+ (NSValue *)valueWithNLSCNVector3:(NLSCNVector3)v;
+ (NSValue *)valueWithNLSCNVector4:(NLSCNVector4)v;
+ (NSValue *)valueWithNLSCNMatrix4:(NLSCNMatrix4)v;

@property(nonatomic, readonly) NLSCNVector3 NLSCNVector3Value;
@property(nonatomic, readonly) NLSCNVector4 NLSCNVector4Value;
@property(nonatomic, readonly) NLSCNMatrix4 NLSCNMatrix4Value;

@end

@implementation NSValue (nl_NSValueMapKitAndAVFoundationNLDynamicPropertySupport)

+ (NSValue *)valueWithNLCLLocationCoordinate2D:(NLCLLocationCoordinate2D)coordinate {
  return [self valueWithBytes:&coordinate objCType:@encode(NLCLLocationCoordinate2D)];
}

+ (NSValue *)valueWithNLMKCoordinateSpan:(NLMKCoordinateSpan)span {
  return [self valueWithBytes:&span objCType:@encode(NLMKCoordinateSpan)];
}

- (NLCLLocationCoordinate2D)NLCLLocationCoordinate2DValue {
  NLCLLocationCoordinate2D value;
  [self getValue:&value];
  return value;
}

- (NLMKCoordinateSpan)NLMKCoordinateSpanValue {
  NLMKCoordinateSpan value;
  [self getValue:&value];
  return value;
}

+ (NSValue *)valueWithNLCMTime:(NLCMTime)time {
  return [self valueWithBytes:&time objCType:@encode(NLCMTime)];
}

- (NLCMTime)NLCMTimeValue {
  NLCMTime value;
  [self getValue:&value];
  return value;
}

+ (NSValue *)valueWithNLCMTimeRange:(NLCMTimeRange)timeRange NS_AVAILABLE(10_7, 4_0) {
  return [self valueWithBytes:&timeRange objCType:@encode(NLCMTimeRange)];
}

- (NLCMTimeRange)NLCMTimeRangeValue {
  NLCMTimeRange value;
  [self getValue:&value];
  return value;
}

+ (NSValue *)valueWithNLCMTimeMapping:(NLCMTimeMapping)timeMapping NS_AVAILABLE(10_7, 4_0) {
  return [self valueWithBytes:&timeMapping objCType:@encode(NLCMTimeMapping)];
}

- (NLCMTimeMapping)NLCMTimeMappingValue {
  NLCMTimeMapping value;
  [self getValue:&value];
  return value;
}

+ (NSValue *)valueWithNLSCNVector3:(NLSCNVector3)v {
  return [self valueWithBytes:&v objCType:@encode(NLSCNVector3)];
}
+ (NSValue *)valueWithNLSCNVector4:(NLSCNVector4)v {
  return [self valueWithBytes:&v objCType:@encode(NLSCNVector4)];
}
+ (NSValue *)valueWithNLSCNMatrix4:(NLSCNMatrix4)v {
  return [self valueWithBytes:&v objCType:@encode(NLSCNMatrix4)];
}

- (NLSCNVector3)NLSCNVector3Value {
  NLSCNVector3 value;
  [self getValue:&value];
  return value;
}
- (NLSCNVector4)NLSCNVector4Value {
  NLSCNVector4 value;
  [self getValue:&value];
  return value;
}
- (NLSCNMatrix4)NLSCNMatrix4Value {
  NLSCNMatrix4 value;
  [self getValue:&value];
  return value;
}

@end


#define NLDynamicIMPNameGetterCustomeStructType(typeName) __NL__##typeName##__custome_dynamicGetterIMP
#define NLDynamicIMPNameSetterCustomeStructType(typeName) __NL__##typeName##__custome_dynamicSetterIMP

#define NLDefineDynamicIMPGetterCustomeStructType(typeName) \
typeName NLDynamicIMPNameGetterCustomeStructType(typeName)(id self, SEL _cmd) {\
NSString *propertyName = [[self class] nl_dynamicPropertyNameWithSelctor:_cmd];\
return [[[self nl_dynamicPropertyDictionary] objectForKey:propertyName] typeName##Value];\
}

#define NLDefineDynamicIMPSetterCustomeStructType(typeName) \
void NLDynamicIMPNameSetterCustomeStructType(typeName)(id self, SEL _cmd, typeName arg) {\
NSString *propertyName = [[self class] nl_dynamicPropertyNameWithSelctor:_cmd];\
[self willChangeValueForKey:propertyName];\
[[self nl_dynamicPropertyDictionary] setObject:[NSValue valueWith##typeName:arg] forKey:propertyName];\
[self didChangeValueForKey:propertyName];\
}

#define NLDefineDynamicIMPCustomeStructType(typeName) \
NLDefineDynamicIMPGetterCustomeStructType(typeName);\
NLDefineDynamicIMPSetterCustomeStructType(typeName);

NLDefineDynamicIMPCustomeStructType(NLCLLocationCoordinate2D);
NLDefineDynamicIMPCustomeStructType(NLMKCoordinateSpan);
NLDefineDynamicIMPCustomeStructType(NLCMTime);
NLDefineDynamicIMPCustomeStructType(NLCMTimeRange);
NLDefineDynamicIMPCustomeStructType(NLCMTimeMapping);
NLDefineDynamicIMPCustomeStructType(NLSCNVector3);
NLDefineDynamicIMPCustomeStructType(NLSCNVector4);
NLDefineDynamicIMPCustomeStructType(NLSCNMatrix4);

@interface NLPropertyDescriptor (nl_customeStruct)

- (BOOL)nl_isNLCLLocationCoordinate2D;
- (BOOL)nl_isNLMKCoordinateSpan;
- (BOOL)nl_isNLCMTime;
- (BOOL)nl_isNLCMTimeRange;
- (BOOL)nl_isNLCMTimeMapping;
- (BOOL)nl_isNLSCNVector3;
- (BOOL)nl_isNLSCNVector4;
- (BOOL)nl_isNLSCNMatrix4;

- (NSString *)nl_anonymityPropertyEncode;

@end

@implementation NLPropertyDescriptor (nl_customeStruct)

- (NSString *)nl_anonymityPropertyEncode {
  NSString *propertyEncode = objc_getAssociatedObject(self, _cmd);
  
  if (propertyEncode == nil) {
    propertyEncode = [self.typeEncoding stringByReplacingOccurrencesOfString:@"\\{\\w+=" withString:@"{?=" options:NSRegularExpressionSearch range:NSMakeRange(0, [self.typeEncoding length])];
    if ([propertyEncode hasPrefix:@"T"]) {
      propertyEncode = [propertyEncode substringFromIndex:1];
    }
    objc_setAssociatedObject(self, _cmd, propertyEncode, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  }
  return propertyEncode;
}

- (BOOL)nl_isNLCLLocationCoordinate2D {
  return [[self nl_anonymityPropertyEncode] isEqualToString:[NSString stringWithCString:@encode(NLCLLocationCoordinate2D) encoding:NSUTF8StringEncoding]];
}

- (BOOL)nl_isNLMKCoordinateSpan {
  return [[self nl_anonymityPropertyEncode] isEqualToString:[NSString stringWithCString:@encode(NLMKCoordinateSpan) encoding:NSUTF8StringEncoding]];
}

- (BOOL)nl_isNLCMTime {
  return [[self nl_anonymityPropertyEncode] isEqualToString:[NSString stringWithCString:@encode(NLCMTime) encoding:NSUTF8StringEncoding]];
}

- (BOOL)nl_isNLCMTimeRange {
  return [[self nl_anonymityPropertyEncode] isEqualToString:[NSString stringWithCString:@encode(NLCMTimeRange) encoding:NSUTF8StringEncoding]];
}

- (BOOL)nl_isNLCMTimeMapping {
  return [[self nl_anonymityPropertyEncode] isEqualToString:[NSString stringWithCString:@encode(NLCMTimeMapping) encoding:NSUTF8StringEncoding]];
}

- (BOOL)nl_isNLSCNVector3 {
  return [[self nl_anonymityPropertyEncode] isEqualToString:[NSString stringWithCString:@encode(NLSCNVector3) encoding:NSUTF8StringEncoding]];
}

- (BOOL)nl_isNLSCNVector4 {
  return [[self nl_anonymityPropertyEncode] isEqualToString:[NSString stringWithCString:@encode(NLSCNVector4) encoding:NSUTF8StringEncoding]];
}

- (BOOL)nl_isNLSCNMatrix4 {
  return [[self nl_anonymityPropertyEncode] isEqualToString:[NSString stringWithCString:@encode(NLSCNMatrix4) encoding:NSUTF8StringEncoding]];
}

@end

@implementation NSObject (nl_dynamicPropertyCustomeStruct)

+ (void)load {
  Method nl_missMethod = class_getClassMethod(self, @selector(nl_missMethodWithPropertyDescriptor:selector:));
  Method nl_customeStruct_missMethod = class_getClassMethod(self, @selector(nl_customeStruct_missMethodWithPropertyDescriptor:selector:));
  if (nl_missMethod && nl_customeStruct_missMethod) {
    method_exchangeImplementations(nl_missMethod, nl_customeStruct_missMethod);
  }
  
  Method setValueMethod = class_getInstanceMethod(self, @selector(setValue:forKey:));
  Method customeSetValueMethod = class_getInstanceMethod(self, @selector(custome_nl_setValue:forKey:));
  if (setValueMethod && customeSetValueMethod) {
    method_exchangeImplementations(setValueMethod, customeSetValueMethod);
  }
}

#pragma mark - dynamic add getter setter
+ (BOOL)nl_customeStruct_missMethodWithPropertyDescriptor:(NLPropertyDescriptor *)descriptor selector:(SEL)sel {
  NSString *selectorName = NSStringFromSelector(sel);
  if ([descriptor.getterName isEqualToString:selectorName]) {
    return [self nl_customeStruct_getterMethodWithPropertyDescriptor:descriptor];
  }
  
  if ([descriptor.setterName isEqualToString:selectorName]) {
    return [self nl_customeStruct_setterMethodWithPropertyDescriptor:descriptor];
  }
  
  return NO;
}

+ (BOOL)nl_customeStruct_setterMethodWithPropertyDescriptor:(NLPropertyDescriptor *)descriptor {
  IMP imp = NULL;
  
  if ([descriptor nl_isNLCLLocationCoordinate2D]) {
    imp = (IMP)NLDynamicIMPNameSetterCustomeStructType(NLCLLocationCoordinate2D);
  }
  
  if (imp == NULL && [descriptor nl_isNLMKCoordinateSpan]) {
    imp = (IMP)NLDynamicIMPNameSetterCustomeStructType(NLMKCoordinateSpan);
  }
  
  if (imp == NULL && [descriptor nl_isNLCMTime]) {
    imp = (IMP)NLDynamicIMPNameSetterCustomeStructType(NLCMTime);
  }
  
  if (imp == NULL && [descriptor nl_isNLCMTimeRange]) {
    imp = (IMP)NLDynamicIMPNameSetterCustomeStructType(NLCMTimeRange);
  }
  
  if (imp == NULL && [descriptor nl_isNLCMTimeMapping]) {
    imp = (IMP)NLDynamicIMPNameSetterCustomeStructType(NLCMTimeMapping);
  }
  
  if (imp == NULL && [descriptor nl_isNLSCNVector3]) {
    imp = (IMP)NLDynamicIMPNameSetterCustomeStructType(NLSCNVector3);
  }
  
  if (imp == NULL && [descriptor nl_isNLSCNVector4]) {
    imp = (IMP)NLDynamicIMPNameSetterCustomeStructType(NLSCNVector4);
  }
  
  if (imp == NULL && [descriptor nl_isNLSCNMatrix4]) {
    imp = (IMP)NLDynamicIMPNameSetterCustomeStructType(NLSCNMatrix4);
  }
  
  if (imp) {
    class_addMethod(self, NSSelectorFromString(descriptor.setterName), imp, "v@:");
    return YES;
  }
  
  return NO;
}

+ (BOOL)nl_customeStruct_getterMethodWithPropertyDescriptor:(NLPropertyDescriptor *)descriptor {
  IMP imp = NULL;
  if ([descriptor nl_isNLCLLocationCoordinate2D]) {
    imp = (IMP)NLDynamicIMPNameGetterCustomeStructType(NLCLLocationCoordinate2D);
  }
  
  if (imp == NULL && [descriptor nl_isNLMKCoordinateSpan]) {
    imp = (IMP)NLDynamicIMPNameGetterCustomeStructType(NLMKCoordinateSpan);
  }
  
  if (imp == NULL && [descriptor nl_isNLCMTime]) {
    imp = (IMP)NLDynamicIMPNameGetterCustomeStructType(NLCMTime);
  }
  
  if (imp == NULL && [descriptor nl_isNLCMTimeRange]) {
    imp = (IMP)NLDynamicIMPNameGetterCustomeStructType(NLCMTimeRange);
  }
  
  if (imp == NULL && [descriptor nl_isNLCMTimeMapping]) {
    imp = (IMP)NLDynamicIMPNameGetterCustomeStructType(NLCMTimeMapping);
  }
  
  if (imp == NULL && [descriptor nl_isNLSCNVector3]) {
    imp = (IMP)NLDynamicIMPNameGetterCustomeStructType(NLSCNVector3);
  }
  
  if (imp == NULL && [descriptor nl_isNLSCNVector4]) {
    imp = (IMP)NLDynamicIMPNameGetterCustomeStructType(NLSCNVector4);
  }
  
  if (imp == NULL && [descriptor nl_isNLSCNMatrix4]) {
    imp = (IMP)NLDynamicIMPNameGetterCustomeStructType(NLSCNMatrix4);
  }
  
  if (imp) {
    const char *cFunctionTypes = [[[descriptor nl_anonymityPropertyEncode] stringByAppendingString:@"@:"] cStringUsingEncoding:NSUTF8StringEncoding];
    class_addMethod(self, NSSelectorFromString(descriptor.getterName), imp, cFunctionTypes);
    return YES;
  }
  
  return NO;
}

#pragma mark - KVC
- (void)custome_nl_setValue:(id)value forKey:(NSString *)key {
  // 名字得以 staticPropertyNamePrefix 为前辍
  static NSString *staticPropertyNamePrefix = nil;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    const char *prefix = nl_dynamicPropertyPrefix();
    if (prefix != NULL) {
      staticPropertyNamePrefix = [NSString stringWithCString:prefix encoding:NSUTF8StringEncoding];
    }
  });
  
  if (staticPropertyNamePrefix == NULL || ![key hasPrefix:staticPropertyNamePrefix]) {
    [self custome_nl_setValue:value forKey:key];
    return;
  }

  
  NSArray *propertyDescriptors = [self.class nl_dynamicPropertyDescriptors];
  NLPropertyDescriptor *keyPropertyDescriptor = nil;
  SEL setterSelector = nil;
  
  for (NLPropertyDescriptor *propertyDescriptor in propertyDescriptors) {
    if ([propertyDescriptor.name isEqualToString:key]) {
      if ([self respondsToSelector:NSSelectorFromString(propertyDescriptor.setterName)]) {
        keyPropertyDescriptor = propertyDescriptor;
        setterSelector = NSSelectorFromString(propertyDescriptor.setterName);
      }
      break;
    }
  }
  
  // 如果不是对象，则一定是基础类型或结构体
  // 而这两者所对象的类一定是 NSValue
  if (![value isKindOfClass:[NSValue class]]) {
    [self custome_nl_setValue:value forKey:key];
    return;
  }
  
  if ([keyPropertyDescriptor nl_isNLCLLocationCoordinate2D]) {
    NLDynamicIMPNameSetterCustomeStructType(NLCLLocationCoordinate2D)(self, setterSelector, [value NLCLLocationCoordinate2DValue]);
    return;
  }
  
  if ([keyPropertyDescriptor nl_isNLMKCoordinateSpan]) {
    NLDynamicIMPNameSetterCustomeStructType(NLMKCoordinateSpan)(self, setterSelector, [value NLMKCoordinateSpanValue]);
    return;
  }
  
  if ([keyPropertyDescriptor nl_isNLCMTime]) {
    NLDynamicIMPNameSetterCustomeStructType(NLCMTime)(self, setterSelector, [value NLCMTimeValue]);
    return;
  }
  
  if ([keyPropertyDescriptor nl_isNLCMTimeRange]) {
    NLDynamicIMPNameSetterCustomeStructType(NLCMTimeRange)(self, setterSelector, [value NLCMTimeRangeValue]);
    return;
  }
  
  if ([keyPropertyDescriptor nl_isNLCMTimeMapping]) {
    NLDynamicIMPNameSetterCustomeStructType(NLCMTimeMapping)(self, setterSelector, [value NLCMTimeMappingValue]);
    return;
  }
  
  if ([keyPropertyDescriptor nl_isNLSCNVector3]) {
    NLDynamicIMPNameSetterCustomeStructType(NLSCNVector3)(self, setterSelector, [value NLSCNVector3Value]);
    return;
  }
  
  if ([keyPropertyDescriptor nl_isNLSCNVector4]) {
    NLDynamicIMPNameSetterCustomeStructType(NLSCNVector4)(self, setterSelector, [value NLSCNVector4Value]);
    return;
  }
  
  if ([keyPropertyDescriptor nl_isNLSCNMatrix4]) {
    NLDynamicIMPNameSetterCustomeStructType(NLSCNMatrix4)(self, setterSelector, [value NLSCNMatrix4Value]);
    return;
  }
  
  [self custome_nl_setValue:value forKey:key];
}

@end
