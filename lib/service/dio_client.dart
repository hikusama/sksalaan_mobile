import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DioClient {
  final String ip;
  final String base;
  final CancelToken cancelToken = CancelToken();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  late final Dio _dio;

  DioClient(this.ip) : base = 'http://$ip/api' {
    _dio = Dio(
      BaseOptions(
        baseUrl: base,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // Add Bearer Token interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: 'token');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }

  Future<Map<String, dynamic>> login(String em, String pw) async {
    try {
      print('Login....');
      final response = await _dio.post(
        '/loginOfficials',
        cancelToken: cancelToken,
        data: {'email': em, 'password': pw},
      );

      final data = Map<String, dynamic>.from(response.data);

      if (data.containsKey('token')) {
        await _storage.write(key: 'token', value: data['token']);
      }
      final token = await _storage.read(key: 'token');
      print('\n\n\n');
      print('token: $token');


      return {
        'data': data,
        'cancelToken': cancelToken,
      };
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        return {'error': 'Request cancelled'};
      }

      if (e.response != null && e.response!.statusCode == 422) {
        final error = Map<String, dynamic>.from(e.response!.data);
        return {'error': error};
      }
      print({'error': e.message});

      return {'error': e.message ?? 'Unknown Dio error'};
    } catch (e) {
      return {'error': e.toString()};
    }
    
  }

  Future<Map<String, dynamic>> checkAuth() async {
    try {
      print('Requesting auth....');
      final response = await _dio.get('/userAPI');
      return {'data': response.data};
    } on DioException catch (e) {
      return {'error': e.response?.data ?? e.message};
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  Dio get dio => _dio;
}
