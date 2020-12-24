// 主题色配置文件
import 'package:flutter/material.dart';

class StyleColors {
  static const Color pirmaryColor = Color(0xff26B994); // 主题色
  // 主题渐变起始色
  static const Color pirmaryGradientsStartColor = Color(0xFFC829F6);
  // 主题渐变结束色
  static const Color pirmaryGradientsEndColor = Color(0xFF5247F6);
  // 主题弱化色
  static const Color pirmaryWeakenColor = Color.fromARGB(100, 255, 236, 236);
  // 主题禁用色
  static const Color pirmaryDisabledColor = Color(0xFFD4D4D4);
  // 默认色 - 暗灰（用于导航标题、重要标题、重要文本
  static const Color defaultColor = Color(0xFF333333);
  // 次要色 - 暗灰（用于次要标题、次要文本
  static const Color secondaryColor = Color(0xFF666666);
  // 第三位 - 中灰（用于列表标题、次要文本、提示文本、弹窗正文、声明/备注文本
  static const Color tertiaryColor = Color(0xFF999999);
  // 弱化色 - 淡灰（用于置灰按钮/icon/文本、内容占位文本、优惠券列表、深色分割线(页面分割较少的情况)）
  static const Color weakenColor = Color(0xFFB9B9B9);
  // 分割色 - 浅色分割线(页面分割较多的情况)
  static const Color separateColor = Color(0xFFeeeeee);
  // 默认背景色
  static const Color bgColor = Color(0xFFF6F6F6);
  // 默认卡片背景色
  static const Color bgCardColor = Color(0xFFFFFFFF);
  // 成功操作
  static const Color successColor = Color(0xFF14C08F);
  // 危险操作
  static const Color dangerColor = Color(0xFFFF6262);
  // 警告
  static const Color warningColor = Color(0xFFffc625);
  // 编辑颜色
  static const Color editColor = Color(0xFF59ACFF);
}
