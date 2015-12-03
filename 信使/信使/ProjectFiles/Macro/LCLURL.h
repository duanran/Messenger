//
//  LCLURL.h
//  JoeRhymeLive
//
//  Created by 李程龙 on 15/5/6.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#ifndef JoeRhymeLive_LCLURL_h
#define JoeRhymeLive_LCLURL_h

#define XSURL       @"http://fille.wbteam.cn"
#define APIFolder   @"/index.php/Api"


//默认图片下载地址
#define DefaultImagePath     [[NSBundle mainBundle] pathForResource:@"pic_bg" ofType:@"png"]
//图片下载
#define GetDownloadPicURL(path) [NSString stringWithFormat:@"%@/%@", XSURL, path]


//隐私URL
#define YinSiTiaoKuanURL [NSString stringWithFormat:@"%@%@/Msg/r_msg", XSURL, APIFolder]



//获取城市列表
#define GetCityURL [NSString stringWithFormat:@"%@%@/Begin/cityList?", XSURL, APIFolder]
//登录URL
#define LoginURL [NSString stringWithFormat:@"%@%@/Login/login?", XSURL, APIFolder]
//登出
#define LogoutURL [NSString stringWithFormat:@"%@%@/Login/logout?", XSURL, APIFolder]
//获取验证码
#define GetRegistCodeURL [NSString stringWithFormat:@"%@%@/Login/captcha?", XSURL, APIFolder]
//注册
#define RegistURL [NSString stringWithFormat:@"%@%@/Login/register?", XSURL, APIFolder]
//获取视频上传地址
#define GetUploadFileURL [NSString stringWithFormat:@"%@%@/Begin/getUploadUrl?", XSURL, APIFolder]
//上传头像
#define UploadHeadImageURL [NSString stringWithFormat:@"%@%@/Begin/uploadHeadimg?", XSURL, APIFolder]

//修改头像
#define ModifyHeadImageURL(uKey) [NSString stringWithFormat:@"%@%@/User/headimg/ukey/%@?", XSURL, APIFolder,uKey]

