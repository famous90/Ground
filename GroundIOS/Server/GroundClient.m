//
//  GroundClient.m
//  httpPrac
//
//  Created by Jet on 13. 6. 7..
//  Copyright (c) 2013년 Jet. All rights reserved.
//

#import "GroundClient.h"

#import "LoginRequest.h"
#import "FacebookLoginRequest.h"
#import "ValidateEmailRequest.h"
#import "EmailRegisterRequest.h"
#import "EditProfileRequest.h"
#import "FeedListRequest.h"
#import "InviteMemberRequest.h"
#import "PendingTeamInvitationRequest.h"
#import "AcceptTeamInvitationRequest.h"
#import "DenyTeamInvitationRequest.h"
#import "RemoveAccountRequest.h"
#import "ChangePasswordRequest.h"
#import "UserInfoRequest.h"
#import "ImageUploadRequest.h"
#import "ImageDownloadRequest.h"
#import "PostListRequest.h"
#import "WritePostRequest.h"
#import "RemovePostRequest.h"
#import "CommentListRequest.h"
#import "AddCommentRequest.h"
#import "RemoveCommentRequest.h"
#import "TeamListRequest.h"
#import "TeamInfoRequest.h"
#import "RegisterTeamRequest.h"
#import "EditTeamProfileRequest.h"
#import "SearchTeamRequest.h"
#import "TeamMembersListRequest.h"
#import "JoinTeamRequest.h"
#import "PendingMembersListRequest.h"
#import "AcceptMemberRequest.h"
#import "DenyMemberRequest.h"
#import "ChangeManagerRequest.h"
#import "LeaveTeamRequest.h"
#import "MatchListRequest.h"
#import "MatchInfoRequest.h"
#import "MatchHistoryRequest.h"
#import "CreateMatchRequest.h"
#import "SearchMatchRequest.h"
#import "JoinMatchRequest.h"
#import "InviteTeamRequest.h"
#import "RequestMatchRequest.h"
#import "AcceptMatchRequest.h"
#import "DenyMatchRequest.h"
#import "CancelMatchRequest.h"
#import "SetScoreRequest.h"
#import "AcceptScoreRequest.h"
#import "JoinedMemebersListRequest.h"
#import "StartJoinSurveyRequest.h"
#import "PushSurveyRequest.h"
#import "PushTargettedSurveyRequest.h"
#import "RegisterGroundRequest.h"
#import "SearchGroundRequest.h"
#import "SearchTeamNearbyRequest.h"
#import "MessageListRequest.h"
#import "TeamHintRequest.h"
#import "LogoutRequest.h"

#import "StringUtils.h"
#import "ViewUtil.h"
#import "SBJson.h"

@implementation GroundClient

static GroundClient* instance;

HttpConnectionBlock callback = nil;
HttpMultipartConnectionBlock multipartCallback = nil;

+ (GroundClient*)getInstance
{
    return instance;
}

+ (void)singleton
{
    instance = [[GroundClient alloc] init];
}

/*************** User Login & Register ***************/
- (void)login:(NSString*)loginId withPw:(NSString*)loginPw callback:(HttpConnectionBlock)httpConnBlock
{
    // request 객체 생성.
    LoginRequest* request = [[LoginRequest alloc] init];
    
    // request에 변수값 입력.
    [request setEmail:loginId];
    [request setPassword:loginPw];
    
    // callback function 준비
    if( httpConnBlock )
        callback = [httpConnBlock copy];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    [[HttpConnection alloc] initWithRequest:request delegate:self context:callback method:@"POST"];
#pragma clang diagnostic pop
}

- (void)facebookLogin:facebookInfo callback:(HttpConnectionBlock)httpConnBlock
{
    // request 객체 생성.
    FacebookLoginRequest* request = [[FacebookLoginRequest alloc] init];
    
    // request에 변수값 입력.
    [request setName:[facebookInfo valueForKey:@"name"]];
    [request setEmail:[facebookInfo valueForKey:@"email"]];
    [request setImageUrl:[facebookInfo valueForKey:@"imageUrl"]];
    
    // callback function 준비
    if( httpConnBlock )
        callback = [httpConnBlock copy];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    [[HttpConnection alloc] initWithRequest:request delegate:self context:callback method:@"POST"];
#pragma clang diagnostic pop
}

