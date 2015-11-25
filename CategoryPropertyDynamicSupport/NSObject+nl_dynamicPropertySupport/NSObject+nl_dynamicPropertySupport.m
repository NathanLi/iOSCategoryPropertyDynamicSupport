//
//  NSObject+nl_dynamicPropertySupport.m
//  CategoryPropertyDynamicSupport
//
//  Created by 听榆大叔 on 15/11/23.
//  Copyright © 2015年 NL. All rights reserved.
//

#import "NSObject+nl_dynamicPropertySupport.h"
#import <objc/runtime.h>
#import "NSObject+nl_dynamicPropertyStore.h"

/**
 * 基本数据类型的 getter 方法名
 */
#define NLDynamicIMPNameGetterBaseDataType(typeName) __NL__##typeName##_dynamicGetterIMP

/**
 * 基本数据类型的 setter 方法名
 */
#define NLDynamicIMPNameSetterBaseDataType(typeName) __NL__##typeName##_dynamicSetterIMP

#define NLDefineDynamicIMPGetterBaseDataType(typeName, BaseType) \
BaseType NLDynamicIMPNameGetterBaseDataType(typeName)(id self, SEL _cmd) {\
\
NSString *propertyName = [[self class] nl_dynamicPropertyNameWithSelctor:_cmd]; \
return [[[self nl_dynamicPropertyDictionary] objectForKey:propertyName] typeName##Value];\
}

#define NLDefineDynamicIMPSetterBaseDataType(typeName, BaseType) \
void NLDynamicIMPNameSetterBaseDataType(typeName)(id self, SEL _cmd, BaseType arg) {\
NSString *propertyName = [[self class] nl_dynamicPropertyNameWithSelctor:_cmd];\
[[self nl_dynamicPropertyDictionary] setObject:@(arg) forKey:propertyName];\
}\

#define NLDefineDynamicIMPBaseDataType(name, BaseType) \
NLDefineDynamicIMPGetterBaseDataType(name, BaseType); \
NLDefineDynamicIMPSetterBaseDataType(name, BaseType);

NLDefineDynamicIMPBaseDataType(char, char);
NLDefineDynamicIMPBaseDataType(int, int);
NLDefineDynamicIMPBaseDataType(short, short);
NLDefineDynamicIMPBaseDataType(long, long);
NLDefineDynamicIMPBaseDataType(longLong, long long);
NLDefineDynamicIMPBaseDataType(unsignedChar, unsigned char);
NLDefineDynamicIMPBaseDataType(unsignedInt, unsigned int);
NLDefineDynamicIMPBaseDataType(unsignedShort, unsigned short);
NLDefineDynamicIMPBaseDataType(unsignedLong, unsigned long);
NLDefineDynamicIMPBaseDataType(unsignedLongLong, unsigned long long);
NLDefineDynamicIMPBaseDataType(float, float);
NLDefineDynamicIMPBaseDataType(double, double);
NLDefineDynamicIMPSetterBaseDataType(bool, bool);


#define NLDynamicIMPNameGetterStructType(typeName) __NL__struct_##typeName##_dynamicGetterIMP
#define NLDynamicIMPNameSetterStructType(typeName) __NL__struct_##typeName##_dynamicSetterIMP

#define NLDefineDynamicIMPGetterStructType(typeName) \
typeName NLDynamicIMPNameGetterStructType(typeName)(id self, SEL _cmd) {\
NSString *propertyName = [[self class] nl_dynamicPropertyNameWithSelctor:_cmd];\
return [[[self nl_dynamicPropertyDictionary] objectForKey:propertyName] typeName##Value];\
}

#define NLDefineDynamicIMPSetterStructType(typeName) \
void NLDynamicIMPNameSetterStructType(typeName)(id self, SEL _cmd, typeName arg) {\
NSString *propertyName = [[self class] nl_dynamicPropertyNameWithSelctor:_cmd];\
[[self nl_dynamicPropertyDictionary] setObject:[NSValue valueWith##typeName:arg] forKey:propertyName];\
}

#define NLDefineDynamicIMPStructType(typeName) \
NLDefineDynamicIMPGetterStructType(typeName);\
NLDefineDynamicIMPSetterStructType(typeName);

NLDefineDynamicIMPStructType(CGRect);
NLDefineDynamicIMPStructType(CGPoint);
NLDefineDynamicIMPStructType(CGSize);
NLDefineDynamicIMPStructType(CGVector);
NLDefineDynamicIMPStructType(UIOffset);
NLDefineDynamicIMPStructType(UIEdgeInsets);
NLDefineDynamicIMPStructType(CGAffineTransform);
NLDefineDynamicIMPStructType(CATransform3D);

/**
 * 因为 bool 本身就是一个宏定义，所以其无法使用 NLDefineDynamicIMPGetterBaseDataType 宏
 */
bool __NL__bool_dynamicGetterIMP(id self, SEL _cmd) {
  NSString *propertyName = [[self class] nl_dynamicPropertyNameWithSelctor:_cmd];
  return [[[self nl_dynamicPropertyDictionary] objectForKey:propertyName] boolValue];
}

void __NL__object_dynamicSetterIMP(id self, SEL _cmd, id arg) {
  NSString *propertyName = [[self class] nl_dynamicPropertyNameWithSelctor:_cmd];
//  [self willChangeValueForKey:propertyName];
  [[self nl_dynamicPropertyDictionary] setObject:arg forKey:propertyName];
//  [self didChangeValueForKey:propertyName];
}

void __NL__object_dynamicSetterCopyIMP(id self, SEL _cmd, id arg) {
  NSString *propertyName = [[self class] nl_dynamicPropertyNameWithSelctor:_cmd];
  [[self nl_dynamicPropertyDictionary] setObject:[arg copy] forKey:propertyName];
}

void __NL__object_dynamicSetterWeakIMP(id self, SEL _cmd, id arg) {
  NSString *propertyName = [[self class] nl_dynamicPropertyNameWithSelctor:_cmd];
  [[self nl_dynamicPropertyWeakDictionary] setObject:arg forKey:propertyName];
}

id __NL__object_dynamicGetterIMP(id self, SEL _cmd) {
  NSString *propertyName = [[self class] nl_dynamicPropertyNameWithSelctor:_cmd];
  return [[self nl_dynamicPropertyDictionary] objectForKey:propertyName];
}

@interface NSObject (nl_dynamicSupport)

+ (BOOL)nl_addMethodWithDescriptor:(NLPropertyDescriptor *)desciptor selector:(SEL)sel;

@end

@implementation NSObject (nl_dynamicSupport)

+ (void)load {
  Method resolveInstanceMethod = class_getClassMethod(self, @selector(resolveInstanceMethod:));
  Method nl_resolveInstanceMethod = class_getClassMethod(self, @selector(nl_resolveInstanceMethod:));
  if (resolveInstanceMethod && nl_resolveInstanceMethod) {
    method_exchangeImplementations(resolveInstanceMethod, nl_resolveInstanceMethod);
  }
  
  Method setValueForUndefinedKeyMethod = class_getInstanceMethod(self, @selector(setValue:forUndefinedKey:));
  Method nl_setValueForUndefinedKeyMethod = class_getInstanceMethod(self, @selector(nl_setValue:forUndefinedKey:));
  if (setValueForUndefinedKeyMethod && nl_setValueForUndefinedKeyMethod) {
    method_exchangeImplementations(setValueForUndefinedKeyMethod, nl_setValueForUndefinedKeyMethod);
  }
}

#pragma mark - swizzle +resolveInstanceMethod and - setValue:forUndefinedKey:
+ (BOOL)nl_resolveInstanceMethod:(SEL)sel {
  NSArray *propertyDescriptors = [self nl_dynamicPropertyDescriptors];
  for (NLPropertyDescriptor *propertyDescriptor in propertyDescriptors) {
    BOOL didAddMethod = [self nl_addMethodWithDescriptor:propertyDescriptor selector:sel];
    if (didAddMethod) {
      return YES;
    }
  }
  
  return [self nl_resolveInstanceMethod:sel];
}

/**
 *  @brief  support for KVO
 *          由于动态属性的 setter 方法是在 runtime 时增加的，系统的 KVO 寻 key 路径无法得知，
 *       所以在系统要调用 -setValue:forUndefinedKey: 时，手动调用咱们的 setter 方法
 */
- (void)nl_setValue:(id)value forUndefinedKey:(NSString *)key {
  NSArray *propertyDescriptors = [self.class nl_dynamicPropertyDescriptors];
  for (NLPropertyDescriptor *propertyDescriptor in propertyDescriptors) {
    if ([propertyDescriptor.name isEqualToString:key]) {
      SEL setterSelector = NSSelectorFromString(propertyDescriptor.setterName);
      if ([self respondsToSelector:setterSelector]) {
        
        _Pragma("clang diagnostic push")
        _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")
        [self performSelector:setterSelector withObject:value];
        _Pragma("clang diagnostic pop")
        
      }
      return;
    }
  }
  
  [self nl_setValue:value forUndefinedKey:key];
}

#pragma mark - dynamic add method
+ (BOOL)nl_addMethodWithDescriptor:(NLPropertyDescriptor *)desciptor selector:(SEL)sel {
  NSString *selName = NSStringFromSelector(sel);
  if ([desciptor.setterName isEqualToString:selName]) {
    BOOL addedSetter = [self nl_addSetterMethodWithDescriptor:desciptor];
    if (!addedSetter) {
      return [self nl_missMethodWithPropertyDescriptor:desciptor selector:sel];
    }
    
    return YES;
  }
  
  if ([desciptor.getterName isEqualToString:selName]) {
    BOOL addedSetter = [self nl_addGetterMethodWithDescriptor:desciptor];
    if (!addedSetter) {
      return [self nl_missMethodWithPropertyDescriptor:desciptor selector:sel];
    }
    return YES;
  }
  
  return NO;
}

+ (BOOL)nl_addSetterMethodWithDescriptor:(NLPropertyDescriptor *)desciptor {
  if (desciptor.setterName == nil) {
    return NO;
  }
  
  IMP setterIMP = NULL;
  
  if ([desciptor isCharType]
      || [desciptor isIntType]
      || [desciptor isShortType]
      || [desciptor isLongType]
      || [desciptor isLongLongType]
      || [desciptor isBoolType]
      || [desciptor isUCharType]
      || [desciptor isUIntType]
      || [desciptor isUShortType]
      || [desciptor isULongType]
      || [desciptor isULongLongType]) {
    setterIMP = (IMP)(NLDynamicIMPNameSetterBaseDataType(unsignedLongLong));
  }
  
  if ([desciptor isFloatType]) {
    setterIMP = (IMP)NLDynamicIMPNameSetterBaseDataType(float);
  }
  
  if ([desciptor isDoubleType]) {
    setterIMP = (IMP)NLDynamicIMPNameSetterBaseDataType(double);
  }
  
  if ([desciptor isObjectType]) {
    if (desciptor.propertyPolicy == NLPropertyPolicyAssign
        || desciptor.propertyPolicy == NLPropertyPolicyWeak) {
      setterIMP = (IMP)__NL__object_dynamicSetterWeakIMP;
    } else if (desciptor.propertyPolicy == NLPropertyPolicyCopy) {
      setterIMP = (IMP)__NL__object_dynamicSetterCopyIMP;
    } else {
      setterIMP = (IMP)__NL__object_dynamicSetterIMP;
    }
  }
  
  if (setterIMP == NULL && [desciptor isRectType]) {
    setterIMP = (IMP)NLDynamicIMPNameSetterStructType(CGRect);
  }
  
  if (setterIMP == NULL && [desciptor isPointType]) {
    setterIMP = (IMP)NLDynamicIMPNameSetterStructType(CGPoint);
  }
  
  if (setterIMP == NULL && [desciptor isSizeType]) {
    setterIMP = (IMP)NLDynamicIMPNameSetterStructType(CGSize);
  }
  
  if (setterIMP == NULL && [desciptor isVectorType]) {
    setterIMP = (IMP)NLDynamicIMPNameSetterStructType(CGVector);
  }
  
  if (setterIMP == NULL && [desciptor isOffsetType]) {
    setterIMP = (IMP)NLDynamicIMPNameSetterStructType(UIOffset);
  }
  
  if (setterIMP == NULL && [desciptor isEdgeInsetsType]) {
    setterIMP = (IMP)NLDynamicIMPNameSetterStructType(UIEdgeInsets);
  }
  
  if (setterIMP == NULL && [desciptor isAffineTransormType]) {
    setterIMP = (IMP)NLDynamicIMPNameSetterStructType(CGAffineTransform);
  }
  
  if (setterIMP == NULL && [desciptor isTransorm3DType]) {
    setterIMP = (IMP)NLDynamicIMPNameSetterStructType(CATransform3D);
  }
  
  if (setterIMP != NULL) {
    class_addMethod(self, NSSelectorFromString(desciptor.setterName), setterIMP, "v@:");
    return YES;
  }
  
  return NO;
}

+ (BOOL)nl_addGetterMethodWithDescriptor:(NLPropertyDescriptor *)desciptor {
  if (desciptor.getterName == nil) {
    return NO;
  }
  
  SEL selector = NSSelectorFromString(desciptor.getterName);
  IMP getterIMP = NULL;
  if ([desciptor isCharType]
      || [desciptor isIntType]
      || [desciptor isShortType]
      || [desciptor isLongType]
      || [desciptor isLongLongType]
      || [desciptor isBoolType]
      || [desciptor isUCharType]
      || [desciptor isUIntType]
      || [desciptor isUShortType]
      || [desciptor isULongType]
      || [desciptor isULongLongType]) {
    getterIMP = (IMP)(NLDynamicIMPNameGetterBaseDataType(unsignedLongLong));
  }
  
  if (getterIMP != NULL) {
    class_addMethod(self, selector, getterIMP, "Q@:");
    return YES;
  }
  
  if ([desciptor isFloatType]) {
    class_addMethod(self, selector, (IMP)NLDynamicIMPNameGetterBaseDataType(float), "f@:");
    return YES;
  }
  
  if ([desciptor isDoubleType]) {
    class_addMethod(self, selector, (IMP)NLDynamicIMPNameGetterBaseDataType(double), "d@:");
    return YES;
  }
  
  
  if ([desciptor isObjectType]) {
    class_addMethod(self, selector, (IMP)__NL__object_dynamicGetterIMP, "@@:");
    return YES;
  }
  
  if ([desciptor isRectType]) {
    class_addMethod(self, selector, (IMP)NLDynamicIMPNameGetterStructType(CGRect), "{@:");
    return YES;
  }
  
  if ([desciptor isPointType]) {
    class_addMethod(self, selector, (IMP)NLDynamicIMPNameGetterStructType(CGPoint), "{@:");
    return YES;
  }
  
  if ([desciptor isSizeType]) {
    class_addMethod(self, selector, (IMP)NLDynamicIMPNameGetterStructType(CGSize), "{@:");
    return YES;
  }
  
  if ([desciptor isVectorType]) {
    class_addMethod(self, selector, (IMP)NLDynamicIMPNameGetterStructType(CGVector), "{@:");
    return YES;
  }
  
  if ([desciptor isOffsetType]) {
    class_addMethod(self, selector, (IMP)NLDynamicIMPNameGetterStructType(UIOffset), "{@:");
    return YES;
  }
  
  if ([desciptor isEdgeInsetsType]) {
    class_addMethod(self, selector, (IMP)NLDynamicIMPNameGetterStructType(UIEdgeInsets), "{@:");
    return YES;
  }
  
  if ([desciptor isAffineTransormType]) {
    class_addMethod(self, selector, (IMP)NLDynamicIMPNameGetterStructType(CGAffineTransform), "{@:");
    return YES;
  }
  
  if ([desciptor isTransorm3DType]) {
    class_addMethod(self, selector, (IMP)NLDynamicIMPNameGetterStructType(CATransform3D), "{@:");
    return YES;
  }
  
  return NO;
}

@end

@implementation NSObject (nl_dynamicPropertySupport)

+ (BOOL)nl_missMethodWithPropertyDescriptor:(NLPropertyDescriptor *)descriptor selector:(SEL)sel {
  return NO;
}

@end
