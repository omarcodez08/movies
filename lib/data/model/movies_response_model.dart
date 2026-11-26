import 'movie_model.dart';

class MoviesResponseModel {
  final String status;
  final String statusMessage;
  final int movieCount;
  final int limit;
  final int pageNumber;
  final List<MovieModel> movies;
  final MovieModel? movie;

  MoviesResponseModel({
    this.status = '',
    this.statusMessage = '',
    this.movieCount = 0,
    this.limit = 0,
    this.pageNumber = 1,
    this.movies = const [],
    this.movie,
  });

  factory MoviesResponseModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic>? data = json['data'] as Map<String, dynamic>?;

    return MoviesResponseModel(
      status: json['status']?.toString() ?? '',
      statusMessage: json['status_message']?.toString() ?? '',
      movieCount: (data?['movie_count'] as num?)?.toInt() ?? 0,
      limit: (data?['limit'] as num?)?.toInt() ?? 0,
      pageNumber: (data?['page_number'] as num?)?.toInt() ?? 1,
      movies: (data?['movies'] as List<dynamic>?)
          ?.map((e) => MovieModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      movie: data?['movie'] != null
          ? MovieModel.fromJson(data!['movie'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'status_message': statusMessage,
      'data': {
        'movie_count': movieCount,
        'limit': limit,
        'page_number': pageNumber,
        'movies': movies.map((e) => e.toJson()).toList(),
        if (movie != null) 'movie': movie!.toJson(),
      },
    };
  }
}