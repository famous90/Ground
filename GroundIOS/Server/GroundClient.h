//
//  GroundClient.h
//  httpPrac
//
//  Created by Jet on 13. 6. 7..
//  Copyright (c) 2013년 Jet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpConnection.h"
#import "HttpMultipartConnection.h"

@class UserInfo;
@class TeamInfo;
@class Match;
@class MatchInfo;
@class Ground;
@class Post;

@interface GroundClient : NSObject<HttpConnectionDelegate, HttpMultipartConnectionDelegate>

typedef void(^HttpConnectionBlock)(BOOL, NSDictionary *);
typedef void(^HttpMultipartConnectionBlock)(BOOL, NSDictionary *);

+ (GroundClient*)getInstance;
+ (void)singleton;

// User  Login & Register
- (void)login:(NSString*)loginId withPw:(NSString*)loginPw callback:(HttpConnectionBlock)httpConnBlock;
- (void)facebookLogin:(NSDictionary*)facebookInfo callback:(HttpConnectionBlock)httpConnBlock;
- (void)validateEmail:(NSString *)email callback:(HttpConnectionBlock)httpConnBlock;
- (void)emailRegister:(NSString*)registerId withPw:(NSString*)registerPswd callback:(HttpConnectionBlock)httpConnBlock;
- (void)editProfile:(UserInfo*)user callback:(HttpConnectionBlock)httpConnBlock;

// User Feed & Invitation
- (void)getFeedList:(NSInteger)LastFeedId callback:(HttpConnectionBlock)httpConnBlock;
- (void)InviteMember:(NSInteger)teamId userId:(NSInteger)userId callback:(HttpConnectionBlock)httpConnBlock;
- (void)getPendingTeamInvitationList:(HttpConnectionBlock)httpConnBlock;
- (void)acceptTeamInvitation:(NSInteger)teamId callback:(HttpConnectionBlock)httpConnBlock;
- (void)denyTeamInvitation:(NSInteger)teamId callback:(HttpConnectionBlock)httpConnBlock;

// User 기타
- (void)removeAccount:(HttpConnectionBlock)httpConnBlock;
- (void)changePassword:(NSString*)thePassword callback:(HttpConnectionBlock)httpConnBlock;
- (void)getUserInfo:(NSInteger)userId callback:(HttpConnectionBlock)httpConnBlock;

// Image Upload & Download
- (void)uploadProfileImage:(UIImage*)image thumbnail:(BOOL)thumbnail multipartCallback:(HttpMultipartConnectionBlock)httpConnBlock;
- (void)downloadProfileImage:(NSString*)imagePath thumbnail:(BOOL)thumbnail callback:(HttpConnectionBlock)httpConnBlock;

// Team
- (void)getTeamHintWithTeamId:(NSInteger)teamId callback:(HttpConnectionBlock)httpConnBlock;
- (void)getTeamList:(HttpConnectionBlock)httpConnBlock;
- (void)getTeamInfo:(NSInteger)teamId callback:(HttpConnectionBlock)httpConnBlock;
- (void)registerTeam:(TeamInfo*)teamInfo callback:(HttpConnectionBlock)httpConnBlock;
- (void)editTeamProfile:(TeamInfo*)teamInfo callback:(HttpConnectionBlock)httpConnBlock;
- (void)searchTeam:(NSString*)name callback:(HttpConnectionBlock)httpConnBlock;
- (void)searchTeamNearbyAtLatitude:(NSNumber *)latitude longitude:(NSNumber *)longitude distance:(NSInteger)distance callback:(HttpConnectionBlock)httpConnBlock;

// Team Members
- (void)getTeamMembersList:(NSInteger)teamId callback:(HttpConnectionBlock)httpConnBlock;
- (void)joinTeam:(NSInteger)teamId callback:(HttpConnectionBlock)httpConnBlock;
- (void)getPendingMembersList:(NSInteger)teamId callback:(HttpConnectionBlock)httpConnBlock;
- (void)acceptMember:(NSInteger)memberId teamId:(NSInteger)teamId callback:(HttpConnectionBlock)httpConnBlock;
- (void)DenyMember:(NSInteger)memberId teamId:(NSInteger)teamId callback:(HttpConnectionBlock)httpConnBlock;
- (void)changeManager:(NSInteger)teamId newManagerId:(NSArray*)theManagerId oldManagerId:(NSArray*)oldManagerId callback:(HttpConnectionBlock)httpConnBlock;
- (void)leaveTeam:(NSInteger)teamId callback:(HttpConnectionBlock)httpConnBlock;

