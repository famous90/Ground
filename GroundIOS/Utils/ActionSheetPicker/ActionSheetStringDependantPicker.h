//
//  ActionSheetStringDependantPicker.h
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 7. 27..
//  Copyright (c) 2013년 AnB. All rights reserved.
//


#import "AbstractActionSheetPicker.h"

@class ActionSheetStringDependantPicker;
typedef void(^ActionStringDependentDoneBlock)(ActionSheetStringDependantPicker *picker, NSInteger selectedParentIndex, NSInteger selectedChildIndex,id selectedParentValue, id selectedChildValue);
typedef void(^ActionStringDependeantCancelBlock)(ActionSheetStringDependantPicker *picker);

@interface ActionSheetStringDependantPicker : AbstractActionSheetPicker <UIPickerViewDelegate, UIPickerViewDataSource>

+ (id)showPickerWithTitle:(NSString *)title parentDic:(NSDictionary *)parentDic parentRows:(NSArray *)parentData childRows:(NSArray *)childData initialParentSelection:(NSInteger)parentIndex initialChildSelection:(NSInteger)childIndex target:(id)target successAction:(SEL)successAction cancelAction:(SEL)cancelActionOrNil origin:(id)origin;

- (id)initWithTitle:(NSString *)title parentDic:(NSDictionary *)parentDic parentRows:(NSArray *)parentData childRows:(NSArray *)childData initialParentSelection:(NSInteger)parentIndex initialChildSelection:(NSInteger)childIndex target:(id)target successAction:(SEL)successAction cancelAction:(SEL)cancelActionOrNil origin:(id)origin;

+ (id)showPickerWithTitle:(NSString *)title parentDic:(NSDictionary *)parentDic parentRows:(NSArray *)parentStrings childRows:(NSArray *)childStrings initialParentSelection:(NSInteger)parentIndex initialChildSelection:(NSInteger)childIndex doneBlock:(ActionStringDependentDoneBlock)doneBlock cancelBlock:(ActionStringDependeantCancelBlock)cancelBlock origin:(id)origin;

- (id)initWithTitle:(NSString *)title parentDic:(NSDictionary *)parentDic parentRows:(NSArray *)parentStrings childRows:(NSArray *)childStrings initialParentSelection:(NSInteger)parentIndex initialChildSelection:(NSInteger)childIndex doneBlock:(ActionStringDependentDoneBlock)doneBlock cancelBlock:(ActionStringDependeantCancelBlock)cancelBlockOrNil origin:(id)origin;

@property (nonatomic, copy) ActionStringDependentDoneBlock onActionSheetDone;
@property (nonatomic, copy) ActionStringDependeantCancelBlock onActionSheetCancel;

@end