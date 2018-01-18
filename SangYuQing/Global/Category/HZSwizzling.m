//
//  HZSwizzling.c
//  AnhuiNews
//
//  Created by History on 9/30/15.
//  Copyright © 2015 ahxmt. All rights reserved.
//

#include "HZSwizzling.h"

#pragma mark - Swizzling
void SwizzlingMethod(Class class, SEL originSelector, SEL swizzlingSelector)
{
    Method originMethod = class_getInstanceMethod(class, originSelector);
    Method swizzlingMethod = class_getInstanceMethod(class, swizzlingSelector);
    
    BOOL didAddMethod = class_addMethod(class, originSelector, method_getImplementation(swizzlingMethod), method_getTypeEncoding(swizzlingMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class, swizzlingSelector, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
    }
    else {
        method_exchangeImplementations(originMethod, swizzlingMethod);
    }
}