// Board
- (void)getPostList:(NSInteger)teamId lastPostId:(NSInteger)LastPostId callback:(HttpConnectionBlock)httpConnBlock;
- (void)wrtiePost:(Post*)post callback:(HttpConnectionBlock)httpConnBlock;
- (void)removePost:(Post*)post callback:(HttpConnectionBlock)httpConnBlock;
- (void)getCommentListWithTeamId:(NSInteger)teamId withPostId:(NSInteger)postId callback:(HttpConnectionBlock)httpConnBlock;
- (void)addCommentWithTeam:(NSInteger)teamId withPost:(NSInteger)postId comment:(NSString*)comment callback:(HttpConnectionBlock)httpConnBlock;
- (void)removeComment:(NSInteger)postId commentId:(NSInteger)commentId callback:(HttpConnectionBlock)httpConnBlock;

// Match
- (void)getMatchList:(NSInteger)teamId callback:(HttpConnectionBlock)httpConnBlock;
- (void)getMatchInfo:(NSInteger)matchId teamId:(NSInteger)teamId callback:(HttpConnectionBlock)httpConnBlock;
- (void)getMatchHistory:(NSInteger)teamId lastMatchId:(NSInteger)lastMatchId callback:(HttpConnectionBlock)httpConnBlock;
- (void)createMatchWithMatchInfo:(MatchInfo*)matchInfo callback:(HttpConnectionBlock)httpConnBlock;
- (void)searchMatchWithStartTime:(NSTimeInterval)startTime endTime:(NSTimeInterval)endTime latitude:(NSNumber *)latitude longitude:(NSNumber *)longitude distance:(NSInteger)distance callback:(HttpConnectionBlock)httpConnBlock;

// Match Process
- (void)joinMatch:(NSInteger)matchId teamId:(NSInteger)teamId join:(BOOL)join callback:(HttpConnectionBlock)httpConnBlock;
- (void)inviteTeamWithMatchId:(NSInteger)matchId hometeam:(NSInteger)homeTeamId awayTeam:(NSInteger)awayTeamId callback:(HttpConnectionBlock)httpConnBlock;
- (void)requestMatch:(NSInteger)matchId hometeam:(NSInteger)homeTeamId awayTeam:(NSInteger)awayTeamId callback:(HttpConnectionBlock)httpConnBlock;
- (void)acceptMatch:(NSInteger)matchId callback:(HttpConnectionBlock)httpConnBlock;
- (void)denyMatch:(NSInteger)matchId teamId:(NSInteger)teamId callback:(HttpConnectionBlock)httpConnBlock;
- (void)cancelMatch:(NSInteger)matchId teamId:(NSInteger)teamId callback:(HttpConnectionBlock)httpConnBlock;
// Match Score
- (void)setMatchScore:(Match*)match andIsMyTeamHome:(BOOL)isHome callback:(HttpConnectionBlock)httpConnBlock;
- (void)acceptMatchScoreInMatch:(NSInteger)matchId ByTeam:(NSInteger)teamId callback:(HttpConnectionBlock)httpConnBlock;
// Match 참불
- (void)showJoinedMembersList:(NSInteger)matchId teamId:(NSInteger)teamId callback:(HttpConnectionBlock)httpConnBlock;
- (void)startJoinSurvey:(NSInteger)matchId teamId:(NSInteger)teamId callback:(HttpConnectionBlock)httpConnBlock;
- (void)pushJoinSurvey:(NSInteger)matchId teamId:(NSInteger)teamId callback:(HttpConnectionBlock)httpConnBlock;
- (void)pushJoinTargettedSurveyWithMatchId:(NSInteger)matchId teamId:(NSInteger)teamId pushIds:(NSArray *)pushUserIds callback:(HttpConnectionBlock)httpConnBlock;

// Ground
- (void)registerGround:(Ground*)ground callback:(HttpConnectionBlock)httpConnBlock;
- (void)searchGround:(NSString*)name callback:(HttpConnectionBlock)httpConnBlock;

// chatting
- (void)getMessageList:(NSInteger)matchId teamId:(NSInteger)teamId cur:(NSInteger)cur callback:(HttpConnectionBlock)httpConnBlock;

//logout
- (void)logout:(NSString*)devicedUuid callback:(HttpConnectionBlock)httpConnBlock;

@end
