//
//  NLPropertyDescriptor.h
//  CategoryPropertyDynamicSupport
//
//  Created by 听榆大叔 on 15/11/19.
//  Copyright © 2015年 NL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

/**
 *
 c  A char
 i  An int
 s  A short
 l  A long
    l is treated as a 32-bit quantity on 64-bit programs.
 q  A long long
 C  An unsigned char
 I  An unsigned int
 S  An unsigned short
 L  An unsigned long
 Q  An unsigned long long
 f  A float
 d  A double
 B  A C++ bool or a C99 _Bool
 v  A void
 *  A character string (char *)
 @  An object (whether statically typed or typed id)
 #  A class object (Class)
 :  A method selector (SEL)
 [array type]  An array
 {name=type...}  A structure
 (name=type...)  A union
 bnum  A bit field of num bits
 ^type  A pointer to type
 ?  An unknown type (among other things, this code is used for function pointers)
 
 */

typedef NS_ENUM(NSUInteger, NLPropertyPolicy) {
  NLPropertyPolicyAssign,
  NLPropertyPolicyStrong,
  NLPropertyPolicyCopy,
  NLPropertyPolicyWeak,
};

@interface NLPropertyDescriptor : NSObject

/**
 *  @brief 属性名
 */
@property (nonatomic, copy, readonly) NSString *name;

/**
 *  @brief getter 方法名
 */
@property (nonatomic, copy, readonly) NSString *getterName;

/**
 *  @brief setter 方法名
 */
@property (nonatomic, copy, readonly) NSString *setterName;

/**
 *  @brief 变量名
 */
@property (nonatomic, copy, readonly) NSString *variableName;

/**
 *  @brief 属性类型编码
 */
@property (nonatomic, copy, readonly) NSString *typeEncoding;

/**
 *  @brief 属性类型
 */
@property (nonatomic, assign, readonly) NLPropertyPolicy propertyPolicy;

/**
 *  @brief 初始化
 */
- (instancetype)initWithObjcProperty:(objc_property_t)objcProperty;

- (BOOL)isObjectType;
- (BOOL)isCharType;
- (BOOL)isIntType;
- (BOOL)isShortType;
- (BOOL)isLongType;
- (BOOL)isLongLongType;
- (BOOL)isUCharType;
- (BOOL)isUIntType;
- (BOOL)isUShortType;
- (BOOL)isULongType;
- (BOOL)isULongLongType;
- (BOOL)isFloatType;
- (BOOL)isDoubleType;
- (BOOL)isBoolType;

- (BOOL)isRectType;
- (BOOL)isPointType;
- (BOOL)isSizeType;
- (BOOL)isVectorType;
- (BOOL)isOffsetType;
- (BOOL)isEdgeInsetsType;
- (BOOL)isAffineTransormType;
- (BOOL)isTransorm3DType;
@end
