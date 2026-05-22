import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import 'core/constants/app_constants.dart';
import 'core/network/dio_client.dart';
import 'core/network/network_info.dart';
import 'features/news/data/cache/article_cache_manager.dart';
import 'features/news/data/datasources/news_local_data_source.dart';
import 'features/news/data/datasources/news_remote_data_source.dart';
import 'features/news/data/repositories/news_repository_impl.dart';
import 'features/news/domain/repositories/news_repository.dart';
import 'features/news/domain/usecases/get_top_headlines.dart';
import 'features/news/domain/usecases/search_articles.dart';
import 'features/news/presentation/bloc/news_bloc.dart';
import 'features/news/presentation/bloc/search_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {

  sl.registerFactory(() => NewsBloc(getTopHeadlines: sl()));
  sl.registerFactory(() => SearchBloc(searchArticles: sl()));


  sl.registerLazySingleton(() => GetTopHeadlines(sl()));
  sl.registerLazySingleton(() => SearchArticles(sl()));


  sl.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(remote: sl(), local: sl()),
  );


  sl.registerLazySingleton<NewsRemoteDataSource>(
    () => NewsRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<NewsLocalDataSource>(
    () => NewsLocalDataSourceImpl(sl()),
  );


  sl.registerLazySingleton<ArticleCacheManager>(
    () => ArticleCacheManager(sl()),
  );
  sl.registerLazySingleton<Box<String>>(
    () => Hive.box<String>(AppConstants.articleCacheBox),
  );

  sl.registerLazySingleton<Dio>(() => DioClient.createDio());
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl()),
  );
  sl.registerLazySingleton(() => Connectivity());
}