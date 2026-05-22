import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/usecases/search_articles.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchArticles searchArticles;
  Timer? _debounce;

  SearchBloc({required this.searchArticles}) : super(SearchInitial()) {
    on<SearchQueryChanged>(_onQueryChanged);
    on<ClearSearch>(_onClearSearch);
  }

  Future<void> _onQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    _debounce?.cancel();

    if (event.query.trim().isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());

    final completer = Completer<void>();
    _debounce = Timer(
      const Duration(milliseconds: AppConstants.searchDebounceMs),
      () async {
        try {
          final articles = await searchArticles(query: event.query);
          if (!isClosed) emit(SearchLoaded(articles));
        } catch (e) {
          if (!isClosed) emit(SearchError(e.toString()));
        }
        completer.complete();
      },
    );

    await completer.future;
  }

  Future<void> _onClearSearch(
    ClearSearch event,
    Emitter<SearchState> emit,
  ) async {
    _debounce?.cancel();
    emit(SearchInitial());
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}