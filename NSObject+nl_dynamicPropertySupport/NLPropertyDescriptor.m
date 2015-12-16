//
//  NLPropertyDescriptor.m
//  CategoryPropertyDynamicSupport
//
//  Created by 听榆大叔 on 15/11/19.
//  Copyright © 2015年 NL. All rights reserved.
//

#import "NLPropertyDescriptor.h"

@implementation NLPropertyDescriptor

- (instancetype)initWithObjcProperty:(objc_property_t)objcProperty {
  if (self = [super init]) {
    _propertyPolicy = NLPropertyPolicyAssign;
    
    const char *cPropertyName = property_getName(objcProperty);
    _name = [[NSString stringWithCString:cPropertyName encoding:NSUTF8StringEncoding] copy];
    _getterName = [_name copy];
    _variableName = [@"_" stringByAppendingString:_name];
    
    ({
      // default setter name.
      NSString *firstChar = [[_name substringToIndex:1] uppercaseString];
      NSString *subjectName = [_name substringFromIndex:1] ?: @"";
      subjectName = [subjectName stringByAppendingString:@":"];
      _setterName = [[NSString stringWithFormat:@"set%@%@", firstChar, subjectName] copy];
    });
    
    
    const char *cPropertyAttributes = property_getAttributes(objcProperty);
    NSString *sPropertyAttributes = [NSString stringWithCString:cPropertyAttributes encoding:NSUTF8StringEncoding];
    NSArray *attributes = [sPropertyAttributes componentsSeparatedByString:@","];
    [attributes enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
      if (idx == 0) {
        // 第一个一定是类型编码
        _typeEncoding = [obj copy];
      }
      
      if ([obj hasPrefix:@"G"]) {
        // getter 方法名
        NSString *getterName = [obj substringFromIndex:1];
        _getterName = [getterName copy];
      } else if ([obj hasPrefix:@"S"]) {
        // setter 方法名
        NSString *setterName = [obj substringFromIndex:1];
        _setterName = [setterName copy];
      } else if ([obj hasPrefix:@"V"]) {
        // 变量名
        NSString *variableName = [obj substringFromIndex:1];
        _variableName = [variableName copy];
      } else if ([obj isEqualToString:@"&"]) {
        _propertyPolicy = NLPropertyPolicyStrong;
      } else if ([obj isEqualToString:@"C"]) {
        _propertyPolicy = NLPropertyPolicyCopy;
      } else if ([obj isEqualToString:@"W"]) {
        _propertyPolicy = NLPropertyPolicyWeak;
      } else if ([obj isEqualToString:@"R"]) {
        // readonly
        _setterName = nil;
      }
      
    }];
  }
  return self;
}

- (BOOL)isObjectType {
  return [self.typeEncoding hasPrefix:@"T@"];
}

- (BOOL)isCharType {
  return [self.typeEncoding isEqualToString:@"Tc"];
}

- (BOOL)isIntType {
  return [self.typeEncoding isEqualToString:@"Ti"];
}

- (BOOL)isShortType {
  return [self.typeEncoding isEqualToString:@"Ts"];
}

- (BOOL)isLongType {
  return [self.typeEncoding isEqualToString:@"Tl"];
}

- (BOOL)isLongLongType {
  return [self.typeEncoding isEqualToString:@"Tq"];
}

- (BOOL)isUCharType {
  return [self.typeEncoding isEqualToString:@"TC"];
}

- (BOOL)isUIntType {
  return [self.typeEncoding isEqualToString:@"TI"];
}

- (BOOL)isUShortType {
  return [self.typeEncoding isEqualToString:@"TS"];
}

- (BOOL)isULongType {
  return [self.typeEncoding isEqualToString:@"TL"];
}

- (BOOL)isULongLongType {
  return [self.typeEncoding isEqualToString:@"TQ"];
}

- (BOOL)isFloatType {
  return [self.typeEncoding isEqualToString:@"Tf"];
}

- (BOOL)isDoubleType {
  return [self.typeEncoding isEqualToString:@"Td"];
}

- (BOOL)isBoolType {
  return [self.typeEncoding isEqualToString:@"TB"];
}

- (BOOL)isRectType {
  NSString *encodeString = [NSString stringWithCString:@encode(CGRect) encoding:NSUTF8StringEncoding];
  return [self.typeEncoding isEqualToString:[@"T" stringByAppendingString:encodeString]];
}

- (BOOL)isPointType {
  NSString *encodeString = [NSString stringWithCString:@encode(CGPoint) encoding:NSUTF8StringEncoding];
  return [self.typeEncoding isEqualToString:[@"T" stringByAppendingString:encodeString]];
}

- (BOOL)isSizeType {
  NSString *encodeString = [NSString stringWithCString:@encode(CGSize) encoding:NSUTF8StringEncoding];
  return [self.typeEncoding isEqualToString:[@"T" stringByAppendingString:encodeString]];
}

- (BOOL)isVectorType {
  NSString *encodeString = [NSString stringWithCString:@encode(CGVector) encoding:NSUTF8StringEncoding];
  return [self.typeEncoding isEqualToString:[@"T" stringByAppendingString:encodeString]];
}

- (BOOL)isOffsetType {
  NSString *encodeString = [NSString stringWithCString:@encode(UIOffset) encoding:NSUTF8StringEncoding];
  return [self.typeEncoding isEqualToString:[@"T" stringByAppendingString:encodeString]];
}

- (BOOL)isEdgeInsetsType {
  NSString *encodeString = [NSString stringWithCString:@encode(UIEdgeInsets) encoding:NSUTF8StringEncoding];
  return [self.typeEncoding isEqualToString:[@"T" stringByAppendingString:encodeString]];
}

- (BOOL)isAffineTransormType {
  NSString *encodeString = [NSString stringWithCString:@encode(CGAffineTransform) encoding:NSUTF8StringEncoding];
  return [self.typeEncoding isEqualToString:[@"T" stringByAppendingString:encodeString]];
}

- (BOOL)isTransorm3DType {
  NSString *encodeString = [NSString stringWithCString:@encode(CATransform3D) encoding:NSUTF8StringEncoding];
  return [self.typeEncoding isEqualToString:[@"T" stringByAppendingString:encodeString]];
}

@end
