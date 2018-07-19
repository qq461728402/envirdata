//
//  UITextViewPlaceHolder.h
//  SZContact
//
//  Created by Ahua772 on 12-11-22.
//
//

#import <UIKit/UIKit.h>

@interface UITextViewPlaceHolder : UITextView
{
    NSString *placeholder;
    UIColor *placeholderColor;
@private
    UILabel *placeHolderLabel;
}

@property (nonatomic, retain) UILabel *placeHolderLabel;
@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end
