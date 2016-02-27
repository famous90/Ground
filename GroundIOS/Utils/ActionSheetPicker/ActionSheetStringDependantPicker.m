//
//  ActionSheetStringDependantPicker.m
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 7. 27..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#define PARENTCOMPONENT 0
#define CHILDCOMPONENT  1

#import "ActionSheetStringDependantPicker.h"
#import <objc/message.h>

@interface ActionSheetStringDependantPicker()
@property (nonatomic,strong) NSDictionary *parentDic;
@property (nonatomic,strong) NSArray *parentData;
@property (nonatomic,strong) NSArray *childData;
@property (nonatomic,assign) NSInteger selectedParentIndex;
@property (nonatomic,assign) NSInteger selectedChildIndex;
@end

@implementation ActionSheetStringDependantPicker

+ (id)showPickerWithTitle:(NSString *)title parentDic:(NSDictionary *)parentDic parentRows:(NSArray *)parentStrings childRows:(NSArray *)childStrings initialParentSelection:(NSInteger)parentIndex initialChildSelection:(NSInteger)childIndex doneBlock:(ActionStringDependentDoneBlock)doneBlock cancelBlock:(ActionStringDependeantCancelBlock)cancelBlock origin:(id)origin
{
    ActionSheetStringDependantPicker * picker = [[ActionSheetStringDependantPicker alloc] initWithTitle:title parentDic:parentDic parentRows:parentStrings childRows:childStrings initialParentSelection:parentIndex initialChildSelection:childIndex doneBlock:doneBlock cancelBlock:cancelBlock origin:origin];
    [picker showActionSheetPicker];
    return picker;
}

- (id)initWithTitle:(NSString *)title parentDic:(NSDictionary *)parentDic parentRows:(NSArray *)parentStrings childRows:(NSArray *)childStrings initialParentSelection:(NSInteger)parentIndex initialChildSelection:(NSInteger)childIndex doneBlock:(ActionStringDependentDoneBlock)doneBlock cancelBlock:(ActionStringDependeantCancelBlock)cancelBlockOrNil origin:(id)origin
{
    self = [self initWithTitle:title parentDic:parentDic parentRows:parentStrings childRows:childStrings initialParentSelection:parentIndex initialChildSelection:childIndex target:nil successAction:nil cancelAction:nil origin:origin];
    if (self) {
        self.onActionSheetDone = doneBlock;
        self.onActionSheetCancel = cancelBlockOrNil;
    }
    return self;
}

+ (id)showPickerWithTitle:(NSString *)title parentDic:(NSDictionary *)parentDic parentRows:(NSArray *)parentData childRows:(NSArray *)childData initialParentSelection:(NSInteger)parentIndex initialChildSelection:(NSInteger)childIndex target:(id)target successAction:(SEL)successAction cancelAction:(SEL)cancelActionOrNil origin:(id)origin
{
    ActionSheetStringDependantPicker *picker = [[ActionSheetStringDependantPicker alloc] initWithTitle:title parentDic:parentDic parentRows:parentData childRows:childData initialParentSelection:parentIndex initialChildSelection:childIndex target:target successAction:successAction cancelAction:cancelActionOrNil origin:origin];
    [picker showActionSheetPicker];
    return picker;
}

- (id)initWithTitle:(NSString *)title parentDic:(NSDictionary *)parentDic parentRows:(NSArray *)parentData childRows:(NSArray *)childData initialParentSelection:(NSInteger)parentIndex initialChildSelection:(NSInteger)childIndex target:(id)target successAction:(SEL)successAction cancelAction:(SEL)cancelActionOrNil origin:(id)origin
{
    self = [self initWithTarget:target successAction:successAction cancelAction:cancelActionOrNil origin:origin];
    if (self) {
        self.parentDic = parentDic;
        self.parentData = parentData;
        self.childData = childData;
        self.selectedParentIndex = parentIndex;
        self.selectedChildIndex = childIndex;
        self.title = title;
    }
    return self;
}


- (UIView *)configuredPickerView {
    if (!self.parentDic)
        return nil;
    CGRect pickerFrame = CGRectMake(0, 40, self.viewSize.width, 216);
    UIPickerView *stringPicker = [[UIPickerView alloc] initWithFrame:pickerFrame];
    stringPicker.delegate = self;
    stringPicker.dataSource = self;
    stringPicker.showsSelectionIndicator = YES;
    [stringPicker selectRow:self.selectedParentIndex inComponent:PARENTCOMPONENT animated:NO];
    [stringPicker selectRow:self.selectedChildIndex inComponent:CHILDCOMPONENT animated:NO];

    
    self.pickerView = stringPicker;
    
    return stringPicker;
}

- (void)notifyTarget:(id)target didSucceedWithAction:(SEL)successAction origin:(id)origin {
    if (target && [target respondsToSelector:successAction]) {
        objc_msgSend(target, successAction, [NSNumber numberWithInt:self.selectedParentIndex], [NSNumber numberWithInt:self.selectedChildIndex], origin);
        return;
    }
    NSLog(@"Invalid target/action ( %s / %s ) combination used for ActionSheetPicker", object_getClassName(target), sel_getName(successAction));
}

#pragma mark - UIPickerViewDelegate / DataSource

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if(component == PARENTCOMPONENT){
        NSString *selectedParent = self.parentData[row];
        self.selectedParentIndex = row;
        self.childData = self.parentDic[selectedParent];
        [pickerView reloadComponent:CHILDCOMPONENT];
        [pickerView selectRow:0 inComponent:CHILDCOMPONENT animated:YES];
    }else if (component == CHILDCOMPONENT){
        self.selectedChildIndex = row;
    }else{
        NSLog(@"Dependent picker row selection error");
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if(component == PARENTCOMPONENT){
        return [self.parentData count];
    }else if(component == CHILDCOMPONENT){
        return [self.childData count];
    }else{
        NSLog(@"Dependent Picker Count load error");
        return 0;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if(component == PARENTCOMPONENT){
        return self.parentData[row];
    }else if(component == CHILDCOMPONENT){
        return self.childData[row];
    }else{
        NSLog(@"Dependent picker row factor load error");
        return nil;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if(component == PARENTCOMPONENT){
        return (pickerView.frame.size.width - 30)/2;
    }else if(component == CHILDCOMPONENT){
        return (pickerView.frame.size.width - 30)/2;
    }else{
        NSLog(@"Dependent picker width load error");
        return 0;
    }
}

@end