- (void)validateEmail:(NSString *)email callback:(HttpConnectionBlock)httpConnBlock
{
    ValidateEmailRequest* request = [[ValidateEmailRequest alloc] init];
    
    [request setEmail:email];
    
    if(httpConnBlock)
        callback = [httpConnBlock copy];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    [[HttpConnection alloc] initWithRequest:request delegate:self context:callback method:@"POST"];
#pragma clang diagnostic pop
}

- (void)emailRegister:(NSString*)registerId withPw:(NSString*)registerPswd callback:(HttpConnectionBlock)httpConnBlock
{
    EmailRegisterRequest* request = [[EmailRegisterRequest alloc] init];
    
    [request setEmail:registerId];
    [request setPassword:registerPswd];
    
    if(httpConnBlock)
        callback = [httpConnBlock copy];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    [[HttpConnection alloc] initWithRequest:request delegate:self context:callback method:@"POST"];
#pragma clang diagnostic pop
    
}

- (void)editProfile:(UserInfo*)user callback:(HttpConnectionBlock)httpConnBlock
{
    EditProfileRequest* request = [[EditProfileRequest alloc] init];
    
    [request setUserInfo:user];
    
    if(httpConnBlock)
        callback = [httpConnBlock copy];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    [[HttpConnection alloc] initWithRequest:request delegate:self context:callback method:@"POST"];
#pragma clang diagnostic pop
}

/*************** User Feed & Invitation ***************/
- (void)getFeedList:(NSInteger)LastFeedId callback:(HttpConnectionBlock)httpConnBlock
{
    FeedListRequest* request = [[FeedListRequest alloc] init];
    
    [request setLastFeedId:LastFeedId];
    
    if( httpConnBlock )
        callback = [httpConnBlock copy];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    [[HttpConnection alloc] initWithRequest:request delegate:self context:callback method:@"POST"];
#pragma clang diagnostic pop
}

- (void)InviteMember:(NSInteger)teamId userId:(NSInteger)userId callback:(HttpConnectionBlock)httpConnBlock
{
    InviteMemberRequest* request = [[InviteMemberRequest alloc] init];
    
    [request setTeamId:teamId];
    [request setUserId:userId];
    
    if( httpConnBlock )
        callback = [httpConnBlock copy];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    [[HttpConnection alloc] initWithRequest:request delegate:self context:callback method:@"POST"];
#pragma clang diagnostic pop
}

- (void)getPendingTeamInvitationList:(HttpConnectionBlock)httpConnBlock
{
    PendingTeamInvitationRequest* request = [[PendingTeamInvitationRequest alloc] init];
    
    if( httpConnBlock )
        callback = [httpConnBlock copy];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    [[HttpConnection alloc] initWithRequest:request delegate:self context:callback method:@"POST"];
#pragma clang diagnostic pop
}

- (void)acceptTeamInvitation:(NSInteger)teamId callback:(HttpConnectionBlock)httpConnBlock
{
    AcceptTeamInvitationRequest* request = [[AcceptTeamInvitationRequest alloc] init];
    
    [request setTeamId:teamId];
    
    if( httpConnBlock )
        callback = [httpConnBlock copy];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    [[HttpConnection alloc] initWithRequest:request delegate:self context:callback method:@"POST"];
#pragma clang diagnostic pop
}

- (void)denyTeamInvitation:(NSInteger)teamId callback:(HttpConnectionBlock)httpConnBlock
{
    DenyTeamInvitationRequest* request = [[DenyTeamInvitationRequest alloc] init];
    
    [request setTeamId:teamId];
    
    if( httpConnBlock )
        callback = [httpConnBlock copy];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    [[HttpConnection alloc] initWithRequest:request delegate:self context:callback method:@"POST"];
#pragma clang diagnostic pop
}

/*************** User 기타 ***************/
- (void)removeAccount:(HttpConnectionBlock)httpConnBlock
{
    RemoveAccountRequest* request = [[RemoveAccountRequest alloc] init];
    
    if( httpConnBlock )
        callback = [httpConnBlock copy];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    [[HttpConnection alloc] initWithRequest:request delegate:self context:callback method:@"POST"];
#pragma clang diagnostic pop
}

