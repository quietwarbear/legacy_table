import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../config/api_config.dart';

class ApiClient {
  late Dio _dio;
  String? _authToken;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.apiBaseUrl,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        sendTimeout: const Duration(seconds: 60),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add auth token to headers if available
          if (_authToken != null) {
            options.headers['Authorization'] = 'Bearer $_authToken';
          }
          if (kDebugMode) {
            final fullUrl = options.baseUrl + options.path;
            print('REQUEST[${options.method}] => URL: $fullUrl');
            print('HEADERS: ${options.headers}');
            if (options.data != null) {
              print('DATA: ${options.data}');
            }
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            print(
                'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
          }
          return handler.next(response);
        },
        onError: (error, handler) {
          if (kDebugMode) {
            final fullUrl = error.requestOptions.baseUrl + error.requestOptions.path;
            print('ERROR[${error.response?.statusCode}] => URL: $fullUrl');
            print('ERROR MESSAGE: ${error.message}');
            if (error.response != null) {
              print('ERROR RESPONSE: ${error.response?.data}');
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  // Set authentication token
  void setAuthToken(String? token) {
    _authToken = token;
    if (kDebugMode) {
      print('Auth token ${token != null ? "set" : "cleared"}');
      if (token != null) {
        print('Token preview: ${token.substring(0, token.length > 20 ? 20 : token.length)}...');
      }
    }
  }

  // Clear authentication token
  void clearAuthToken() {
    _authToken = null;
  }

  // Get Dio instance
  Dio get dio => _dio;

  // GET request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // POST request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // PUT request
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // DELETE request
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Handle Dio errors
  Exception _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return Exception('Connection timeout. Unable to connect to server. Please check your internet connection and try again.');
      case DioExceptionType.sendTimeout:
        return Exception('Request timeout. The server took too long to process your request. Please try again.');
      case DioExceptionType.receiveTimeout:
        return Exception('Response timeout. The server is taking too long to respond. Please try again.');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data?['detail'] ??
            error.response?.data?['message'] ??
            'An error occurred';
        return Exception('Error $statusCode: $message');
      case DioExceptionType.cancel:
        return Exception('Request cancelled');
      case DioExceptionType.unknown:
        // Check if it's a network connectivity issue
        if (error.message != null && 
            (error.message!.contains('SocketException') || 
             error.message!.contains('Failed host lookup'))) {
          return Exception('Network error. Please check your internet connection and try again.');
        }
        return Exception('Network error. Please check your connection and try again.');
      default:
        return Exception('An unexpected error occurred. Please try again.');
    }
  }
}
