import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

import 'config.dart';
import 'model.dart';

class HrvApi {
  static Interceptor? logInterceptor;

  final HrvConfig config;

  late final CookieJar _cookieJar;
  late final Dio _dio;

  HrvApi(this.config) {
    _dio = Dio(BaseOptions(baseUrl: "https://${config.domain}"));

    _cookieJar = CookieJar();
    _dio.interceptors.add(CookieManager(_cookieJar));

    if (logInterceptor != null) {
      _dio.interceptors.add(logInterceptor!);
    }
  }

  Future<Cart> get cart async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/cart.js',
      options: Options(
        responseType: ResponseType.json,
      ),
    );
    final data = response.data;
    if (data != null) {
      return Cart.fromJson(data);
    } else {
      return Cart();
    }
  }

  Future<void> addToCart(AddToCartRequest request) async {
    await _dio.post(
      '/cart/add.js',
      data: request,
      options: Options(
        validateStatus: (status) => status == 302,
      ),
    );
  }
}