- (void)changePassword:(NSString*)thePassword callback:(HttpConnectionBlock)httpConnBlock
{
    ChangePasswordRequest* request = [[ChangePasswordRequest alloc] init];
    
    [request setThePassword:thePassword];
    
    if( httpConnBlock )
        callback = [httpConnBlock copy];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    [[HttpConnection alloc] initWithRequest:request delegate:self context:callback method:@"POST"];
#pragma clang diagnostic pop
}

- (void)getUserInfo:(NSInteger)userId callback:(HttpConnectionBlock)httpConnBlock
{
    UserInfoRequest* request = [[UserInfoRequest alloc] init];
    
    [request setUserId:userId];
    
    if(httpConnBlock)
        callback = [httpConnBlock copy];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    [[HttpConnection alloc] initWithRequest:request delegate:self context:callback method:@"POST"];
#pragma clang diagnostic pop
}

/*************** Image Upload & Download ***************/
- (void)uploadProfileImage:(UIImage*)image thumbnail:(BOOL)thumbnail multipartCallback:(HttpMultipartConnectionBlock)httpConnBlock
{
    ImageUploadRequest* request = [[ImageUploadRequest alloc] init];
    
    // 이미지를 http request에 데이터형식으로 저장하기 위해 변환.
    [request convertImageToData:image];
    [request setThumbnail:thumbnail];
    
    if(httpConnBlock)
        multipartCallback = [httpConnBlock copy];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    [[HttpMultipartConnection alloc] initWithRequest:request delegate:self context:multipartCallback method:@"POST"];
#pragma clang diagnostic pop
}

- (void)downloadProfileImage:(NSString*)imagePath thumbnail:(BOOL)thumbnail callback:(HttpConnectionBlock)httpConnBlock
{
    // FACEBOOK IMAGE URL
    if ([ViewUtil isImagePathUrl:imagePath]) {

        NSMutableDictionary* dataDictionary = nil;
        NSURL *url = [NSURL URLWithString:imagePath];
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:url];
        UIImage *theImage = [[UIImage alloc] initWithData:imageData];

        if (theImage) {
            dataDictionary = [NSMutableDictionary dictionaryWithObject:theImage forKey:@"image"];
            httpConnBlock(YES, dataDictionary);
        }else{
            httpConnBlock(NO, dataDictionary);
        }
        
    // AND SERVER IAMGE URL
    }else{
        
        ImageDownloadRequest* request = [[ImageDownloadRequest alloc] init];
        
        [request setImagePath:imagePath];
        [request setThumbnail:thumbnail];
        
        if( httpConnBlock )
            callback = [httpConnBlock copy];
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
        [[HttpConnection alloc] initWithRequest:request delegate:self context:callback method:@"POST"];
#pragma clang diagnostic pop        
    }
}

/*************** Team ***************/
- (void)getTeamHintWithTeamId:(NSInteger)teamId callback:(HttpConnectionBlock)httpConnBlock
{
    TeamHintRequest *request = [[TeamHintRequest alloc] init];
    
    [request setTeamId:teamId];
    
    if(httpConnBlock)
        callback = [httpConnBlock copy];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    [[HttpConnection alloc] initWithRequest:request delegate:self context:callback method:@"POST"];
#pragma clang diagnostic pop
}

- (void)getTeamList:(HttpConnectionBlock)httpConnBlock
{
    TeamListRequest* request = [[TeamListRequest alloc] init];
    
    if(httpConnBlock)
        callback = [httpConnBlock copy];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    [[HttpConnection alloc] initWithRequest:request delegate:self context:callback method:@"POST"];
#pragma clang diagnostic pop
}

- (void)getTeamInfo:(NSInteger)teamId callback:(HttpConnectionBlock)httpConnBlock
{
    TeamInfoRequest* request = [[TeamInfoRequest alloc] init];
    
    [request setTeamId:teamId];
    
    if(httpConnBlock)
        callback = [httpConnBlock copy];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    [[HttpConnection alloc] initWithRequest:request delegate:self context:callback method:@"POST"];
#pragma clang diagnostic pop
}

- (void)registerTeam:(TeamInfo*)teamInfo callback:(HttpConnectionBlock)httpConnBlock
{
    RegisterTeamRequest* request = [[RegisterTeamRequest alloc] init];
    
    [request setTeamInfo:teamInfo];
    
    if(httpConnBlock)
        callback = [httpConnBlock copy];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    [[HttpConnection alloc] initWithRequest:request delegate:self context:callback method:@"POST"];
#pragma clang diagnostic pop
}

