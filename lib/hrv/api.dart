import 'dart:convert';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';

import 'config.dart';
import 'model.dart';

class HrvApi {
  static Interceptor? logInterceptor;

  final cart = ValueNotifier(Cart());
  final HrvConfig config;
  final isLoading = ValueNotifier(false);
  final jQuery = ValueNotifier('');

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

  Future<void> updateCart() async {
    if (isLoading.value) return;
    isLoading.value = true;

    await _updateCart().whenComplete(() => isLoading.value = false);
  }

  Future<void> addToCart(AddToCartRequest request) async {
    if (isLoading.value) return;
    isLoading.value = true;

    await _addToCart(request)
        .then((_) => _updateCart())
        .whenComplete(() => isLoading.value = false);
  }

  Future<void> _addToCart(AddToCartRequest request) async {
    const path = '/cart/add.js';
    jQuery.value = '${jQuery.value}\n\$.post(\n'
        '  "$path",\n'
        '  ${jsonEncode(request)}\n'
        ');\n';

    await _dio.post(
      path,
      data: request,
      options: Options(
        validateStatus: (status) => status == 302,
      ),
    );
  }

  Future<void> _updateCart() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/cart.js',
      options: Options(
        responseType: ResponseType.json,
      ),
    );
    final data = response.data;
    if (data != null) {
      cart.value = Cart.fromJson(data);
    }
  }
}
