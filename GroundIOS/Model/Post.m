//
//  Post.m
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 7. 24..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "Post.h"
#import "SBJson.h"

@implementation Post

- (id)initInTeam:(NSInteger)teamId byWriterId:(NSInteger)userId byWriterName:(NSString *)userName withWriterImage:(NSString *)userImageUrl aboutMessage:(NSString *)message withExtra:(NSString *)extra
{
    self = [super init];
    if(self){
        _teamId = teamId;
        _userId = userId;
        _userName = userName;
        _userImageUrl = userImageUrl;
        _message = message;
        _postImageUrl = extra;
        
        return self;
    }
    return nil;
}

- (id)initPostWithData:(id)postData
{
    self = [super init];
    if(self){
        _postId = [[postData valueForKey:@"id"] integerValue];
        _type = [[postData valueForKey:@"type"] integerValue];
        _teamId = [[postData valueForKey:@"teamId"] integerValue];
        _userId = [[postData valueForKey:@"userId"] integerValue];
        _userName = [postData valueForKey:@"userName"];
        _userImageUrl = [postData valueForKey:@"userImageUrl"];
        _message = [postData valueForKey:@"message"];
        _createdAt = [[postData valueForKey:@"createdAt"] floatValue]/1000;
        _commentCount = [[postData valueForKey:@"commentCount"] integerValue];
        
        NSMutableDictionary *dataDictionary = [[[SBJsonParser alloc] init] objectWithString:[postData valueForKey:@"extra"]];
        _postImageUrl = [dataDictionary valueForKey:@"anb.ground.extra.imagePath"];
        _teamFeedType = [[dataDictionary valueForKey:@"type"] integerValue];
        if ([[dataDictionary valueForKey:@"memberId"] integerValue] != 0) {
            _userId = [[dataDictionary valueForKey:@"memberId"] integerValue];
            _userName = [dataDictionary valueForKey:@"memberName"];
        }
        if ([[dataDictionary valueForKey:@"teamId"] integerValue] != 0) {
            _teamId = [[dataDictionary valueForKey:@"teamId"] integerValue];
            _teamName = [dataDictionary valueForKey:@"teamName"];
        }
        _matchId = [[dataDictionary valueForKey:@"matchId"] integerValue];
    }
    return self;
}

- (BOOL)isPostImageInPost
{
    if([self.postImageUrl isEqual:[NSNull null]] || self.postImageUrl == NULL){
        NSLog(@"POST %d IMAGE NO", self.postId);
        return NO;
    }else{
        NSLog(@"POST %d IMAGE YES", self.postId);
        return YES;
    }
}

@end