- (void)editTeamProfile:(TeamInfo *)teamInfo callback:(HttpConnectionBlock)httpConnBlock
{
    EditTeamProfileRequest* request = [[EditTeamProfileRequest alloc] init];
    
    [request setTeamInfo:teamInfo];
    
    if(httpConnBlock)
        callback = [httpConnBlock copy];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    [[HttpConnection alloc] initWithRequest:request delegate:self context:callback method:@"POST"];
#pragma clang diagnostic pop
}

- (void)searchTeam:(NSString*)name callback:(HttpConnectionBlock)httpConnBlock
{
    SearchTeamRequest* request = [[SearchTeamRequest alloc] init];
    
    [request setName:name];
    
    if(httpConnBlock)
        callback = [httpConnBlock copy];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    [[HttpConnection alloc] initWithRequest:request delegate:self context:callback method:@"POST"];
#pragma clang diagnostic pop
}

/*************** Team Members ***************/
- (void)getTeamMembersList:(NSInteger)teamId callback:(HttpConnectionBlock)httpConnBlock
{
    TeamMembersListRequest* request = [[TeamMembersListRequest alloc] init];
    
    [request setTeamId:teamId];
    
    if(httpConnBlock)
        callback = [httpConnBlock copy];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    [[HttpConnection alloc] initWithRequest:request delegate:self context:callback method:@"POST"];
#pragma clang diagnostic pop
}

- (void)joinTeam:(NSInteger)teamId callback:(HttpConnectionBlock)httpConnBlock
{
    JoinTeamRequest* request = [[JoinTeamRequest alloc] init];
    
    [request setTeamId:teamId];
    
    if(httpConnBlock)
        callback = [httpConnBlock copy];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    [[HttpConnection alloc] initWithRequest:request delegate:self context:callback method:@"POST"];
#pragma clang diagnostic pop
}

- (void)getPendingMembersList:(NSInteger)teamId callback:(HttpConnectionBlock)httpConnBlock
{
    PendingMembersListRequest* request = [[PendingMembersListRequest alloc] init];
    
    [request setTeamId:teamId];
    
    if(httpConnBlock)
        callback = [httpConnBlock copy];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    [[HttpConnection alloc] initWithRequest:request delegate:self context:callback method:@"POST"];
#pragma clang diagnostic pop
}

- (void)acceptMember:(NSInteger)memberId teamId:(NSInteger)teamId callback:(HttpConnectionBlock)httpConnBlock
{
    AcceptMemberRequest* request = [[AcceptMemberRequest alloc] init];
    
    [request setMemberId:memberId];
    [request setTeamId:teamId];
    
    if(httpConnBlock)
        callback = [httpConnBlock copy];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    [[HttpConnection alloc] initWithRequest:request delegate:self context:callback method:@"POST"];
#pragma clang diagnostic pop
}

- (void)DenyMember:(NSInteger)memberId teamId:(NSInteger)teamId callback:(HttpConnectionBlock)httpConnBlock
{
    DenyMemberRequest* request = [[DenyMemberRequest alloc] init];
    
    [request setMemberId:memberId];
    [request setTeamId:teamId];
    
    if(httpConnBlock)
        callback = [httpConnBlock copy];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    [[HttpConnection alloc] initWithRequest:request delegate:self context:callback method:@"POST"];
#pragma clang diagnostic pop
}

- (void)changeManager:(NSInteger)teamId newManagerId:(NSArray *)theManagerId oldManagerId:(NSArray *)oldManagerId callback:(HttpConnectionBlock)httpConnBlock
{
    ChangeManagerRequest* request = [[ChangeManagerRequest alloc] init];
    
    [request setTeamId:teamId];
    [request setTheManagerId:theManagerId];
    [request setOldManagerId:oldManagerId];
    
    if(httpConnBlock)
        callback = [httpConnBlock copy];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    [[HttpConnection alloc] initWithRequest:request delegate:self context:callback method:@"POST"];
#pragma clang diagnostic pop
}

- (void)leaveTeam:(NSInteger)teamId callback:(HttpConnectionBlock)httpConnBlock
{
    LeaveTeamRequest *request = [[LeaveTeamRequest alloc] init];
    
    [request setTeamId:teamId];
    
    if(httpConnBlock)
        callback = [httpConnBlock copy];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    [[HttpConnection alloc] initWithRequest:request delegate:self context:callback method:@"POST"];
#pragma clang diagnostic pop
}

