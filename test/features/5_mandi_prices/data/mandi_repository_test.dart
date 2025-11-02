import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:krishi_mitra/core/constant/api_constants.dart';
import 'package:krishi_mitra/core/services/connectivity_service.dart';
import 'package:krishi_mitra/features/5_mandi_prices/data/mandi_repository.dart';
import 'package:krishi_mitra/features/5_mandi_prices/domain/exceptions/mandi_price_exception.dart';
import 'package:krishi_mitra/features/5_mandi_prices/domain/mandi_price.dart';

import 'mandi_repository_test.mocks.dart';

@GenerateMocks([Dio, ConnectivityService])
void main() {
  late MandiRepository repository;
  late MockDio mockDio;
  late MockConnectivityService mockConnectivityService;

  setUp(() {
    mockDio = MockDio();
    mockConnectivityService = MockConnectivityService();
    repository = MandiRepository(
      dio: mockDio,
      connectivityService: mockConnectivityService,
    );
  });

  group('MandiRepository.fetchMandiPrices', () {
    const testState = 'Tamil Nadu';
    final testMandiPriceJson = {
      'state': 'Tamil Nadu',
      'district': 'Chennai',
      'market': 'Koyambedu Market',
      'commodity': 'Tomato',
      'arrivalDate': '2025-11-01',
      'minPrice': 2000,
      'maxPrice': 3500,
      'modalPrice': 2800,
    };

    test('successfully fetches and parses mandi prices', () async {
      // Arrange
      when(mockConnectivityService.hasConnection())
          .thenAnswer((_) async => true);
      
      when(mockDio.get(
        '${ApiConstants.mandiPricesEndpoint}/$testState',
      )).thenAnswer((_) async => Response(
            data: [testMandiPriceJson],
            statusCode: 200,
            requestOptions: RequestOptions(path: '${ApiConstants.mandiPricesEndpoint}/$testState'),
          ));

      // Act
      final result = await repository.fetchMandiPrices(testState);

      // Assert
      expect(result, isA<List<MandiPrice>>());
      expect(result.length, 1);
      expect(result[0].state, 'Tamil Nadu');
      expect(result[0].district, 'Chennai');
      expect(result[0].market, 'Koyambedu Market');
      expect(result[0].commodity, 'Tomato');
      expect(result[0].arrivalDate, '2025-11-01');
      expect(result[0].minPrice, 2000);
      expect(result[0].maxPrice, 3500);
      expect(result[0].modalPrice, 2800);
      
      verify(mockConnectivityService.hasConnection()).called(1);
      verify(mockDio.get(
        '${ApiConstants.mandiPricesEndpoint}/$testState',
      )).called(1);
    });

    test('throws MandiPriceException when no internet connection', () async {
      // Arrange
      when(mockConnectivityService.hasConnection())
          .thenAnswer((_) async => false);

      // Act & Assert
      expect(
        () => repository.fetchMandiPrices(testState),
        throwsA(isA<MandiPriceException>().having(
          (e) => e.message,
          'message',
          'No internet connection. Please check your network and try again.',
        )),
      );
      
      verify(mockConnectivityService.hasConnection()).called(1);
      verifyNever(mockDio.get(any));
    });

    test('throws MandiPriceException on 400 Bad Request', () async {
      // Arrange
      when(mockConnectivityService.hasConnection())
          .thenAnswer((_) async => true);
      
      when(mockDio.get(
        '${ApiConstants.mandiPricesEndpoint}/$testState',
      )).thenThrow(DioException(
        response: Response(
          statusCode: 400,
          requestOptions: RequestOptions(path: '${ApiConstants.mandiPricesEndpoint}/$testState'),
        ),
        requestOptions: RequestOptions(path: '${ApiConstants.mandiPricesEndpoint}/$testState'),
      ));

      // Act & Assert
      expect(
        () => repository.fetchMandiPrices(testState),
        throwsA(isA<MandiPriceException>().having(
          (e) => e.message,
          'message',
          'Invalid state selected. Please try again.',
        )),
      );
    });

    test('throws MandiPriceException on 401 Unauthorized', () async {
      // Arrange
      when(mockConnectivityService.hasConnection())
          .thenAnswer((_) async => true);
      
      when(mockDio.get(
        '${ApiConstants.mandiPricesEndpoint}/$testState',
      )).thenThrow(DioException(
        response: Response(
          statusCode: 401,
          requestOptions: RequestOptions(path: '${ApiConstants.mandiPricesEndpoint}/$testState'),
        ),
        requestOptions: RequestOptions(path: '${ApiConstants.mandiPricesEndpoint}/$testState'),
      ));

      // Act & Assert
      expect(
        () => repository.fetchMandiPrices(testState),
        throwsA(isA<MandiPriceException>().having(
          (e) => e.message,
          'message',
          'Session expired. Please login again.',
        )),
      );
    });

    test('throws MandiPriceException on 404 Not Found', () async {
      // Arrange
      when(mockConnectivityService.hasConnection())
          .thenAnswer((_) async => true);
      
      when(mockDio.get(
        '${ApiConstants.mandiPricesEndpoint}/$testState',
      )).thenThrow(DioException(
        response: Response(
          statusCode: 404,
          requestOptions: RequestOptions(path: '${ApiConstants.mandiPricesEndpoint}/$testState'),
        ),
        requestOptions: RequestOptions(path: '${ApiConstants.mandiPricesEndpoint}/$testState'),
      ));

      // Act & Assert
      expect(
        () => repository.fetchMandiPrices(testState),
        throwsA(isA<MandiPriceException>().having(
          (e) => e.message,
          'message',
          'Service not available. Please try again later.',
        )),
      );
    });

    test('throws MandiPriceException on 500 Server Error', () async {
      // Arrange
      when(mockConnectivityService.hasConnection())
          .thenAnswer((_) async => true);
      
      when(mockDio.get(
        '${ApiConstants.mandiPricesEndpoint}/$testState',
      )).thenThrow(DioException(
        response: Response(
          statusCode: 500,
          requestOptions: RequestOptions(path: '${ApiConstants.mandiPricesEndpoint}/$testState'),
        ),
        requestOptions: RequestOptions(path: '${ApiConstants.mandiPricesEndpoint}/$testState'),
      ));

      // Act & Assert
      expect(
        () => repository.fetchMandiPrices(testState),
        throwsA(isA<MandiPriceException>().having(
          (e) => e.message,
          'message',
          'Server error. Please try again later.',
        )),
      );
    });

    test('throws MandiPriceException on connection timeout', () async {
      // Arrange
      when(mockConnectivityService.hasConnection())
          .thenAnswer((_) async => true);
      
      when(mockDio.get(
        '${ApiConstants.mandiPricesEndpoint}/$testState',
      )).thenThrow(DioException(
        type: DioExceptionType.connectionTimeout,
        requestOptions: RequestOptions(path: '${ApiConstants.mandiPricesEndpoint}/$testState'),
      ));

      // Act & Assert
      expect(
        () => repository.fetchMandiPrices(testState),
        throwsA(isA<MandiPriceException>().having(
          (e) => e.message,
          'message',
          'Connection timeout. Please check your internet.',
        )),
      );
    });

    test('throws MandiPriceException on connection error', () async {
      // Arrange
      when(mockConnectivityService.hasConnection())
          .thenAnswer((_) async => true);
      
      when(mockDio.get(
        '${ApiConstants.mandiPricesEndpoint}/$testState',
      )).thenThrow(DioException(
        type: DioExceptionType.connectionError,
        requestOptions: RequestOptions(path: '${ApiConstants.mandiPricesEndpoint}/$testState'),
      ));

      // Act & Assert
      expect(
        () => repository.fetchMandiPrices(testState),
        throwsA(isA<MandiPriceException>().having(
          (e) => e.message,
          'message',
          'No internet connection. Please check your network and try again.',
        )),
      );
    });
  });
}
