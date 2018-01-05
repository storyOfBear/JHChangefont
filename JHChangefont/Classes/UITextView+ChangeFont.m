//
//  UITextView+ChangeFont.m
//  ChangeLabelFont
//
//  Created by gjh on 2018/1/5.
//  Copyright © 2018年 gjh. All rights reserved.
//

#import "UITextView+ChangeFont.h"
#import <objc/runtime.h>

@implementation UITextView (ChangeFont)
//只执行一次的方法，在这个地方 替换方法
+(void)load{
    //方法交换只执行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        //系统方法
        SEL orignalSel = @selector(awakeFromNib);
        Method orignalM = class_getInstanceMethod(class, orignalSel);
        
        //交换方法
        SEL swizzledSel = @selector(jh_awakeFromNib);
        Method swizzledM = class_getInstanceMethod(class, swizzledSel);
        
        //添加方法
        BOOL didAddMethod = class_addMethod(class, orignalSel, method_getImplementation(swizzledM), method_getTypeEncoding(swizzledM));
        //交换方法
        if (didAddMethod) {
            class_replaceMethod(class, swizzledSel, method_getImplementation(orignalM), method_getTypeEncoding(orignalM));
        }else{
            method_exchangeImplementations(orignalM, swizzledM);
        }
    });
}

#pragma mark -使用的替换方法
-(void)jh_awakeFromNib{
    [self jh_awakeFromNib];
    UIFont *font = [self.font fontWithSize:self.font.pointSize];
    self.font = font;
}

@end
