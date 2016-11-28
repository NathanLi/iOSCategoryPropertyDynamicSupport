//
//  NLDynamicPropertyPrefix.m
//  CategoryPropertyDynamicSupport
//
//  Created by NathanLi on 28/11/2016.
//  Copyright © 2016 听榆大叔. All rights reserved.
//

#import "NLDynamicPropertyPrefix.h"
#import <objc/runtime.h>

#ifndef DynamicPropertyPrefixDefault
#define DynamicPropertyPrefixDefault "nl_"
#endif

typedef char *(*NLDynamicPropertyPrefix)(id);

const char *nl_dynamicPropertyPrefix() {
  static char *prefix = DynamicPropertyPrefixDefault;
  static BOOL didLoadSetPrefix = NO;
  
  if (!didLoadSetPrefix) {
    if ([NSObject instancesRespondToSelector:sel_registerName("__nl_dynamicPropertyPrefix__")]) {
      Method method = class_getInstanceMethod([NSObject class], sel_registerName("__nl_dynamicPropertyPrefix__"));
      IMP imp = method_getImplementation(method);
      prefix = ((NLDynamicPropertyPrefix)imp)(nil);
    }
    
    didLoadSetPrefix = YES;
  }
  
  
#ifdef DEBUG
  static BOOL isVaild = NO;
  if (!isVaild) {
    assert(strlen(prefix) > 0);
    
    isVaild = YES;
  }
#endif
  
  return prefix;
}
