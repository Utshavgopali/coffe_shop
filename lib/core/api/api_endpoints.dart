import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiEndpoints {
  ApiEndpoints._();

  // Change this when testing on real phone
  static const bool isPhysicalDevice = true;

  // Your laptop IPv4 address
  static const String compIpAddress = '192.168.112.99';

  static const int backendPort = 5000;

  static String get _origin {
    if (isPhysicalDevice) {
      return 'http://$compIpAddress:$backendPort';
    }

    if (kIsWeb) {
      return 'http://localhost:$backendPort';
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:$backendPort';
    } else if (Platform.isIOS) {
      return 'http://localhost:$backendPort';
    } else {
      return 'http://localhost:$backendPort';
    }
  }

  /// Backend origin with no path — use to resolve relative asset paths the
  /// API returns (e.g. `/uploads/beans/x.jpg`, `/avatars/x.png`).
  static String get mediaBaseUrl => _origin;

  static String get baseUrl => '$_origin/api/v1';

  static String? resolveImageUrl(String? path) {
    if (path == null || path.isEmpty) return null;
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }
    return '$mediaBaseUrl$path';
  }

  // ─── Auth ───────────────────────────────────────────────────────────────
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String google = '/auth/google';
  static const String whoami = '/auth/whoami';
  static const String update = '/auth/update';
  static const String forgotPasswordRequest = '/auth/forgot-password/request';
  static const String forgotPasswordVerify = '/auth/forgot-password/verify';
  static const String forgotPasswordReset = '/auth/forgot-password/reset';
  static const String changePasswordRequestCode = '/auth/change-password/request-code';
  static const String changePasswordConfirm = '/auth/change-password/confirm';

  // ─── Beans ──────────────────────────────────────────────────────────────
  static const String beans = '/beans';
  static const String beanFacets = '/beans/facets';
  static String beanById(String id) => '/beans/$id';

  // ─── Reviews (scoped to a bean) ─────────────────────────────────────────
  static String beanReviews(String beanId) => '/beans/$beanId/reviews';
  static String myBeanReview(String beanId) => '/beans/$beanId/reviews/mine';

  // ─── Wishlist ───────────────────────────────────────────────────────────
  static const String wishlist = '/wishlist';
  static String wishlistItem(String beanId) => '/wishlist/$beanId';

  // ─── Cart ───────────────────────────────────────────────────────────────
  static const String cart = '/cart';
  static String cartItem(String beanId) => '/cart/$beanId';

  // ─── Orders ─────────────────────────────────────────────────────────────
  static const String checkout = '/orders/checkout';
  static const String verifyOrder = '/orders/verify';
  static const String orders = '/orders';
  static String orderById(String id) => '/orders/$id';

  // ─── Notifications ──────────────────────────────────────────────────────
  static const String notifications = '/notifications';
  static String notificationRead(String id) => '/notifications/$id/read';
  static const String notificationsReadAll = '/notifications/read-all';

  // ─── Chatbot ────────────────────────────────────────────────────────────
  static const String chatbot = '/chatbot';
}
