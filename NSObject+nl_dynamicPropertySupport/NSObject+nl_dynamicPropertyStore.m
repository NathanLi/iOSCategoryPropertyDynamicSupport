//
//  NSObject+nl_dynamicProperty.m
//  CategoryPropertyDynamicSupport
//
//  Created by 听榆大叔 on 15/11/20.
//  Copyright © 2015年 NL. All rights reserved.
//

#ifdef DEBUG
#define NLDLogError(xx, ...)  fprintf(stderr, ##__VA_ARGS__)
#else
#define NLDLogError(xx, ...)  ((void)0)
#endif

#import "NSObject+nl_dynamicPropertyStore.h"
#import "NSObject+nl_dynamicPropertySupport.h"
#import "NLDynamicPropertyPrefix.h"

@implementation NSObject (nl_dynamicPropertyStore)

+ (BOOL)nl_validDynamicProperty:(objc_property_t)objProperty {
  const char *propertyAttributes = property_getAttributes(objProperty);
  
  // 必须是 @dynamic
  static char *const staticDynamicAttribute = ",D,";
  if (strstr(propertyAttributes, staticDynamicAttribute) == NULL) {
    return NO;
  }
  
  // 名字得以 staticPropertyNamePrefix 为前辍
  static const char *staticPropertyNamePrefix = NULL;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    staticPropertyNamePrefix = nl_dynamicPropertyPrefix();
  });
  
  const char *propertyName = property_getName(objProperty);
  if (staticPropertyNamePrefix != NULL && strstr(propertyName, staticPropertyNamePrefix) != propertyName) {
    return NO;
  }
  
  // 不支持普通指针类型
  NSString *propertyAttributesString = [NSString stringWithCString:propertyAttributes encoding:NSUTF8StringEncoding];
  NSString *propertyEncoding = [propertyAttributesString substringToIndex:[propertyAttributesString rangeOfString:@","].location];
  if ([propertyEncoding hasPrefix:@"T*"]) {
    NLDLogError("%s", "nl dynamic property dot not support C character string\n");
    return NO;
  }
  
  if ([propertyEncoding hasPrefix:@"T^"]) {
    NLDLogError("%s\n", "nl dynamic property dot not support point type");
    return NO;
  }
  
  return YES;
}

+ (NSArray *)nl_dynamicPropertyDescriptors {
  NSMutableArray *descriptors = objc_getAssociatedObject(self, _cmd);
  
  if (nil == descriptors) {
    unsigned int outCount, index;
    descriptors = [NSMutableArray arrayWithCapacity:outCount];
    objc_setAssociatedObject(self, _cmd, descriptors, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // 获取到本类所有的属性结构体，并转换为属性描述器
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (index = 0; index < outCount; ++index) {
      objc_property_t property = properties[index];
      if ([self nl_validDynamicProperty:property]) {
        NLPropertyDescriptor *descriptor = [[NLPropertyDescriptor alloc] initWithObjcProperty:property];
        [descriptors addObject:descriptor];
      }
    }
    
    free(properties);
    
    if (self != [NSObject class]) {
      // 加上父类的属性结构体
      [descriptors addObjectsFromArray:[class_getSuperclass(self) nl_dynamicPropertyDescriptors]];
    }
  }
  
  return descriptors;
}

+ (NLPropertyDescriptor *)nl_descriptorWithSelector:(SEL)selector {
  for (NLPropertyDescriptor *descriptor in [self nl_dynamicPropertyDescriptors]) {
    NSString *selectorName = NSStringFromSelector(selector);
    if ([descriptor.getterName isEqualToString:selectorName] || [descriptor.setterName isEqualToString:selectorName]) {
      return descriptor;
    }
  }
  return nil;
}

+ (NSString *)nl_dynamicPropertyNameWithSelctor:(SEL)selector {
  return [[self nl_descriptorWithSelector:selector] name];
}


- (NSMutableDictionary *)nl_dynamicPropertyDictionary {
  NSMutableDictionary *dynamicProperties = objc_getAssociatedObject(self, _cmd);
  if (!dynamicProperties) {
    dynamicProperties = [NSMutableDictionary dictionaryWithCapacity:2];
    objc_setAssociatedObject(self, _cmd, dynamicProperties, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  }
  return dynamicProperties;
}

- (NSMapTable *)nl_dynamicPropertyWeakDictionary {
  NSMapTable *weakDynamicProperties = objc_getAssociatedObject(self, _cmd);
  if (!weakDynamicProperties) {
    weakDynamicProperties = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsStrongMemory valueOptions:NSMapTableWeakMemory capacity:2];
    objc_setAssociatedObject(self, _cmd, weakDynamicProperties, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  }
  return weakDynamicProperties;
}

@end
