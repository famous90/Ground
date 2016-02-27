//
//  ImageDataController.h
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 8. 23..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageDataController : NSObject

@property (nonatomic, strong) NSMutableArray *masterData;

- (NSInteger)countOfList;
- (UIImage *)imageWithId:(NSInteger)idNumber;
- (void)addObjectWithImage:(UIImage *)image withId:(NSInteger)idNumber;
- (void)removeAll;
- (BOOL)isIdInListWithId:(NSInteger)idNumber;
//- (UIImage *)imageWithUrl:(NSString *)imageUrl withId:(NSInteger)idNumber;

@end