//通知列表
#define NotifyListURL(uKey) [NSString stringWithFormat:@"%@%@/User/get_push_list/ukey/%@", XSURL, APIFolder, uKey]
//首页列表
#define IndexListURL(uKey) [NSString stringWithFormat:@"%@%@/Date/lists/ukey/%@", XSURL, APIFolder, uKey]
//约会说明
#define MeetInfoURL(uKey) [NSString stringWithFormat:@"%@%@/Date/aboutDate/ukey/%@", XSURL, APIFolder, uKey]
//我的私约
#define MyPrivateMeetURL(uKey) [NSString stringWithFormat:@"%@%@/Date/mySingleDateList/ukey/%@", XSURL, APIFolder, uKey]
//我的发布
#define MyCreateMeetURL(uKey) [NSString stringWithFormat:@"%@%@/Date/myDateList/ukey/%@", XSURL, APIFolder, uKey]
//商城
#define ShopInfoURL(uKey) [NSString stringWithFormat:@"%@%@/Pay/payforvip/ukey/%@", XSURL, APIFolder, uKey]
//获取我的个人信息
#define GetMyInfoURL(uKey) [NSString stringWithFormat:@"%@%@/User/userInfo/ukey/%@", XSURL, APIFolder, uKey]
//修改密码
#define ChangePasswordURL(uKey) [NSString stringWithFormat:@"%@%@/User/changepwd/ukey/%@", XSURL, APIFolder, uKey]
//报名约会
#define BaomingMeetURL(uKey, meetID) [NSString stringWithFormat:@"%@%@/Date/dateSign/ukey/%@/id/%@", XSURL, APIFolder, uKey, meetID]
//查看手机
#define LookPhoneURL(uKey, uid) [NSString stringWithFormat:@"%@%@/User/getUserPhone/ukey/%@/uid/%@", XSURL, APIFolder, uKey, uid]
//获取用户相册
#define LookUserPhotosURL(uKey, uid) [NSString stringWithFormat:@"%@%@/User/oneUserAlbum/ukey/%@/uid/%@", XSURL, APIFolder, uKey, uid]
//获取用户约会列表
#define LookUserMeetingURL(uKey, uid) [NSString stringWithFormat:@"%@%@/User/dateList/ukey/%@/uid/%@", XSURL, APIFolder, uKey, uid]
//获取发布类型
#define GetCreateMeetTypeURL(uKey) [NSString stringWithFormat:@"%@%@/Date/cate/ukey/%@", XSURL, APIFolder, uKey]
//发布约会
#define CreateMeetURL(uKey) [NSString stringWithFormat:@"%@%@/Date/newDate/ukey/%@", XSURL, APIFolder, uKey]
//获取我的相册
#define MyPhotosURL(uKey) [NSString stringWithFormat:@"%@%@/User/myAlbum/ukey/%@", XSURL, APIFolder, uKey]
//上传图片
#define UploadPictureURL(URL,uKey) [NSString stringWithFormat:@"%@%@/User/album/ukey/%@", URL, APIFolder, uKey]
//保存图片
#define SavePictureURL(uKey) [NSString stringWithFormat:@"%@%@/User/saveImage/ukey/%@", XSURL, APIFolder, uKey]
//我的关注
#define MyFocusURL(uKey) [NSString stringWithFormat:@"%@%@/User/myFollow/ukey/%@", XSURL, APIFolder, uKey]
//获取视频
#define MyMovieURL(uKey) [NSString stringWithFormat:@"%@%@/User/myVideo/ukey/%@", XSURL, APIFolder, uKey]
//我的消费记录
#define MyPayLisyURL(uKey) [NSString stringWithFormat:@"%@%@/User/countList/ukey/%@", XSURL, APIFolder, uKey]
//我的充值记录
#define MyMoneyListURL(uKey) [NSString stringWithFormat:@"%@%@/User/pay_coin_list/ukey/%@", XSURL, APIFolder, uKey]
//查看用户信息
#define LookPeopleInfoURL(uKey, uid) [NSString stringWithFormat:@"%@%@/User/oneUserInfo/ukey/%@/uid/%@", XSURL, APIFolder, uKey, uid]
//上传视频
#define UploadMovieURL(URL,uKey) [NSString stringWithFormat:@"%@%@/User/video/ukey/%@", URL, APIFolder, uKey]
//购买
#define PayURL(uKey,ID,type) [NSString stringWithFormat:@"%@%@/Pay/buyone/ukey/%@/id/%@/type/%@", XSURL, APIFolder, uKey, ID, type]
//响应约会 ondate  1:接受，2：拒绝
#define AnswerMeetURL(uKey,meetID,uid,ondate) [NSString stringWithFormat:@"%@%@/Date/onDate/ukey/%@/id/%@/uid/%@/ondate/%@", XSURL, APIFolder, uKey, meetID, uid, ondate]
//修改信息
#define EditMyInfoURL(uKey) [NSString stringWithFormat:@"%@%@/User/updateInfo/ukey/%@", XSURL, APIFolder, uKey]
//查看手机付费信息
#define LookPhoneMoneyURL(uKey) [NSString stringWithFormat:@"%@%@/User/getPhoneCoin/ukey/%@", XSURL, APIFolder, uKey]
//上传通讯录
#define UploadContactsURL(uKey) [NSString stringWithFormat:@"%@%@/User/up_adlist/ukey/%@", XSURL, APIFolder, uKey]
//关注某人
#define FocusPeopleURL(uKey, uid) [NSString stringWithFormat:@"%@%@/User/follow/ukey/%@/uid/%@", XSURL, APIFolder, uKey, uid]
//取消关注某人
#define UNFocusPeopleURL(uKey, uid) [NSString stringWithFormat:@"%@%@/User/delFollow/ukey/%@/uid/%@", XSURL, APIFolder, uKey, uid]
//解冻约会
#define UncoldMeetingURL(uKey) [NSString stringWithFormat:@"%@%@/Date/datePwd/ukey/%@", XSURL, APIFolder, uKey]
//删除照片
#define DeletePicturURL(uKey, pid) [NSString stringWithFormat:@"%@%@/User/delAlbum/ukey/%@/id/%@", XSURL, APIFolder, uKey, pid]
//约会详情
#define MeetDetailsURL(uKey, mid) [NSString stringWithFormat:@"%@%@/Date/dateSignList/ukey/%@/id/%@", XSURL, APIFolder, uKey, mid]
//用户须知
#define UserInstrunctions [NSString stringWithFormat:@"%@%@/Msg/knows", XSURL, APIFolder]




#endif













