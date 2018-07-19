//
//  CTextField.m
//  dtgh
//
//  Created by 熊佳佳 on 15/11/5.
//  Copyright © 2015年 熊佳佳. All rights reserved.
//

#import "CTextField.h"

@implementation CTextField
// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 8, 0);
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 8, 0);
}
@end