/*************** Board ***************/
- (void)getPostList:(NSInteger)teamId lastPostId:(NSInteger)LastPostId callback:(HttpConnectionBlock)httpConnBlock
{
    PostListRequest* request = [[PostListRequest alloc] init];
    
    [request setTeamId:teamId];
    [request setLastPostId:LastPostId];
    
    if(httpConnBlock)
        callback = [httpConnBlock copy];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    [[HttpConnection alloc] initWithRequest:request delegate:self context:callback method:@"POST"];
#pragma clang diagnostic pop
}

- (void)wrtiePost:(Post*)post callback:(HttpConnectionBlock)httpConnBlock
{
    WritePostRequest* request = [[WritePostRequest alloc] init];
    
    [request setPost:post];
    
    if(httpConnBlock)
        callback = [httpConnBlock copy];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    [[HttpConnection alloc] initWithRequest:request delegate:self context:callback method:@"POST"];
#pragma clang diagnostic pop
}

- (void)removePost:(Post*)post callback:(HttpConnectionBlock)httpConnBlock
{
    RemovePostRequest* request = [[RemovePostRequest alloc] init];
    
    [request setPost:post];
    
    if(httpConnBlock)
        callback = [httpConnBlock copy];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    [[HttpConnection alloc] initWithRequest:request delegate:self context:callback method:@"POST"];
#pragma clang diagnostic pop    
}

- (void)getCommentListWithTeamId:(NSInteger)teamId withPostId:(NSInteger)postId callback:(HttpConnectionBlock)httpConnBlock
{
    CommentListRequest* request = [[CommentListRequest alloc] init];
    
    [request setPostId:postId];
    [request setTeamId:teamId];
    
    if(httpConnBlock)
        callback = [httpConnBlock copy];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    [[HttpConnection alloc] initWithRequest:request delegate:self context:callback method:@"POST"];
#pragma clang diagnostic pop
}

- (void)addCommentWithTeam:(NSInteger)teamId withPost:(NSInteger)postId comment:(NSString *)comment callback:(HttpConnectionBlock)httpConnBlock
{
    AddCommentRequest* request = [[AddCommentRequest alloc] init];
    
    [request setTeamId:teamId];
    [request setPostId:postId];
    [request setComment:comment];
    
    if(httpConnBlock)
        callback = [httpConnBlock copy];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    [[HttpConnection alloc] initWithRequest:request delegate:self context:callback method:@"POST"];
#pragma clang diagnostic pop
}

- (void)removeComment:(NSInteger)postId commentId:(NSInteger)commentId callback:(HttpConnectionBlock)httpConnBlock
{
    RemoveCommentRequest* request = [[RemoveCommentRequest alloc] init];
    
    [request setPostId:postId];
    [request setCommentId:commentId];
    
    if(httpConnBlock)
        callback = [httpConnBlock copy];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    [[HttpConnection alloc] initWithRequest:request delegate:self context:callback method:@"POST"];
#pragma clang diagnostic pop
}

/*************** Match ***************/
- (void)getMatchList:(NSInteger)teamId callback:(HttpConnectionBlock)httpConnBlock
{
    MatchListRequest* request = [[MatchListRequest alloc] init];
    
    [request setTeamId:teamId];
    
    if(httpConnBlock)
        callback = [httpConnBlock copy];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    [[HttpConnection alloc] initWithRequest:request delegate:self context:callback method:@"POST"];
#pragma clang diagnostic pop
}

- (void)getMatchInfo:(NSInteger)matchId teamId:(NSInteger)teamId callback:(HttpConnectionBlock)httpConnBlock
{
    MatchInfoRequest* request = [[MatchInfoRequest alloc] init];
    
    [request setMatchId:matchId];
    [request setTeamId:teamId];
    
    if(httpConnBlock)
        callback = [httpConnBlock copy];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    [[HttpConnection alloc] initWithRequest:request delegate:self context:callback method:@"POST"];
#pragma clang diagnostic pop
}

- (void)getMatchHistory:(NSInteger)teamId lastMatchId:(NSInteger)lastMatchId callback:(HttpConnectionBlock)httpConnBlock
{
    MatchHistoryRequest* request = [[MatchHistoryRequest alloc] init];
    
    [request setTeamId:teamId];
    [request setLastMatchId:lastMatchId];
    
    if(httpConnBlock)
        callback = [httpConnBlock copy];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    [[HttpConnection alloc] initWithRequest:request delegate:self context:callback method:@"POST"];
#pragma clang diagnostic pop
}

