import 'package:dio/dio.dart';

class DioClient {
  final String ip;
  final String base;
  final CancelToken cancelToken = CancelToken();
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
  }

  Future<Map<String, dynamic>> login(String em, String pw) async {
    try {
      final response = await _dio.post(
        '/loginOfficials',
        cancelToken: cancelToken,
        data: {'email': em, 'password': pw},
      );

      return {
        'data': Map<String, dynamic>.from(response.data),
        'cancelToken': cancelToken,
      };
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        return {'error': 'Request cancelled'};
      }

      if (e.response != null && e.response!.statusCode == 422) {
        final Map<String, dynamic> error = Map<String, dynamic>.from(
          e.response!.data,
        );
        return {'error': error};
      }

      return {'error': e.message ?? 'Unknown Dio error'};
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  Dio get dio => _dio;
}
