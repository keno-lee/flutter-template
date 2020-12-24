import '../api/index.dart';
import './safeRes.dart';

// static UserInfo userInfo = UserInfo();
// _fetchData() async {
//   await Future.wait([userInfo.loadData()]);
//   print('1111 ${userInfo.avatar}');
// }

class UserInfo {
  Future loadData() async {
    raw = await httpUtil.get('/info');
    rawData = raw['data'];
  }

  Map raw;
  Map get valueRaw => raw ?? {};
  // 原始请求数据
  Map rawData;
  // 实际信息
  Map get value => rawData ?? {};

  bool get login => valueRaw['status'] != 401; // 是否登录

  String get avatar => value['avatar']; // 头像
  String get realName => value['real_name']; // 真实姓名

  String get memberExpired => value['member_expired']; // 会员过期时间
  num get balance => value['balance']; // 交易完成后账户余额(分)
  String get mobile => value['mobile']; //
  String get email => value['email']; //

  // 1=男，2=女
  String get gender => value['gender'];
  String get loanAmount => value['loan_amount']; //
  String get loanTerm => value['loan_term']; //

  // 会员 userStatus == 1
  // 过期 userStatus == 0 && payStatus == 1
  // 非会员 填过资料+未付钱 userStatus == 0 && payStatus == 0
  // 非会员 没填资料 infoStatus == 0

  // 用户是否填资料 1: 填了 0: 没填(新用户未填资料)
  int get infoStatus => value['info_status'];
  // 用户是否付钱了 1: 负了 0: 没有(填完资料但是没付钱)
  int get payStatus => value['pay_status'];
  // 1: 会员 0: 过期(填完资料付费了，成为会员了，但过期或者取消成为会员了)
  int get userStatus => value['status'];
  // 会员状态：1=有效，-1=过期，0=未成为会员
  // int get memberStatus => value['member_status'];
  // 会员试用状态：1=试用，0=未试用
  String get memberTrial => value['member_trial'];
}