- (void)createMatchWithMatchInfo:(MatchInfo *)matchInfo callback:(HttpConnectionBlock)httpConnBlock
{
    CreateMatchRequest* request = [[CreateMatchRequest alloc] init];
    
    [request setMatchInfo:matchInfo];
    
    if(httpConnBlock)
        callback = [httpConnBlock copy];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    [[HttpConnection alloc] initWithRequest:request delegate:self context:callback method:@"POST"];
#pragma clang diagnostic pop
}

- (void)searchMatchWithStartTime:(NSTimeInterval)startTime endTime:(NSTimeInterval)endTime latitude:(NSNumber *)latitude longitude:(NSNumber *)longitude distance:(NSInteger)distance callback:(HttpConnectionBlock)httpConnBlock
{
    SearchMatchRequest* request = [[SearchMatchRequest alloc] init];
    
    [request setStartTime:startTime];
    [request setEndTime:endTime];
    [request setLatitude:latitude];
    [request setLongitude:longitude];
    [request setDistance:distance];
    
    if(httpConnBlock)
        callback = [httpConnBlock copy];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    [[HttpConnection alloc] initWithRequest:request delegate:self context:callback method:@"POST"];
#pragma clang diagnostic pop
}

- (void)searchTeamNearbyAtLatitude:(NSNumber *)latitude longitude:(NSNumber *)longitude distance:(NSInteger)distance callback:(HttpConnectionBlock)httpConnBlock
{
    SearchTeamNearbyRequest *request = [[SearchTeamNearbyRequest alloc] init];
    
    [request setLatitude:latitude];
    [request setLongituge:longitude];
    [request setDistance:distance];
    
    if (httpConnBlock) {
        callback = [httpConnBlock copy];
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    [[HttpConnection alloc] initWithRequest:request delegate:self context:callback method:@"POST"];
#pragma clang diagnostic pop
}

/*************** Match Process ***************/
- (void)joinMatch:(NSInteger)matchId teamId:(NSInteger)teamId join:(BOOL)join callback:(HttpConnectionBlock)httpConnBlock
{
    JoinMatchRequest* request = [[JoinMatchRequest alloc] init];
    
    [request setMatchId:matchId];
    [request setTeamId:teamId];
    [request setJoin:join];
    
    if(httpConnBlock)
        callback = [httpConnBlock copy];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    [[HttpConnection alloc] initWithRequest:request delegate:self context:callback method:@"POST"];
#pragma clang diagnostic pop
}

- (void)inviteTeamWithMatchId:(NSInteger)matchId hometeam:(NSInteger)homeTeamId awayTeam:(NSInteger)awayTeamId callback:(HttpConnectionBlock)httpConnBlock
{
    InviteTeamRequest* request = [[InviteTeamRequest alloc] init];
    
    [request setMatchId:matchId];
    [request setHomeTeamId:homeTeamId];
    [request setAwayTeamId:awayTeamId];
    
    if(httpConnBlock)
        callback = [httpConnBlock copy];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    [[HttpConnection alloc] initWithRequest:request delegate:self context:callback method:@"POST"];
#pragma clang diagnostic pop
}

- (void)requestMatch:(NSInteger)matchId hometeam:(NSInteger)homeTeamId awayTeam:(NSInteger)awayTeamId callback:(HttpConnectionBlock)httpConnBlock
{
    RequestMatchRequest* request = [[RequestMatchRequest alloc] init];
    
    [request setMatchId:matchId];
    [request setHomeTeamId:homeTeamId];
    [request setAwayTeamId:awayTeamId];
    
    if(httpConnBlock)
        callback = [httpConnBlock copy];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    [[HttpConnection alloc] initWithRequest:request delegate:self context:callback method:@"POST"];
#pragma clang diagnostic pop
}

- (void)acceptMatch:(NSInteger)matchId callback:(HttpConnectionBlock)httpConnBlock
{
    AcceptMatchRequest* request = [[AcceptMatchRequest alloc] init];
    
    [request setMatchId:matchId];
    
    if(httpConnBlock)
        callback = [httpConnBlock copy];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    [[HttpConnection alloc] initWithRequest:request delegate:self context:callback method:@"POST"];
#pragma clang diagnostic pop
}

- (void)denyMatch:(NSInteger)matchId teamId:(NSInteger)teamId callback:(HttpConnectionBlock)httpConnBlock
{
    DenyMatchRequest* request = [[DenyMatchRequest alloc] init];
    
    [request setMatchId:matchId];
    [request setTeamId:teamId];
    
    if(httpConnBlock)
        callback = [httpConnBlock copy];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    [[HttpConnection alloc] initWithRequest:request delegate:self context:callback method:@"POST"];
#pragma clang diagnostic pop
}

- (void)cancelMatch:(NSInteger)matchId teamId:(NSInteger)teamId callback:(HttpConnectionBlock)httpConnBlock
{
    CancelMatchRequest* request = [[CancelMatchRequest alloc] init];
    
    [request setMatchId:matchId];
    [request setTeamId:teamId];
    
    if(httpConnBlock)
        callback = [httpConnBlock copy];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    [[HttpConnection alloc] initWithRequest:request delegate:self context:callback method:@"POST"];
#pragma clang diagnostic pop
}

/*************** Match Score ***************/
- (void)setMatchScore:(Match*)match andIsMyTeamHome:(BOOL)isHome callback:(HttpConnectionBlock)httpConnBlock
{
    SetScoreRequest* request = [[SetScoreRequest alloc] init];
    
    [request setMatch:match andIsMyTeamHome:isHome];
    
    if(httpConnBlock)
        callback = [httpConnBlock copy];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    [[HttpConnection alloc] initWithRequest:request delegate:self context:callback method:@"POST"];
#pragma clang diagnostic pop
}

- (void)acceptMatchScoreInMatch:(NSInteger)matchId ByTeam:(NSInteger)teamId callback:(HttpConnectionBlock)httpConnBlock
{
    AcceptScoreRequest* request = [[AcceptScoreRequest alloc] init];
    
    [request setMatchId:matchId];
    [request setTeamId:teamId];
    
    if(httpConnBlock)
        callback = [httpConnBlock copy];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    [[HttpConnection alloc] initWithRequest:request delegate:self context:callback method:@"POST"];
#pragma clang diagnostic pop
}

/*************** Match 참불 ***************/
- (void)showJoinedMembersList:(NSInteger)matchId teamId:(NSInteger)teamId callback:(HttpConnectionBlock)httpConnBlock
{
    JoinedMemebersListRequest* request = [[JoinedMemebersListRequest alloc] init];
    
    [request setMatchId:matchId];
    [request setTeamId:teamId];
    
    if(httpConnBlock)
        callback = [httpConnBlock copy];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    [[HttpConnection alloc] initWithRequest:request delegate:self context:callback method:@"POST"];
#pragma clang diagnostic pop
}

- (void)startJoinSurvey:(NSInteger)matchId teamId:(NSInteger)teamId callback:(HttpConnectionBlock)httpConnBlock
{
    StartJoinSurveyRequest* request = [[StartJoinSurveyRequest alloc] init];
    
    [request setMatchId:matchId];
    [request setTeamId:teamId];
    
    if(httpConnBlock)
        callback = [httpConnBlock copy];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    [[HttpConnection alloc] initWithRequest:request delegate:self context:callback method:@"POST"];
#pragma clang diagnostic pop
}

- (void)pushJoinSurvey:(NSInteger)matchId teamId:(NSInteger)teamId callback:(HttpConnectionBlock)httpConnBlock
{
    PushSurveyRequest* request = [[PushSurveyRequest alloc] init];
    
    [request setMatchId:matchId];
    [request setTeamId:teamId];
    
    if(httpConnBlock)
        callback = [httpConnBlock copy];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    [[HttpConnection alloc] initWithRequest:request delegate:self context:callback method:@"POST"];
#pragma clang diagnostic pop
}

- (void)pushJoinTargettedSurveyWithMatchId:(NSInteger)matchId teamId:(NSInteger)teamId pushIds:(NSArray *)pushUserIds callback:(HttpConnectionBlock)httpConnBlock
{
    PushTargettedSurveyRequest *request = [[PushTargettedSurveyRequest alloc] init];
    
    [request setMatchId:matchId];
    [request setTeamId:teamId];
    [request setPushUserIds:pushUserIds];
    
    if (httpConnBlock) {
        callback = [httpConnBlock copy];
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    [[HttpConnection alloc] initWithRequest:request delegate:self context:callback method:@"POST"];
#pragma clang diagnostic pop    
}

/*************** Ground ***************/
- (void)registerGround:(Ground*)ground callback:(HttpConnectionBlock)httpConnBlock
{
    RegisterGroundRequest* request = [[RegisterGroundRequest alloc] init];
    
    [request setGround:ground];
    
    if(httpConnBlock)
        callback = [httpConnBlock copy];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    [[HttpConnection alloc] initWithRequest:request delegate:self context:callback method:@"POST"];
#pragma clang diagnostic pop
}

- (void)searchGround:(NSString*)name callback:(HttpConnectionBlock)httpConnBlock
{
    SearchGroundRequest* request = [[SearchGroundRequest alloc] init];
    
    [request setName:name];
    
    if(httpConnBlock)
        callback = [httpConnBlock copy];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    [[HttpConnection alloc] initWithRequest:request delegate:self context:callback method:@"POST"];
#pragma clang diagnostic pop
}

/******************** CHATTING ********************/
- (void)getMessageList:(NSInteger)matchId teamId:(NSInteger)teamId cur:(NSInteger)cur callback:(HttpConnectionBlock)httpConnBlock
{
    MessageListRequest* request = [[MessageListRequest alloc] init];
    
    [request setMatchId:matchId];
    [request setTeamId:teamId];
    [request setCur:cur];
    
    if(httpConnBlock)
        callback = [httpConnBlock copy];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    [[HttpConnection alloc] initWithRequest:request delegate:self context:callback method:@"POST"];
#pragma clang diagnostic pop
}

/******************** LOGOUT ********************/
- (void)logout:(NSString*)devicedUuid callback:(HttpConnectionBlock)httpConnBlock
{
    LogoutRequest *request = [[LogoutRequest alloc] init];
    
    [request setDeviceUuid:devicedUuid];
    
    if(httpConnBlock)
        callback = [httpConnBlock copy];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    [[HttpConnection alloc] initWithRequest:request delegate:self context:callback method:@"POST"];
#pragma clang diagnostic pop
}

/*************** Delegate Parts ***************/

#pragma mark HtthConnectionProtocol의 method 구현부 : callback부분 포함.

- (void)connectionDidFinish:(HttpConnection *)httpConn
{
    [self respondToRequestWithResult:YES httpConnection:httpConn];
}

- (void)connectionDidFail:(HttpConnection *)httpConn
{
    [self respondToRequestWithResult:NO httpConnection:httpConn];
}

// 서버로부터 받은 response처리하는 부분. 에러 포함.
- (void)respondToRequestWithResult:(BOOL)result httpConnection:(HttpConnection *)httpConn
{
    if(result){
        HttpConnectionBlock callback = (HttpConnectionBlock)httpConn.context;
        
        if(callback){
            // 에러메세지 구분하는 code
            NSInteger code = -1;
            NSMutableDictionary* dataDictionary = nil;
            
            if(httpConn.receivedData){
                // 받은 데이터가 있을 때 그 데이터를 Json String에서 Dictionary Type으로 decoding.
                NSString* dataJson = [[NSString alloc] initWithData:httpConn.receivedData encoding:NSUTF8StringEncoding];
                
                // 이미지 다운로드시에만 받은 데이터를 바로 이미지로 변환(binarydata into image)
                if([[StringUtils getInstance] stringIsEmpty:dataJson]){
                    UIImage* image = [UIImage imageWithData:httpConn.receivedData];
                    dataDictionary = [NSMutableDictionary dictionaryWithObject:image forKey:@"image"];
                    code = 1;
                }else{
                    dataDictionary = [[[SBJsonParser alloc] init] objectWithString:dataJson];
                    code = [[dataDictionary objectForKey:@"code"] integerValue];
                }
                NSLog(@"response result = %@", dataDictionary);
            }

            // 0은 OK. 0 미만은 에러났을 경우.
            if((code == 0) || (code == 1)){
                // callback함수 호출!!
                callback(result, dataDictionary);
            }else{
                
                callback(NO, dataDictionary);
            }
        }
    }else{
        
        NSLog(@"SERVER ERROR!!");
        
        return;
    }
}

@end