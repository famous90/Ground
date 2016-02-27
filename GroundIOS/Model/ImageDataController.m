//
//  ImageDataController.m
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 8. 23..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "ImageDataController.h"

@implementation ImageDataController

- (id)init
{
    self = [super init];
    if(self){
        self.masterData = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSInteger)countOfList
{
    return [self.masterData count];
}

- (UIImage *)imageWithId:(NSInteger)idNumber
{
    for( NSDictionary *object in self.masterData ){
        if([[object objectForKey:@"id"] integerValue] == idNumber)
            return [object objectForKey:@"image"];
    }
    return nil;
}

- (void)addObjectWithImage:(UIImage *)image withId:(NSInteger)idNumber
{
    if(![self isIdInListWithId:idNumber]){
        NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
        [data setObject:image forKey:@"image"];
        [data setObject:[NSNumber numberWithInt:idNumber] forKey:@"id"];
        [self.masterData addObject:data];
        return;
    }
    return;
}

- (void)removeAll
{
    [self.masterData removeAllObjects];
}

- (BOOL)isIdInListWithId:(NSInteger)idNumber
{
    for( NSDictionary *object in self.masterData ){
        if([[object objectForKey:@"id"] integerValue] == idNumber)
            return YES;
    }
    return NO;
}

//- (void)addImageUrlWithUrl:(NSString *)imageUrl withId:(NSInteger)idNumber
//{
//    if (![self isIdInListWithId:idNumber]) {
//        NSURL *url = [NSURL URLWithString:imageUrl];
//        NSData *data = [NSData dataWithContentsOfURL:url];
//        UIImage *theImage = [[UIImage alloc] initWithData:data];
//    }
//}

@end
