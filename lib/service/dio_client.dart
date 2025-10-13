import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:skyouthprofiling/data/app_database.dart';

class DioClient {
  final String ip;
  final String base;
  final CancelToken cancelToken = CancelToken();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  late final Dio _dio;

  DioClient(this.ip) : base = 'http://$ip/api' {
    try {
      _dio = Dio(
        BaseOptions(
          baseUrl: base,
          connectTimeout: const Duration(seconds: 20),
          receiveTimeout: const Duration(seconds: 20),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
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
    } catch (e) {
      //
    }
  }

  Future<Map<String, dynamic>> getAddresses() async {
    try {
      final response = await _dio.get('/getOpenHub', cancelToken: cancelToken);
      final data = response.data as Map<String, dynamic>?;
      if (data == null) throw Exception("No data received");
      debugPrint('tyuuuuuuuu');
      return data;
    } on DioException {
      return {'error2': 'possibility: hub is closed'};
    } catch (e) {
      debugPrint("non dio error: $e");
      return {'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> login(String em, String pw) async {
    try {
      final response = await _dio.post(
        '/loginOfficials',
        cancelToken: cancelToken,
        data: {'email': em, 'password': pw},
      );

      final data = Map<String, dynamic>.from(response.data);

      if (data.containsKey('token')) {
        await _storage.write(key: 'token', value: data['token']);
      }

      return {'data': data, 'cancelToken': cancelToken};
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        return {'error': 'Request cancelled'};
      }

      if (e.response != null && e.response!.statusCode == 422) {
        final error = Map<String, dynamic>.from(e.response!.data);
        return {'error': error};
      }

      return {'error3': e.message ?? 'Unknown Dio error'};
    } catch (e) {
      return {'error4': e.toString()};
    }
  }

  Future<Map<String, dynamic>> logoutOfficials() async {
    try {
      final response = await _dio.get('/logoutOfficials');
      return {'data': response.data};
    } on DioException catch (e) {
      return {'error': e.response?.data ?? e.message};
    } catch (e) {
      return {'error2': e.toString()};
    }
  }

  Future<void> getDataFromHub(Map<String, Map<String, dynamic>> data) async {
    final db = DatabaseProvider.instance;
    final res = await _dio.post('/getDataFromHub', data: {'addresses': data});
    // debugPrint(jsonEncode(res.data));
    final profiles = (res.data['profiles'] as List);
    try {
      // for (final p in profiles) {
      //   debugPrint('Processing profile: ${p['youthUser']}');
      //   debugPrint('orgid: ${p['youthUser']['orgId']}');
      //   debugPrint('skills: ${p['youthUser']['skills']}');
      //   debugPrint('youthType: ${p['youthUser']['youthType']}');
      //   debugPrint('status: ${p['youthUser']['status']}');
      //   debugPrint('registerAt: ${p['youthUser']['registerAt']}');
      //   debugPrint('registerAt: ${p['youthUser']['registerAt']}');
      //   // Example parsing
      //   final user = YouthUser(
      //     orgId: p['youthUser']['orgId'] as int,
      //     skills: p['youthUser']['skills'],
      //     youthType: p['youthUser']['youthType'] ?? 'unknown',
      //     status: p['youthUser']['status'] ?? 'unvalidated',
      //     registerAt: DateTime.parse(p['youthUser']['registerAt']),
      //     youthUserId: 1,
      //     createdAt: DateTime.parse(p['youthUser']['registerAt']),
      //   );
      //   debugPrint('Created YouthUser======================: ${user.toString()}');
      // }
      // YouthUser.fromJson(res['profiles']['youthUser']);
      // final profiles =
      //     (res.data['profiles'] as List)
      //         .map((p) => FullYouthProfile.fromJson(p))
      //         .toList();
     
      await db.insertBulkProfiles(profiles);
    } catch (e) {
      debugPrint('error90: $e');
    }
  }

  Future<Map<String, dynamic>> checkAuth() async {
    try {
      final response = await _dio.get('/userAPI');
      return {'data': response.data};
    } on DioException catch (e) {
      return {'error': e.response?.data ?? e.message};
    } catch (e) {
      return {'error2': e.toString()};
    }
  }

  Future<Map<String, dynamic>> migrateData(
    List<Map<String, dynamic>> data,
  ) async {
    try {
      final response = await _dio.post('/migrate', data: data);
      return {'data': response.data};
    } on DioException catch (e) {
      return {
        'error': {
          'error': e.response?.data?['auth'] ?? 'Something went wrong.',
        },
      };
    } catch (e) {
      return {
        'error': {'error': e.toString()},
      };
    }
  }

  Dio get dio => _dio;
}
