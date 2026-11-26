class MovieModel {
  final int id;
  final String url;
  final String imdbCode;
  final String title;
  final String titleEnglish;
  final String titleLong;
  final String slug;
  final int year;
  final double rating;
  final int runtime;
  final List<String> genres;
  final int likeCount;
  final String summary;
  final String descriptionIntro;
  final String descriptionFull;
  final String synopsis;
  final String ytTrailerCode;
  final String language;
  final String mpaRating;
  final String backgroundImage;
  final String backgroundImageOriginal;
  final String smallCoverImage;
  final String mediumCoverImage;
  final String largeCoverImage;
  final String mediumScreenshotImage1;
  final String mediumScreenshotImage2;
  final String mediumScreenshotImage3;
  final String largeScreenshotImage1;
  final String largeScreenshotImage2;
  final String largeScreenshotImage3;
  final List<CastModel> cast;
  final List<TorrentModel> torrents;

  MovieModel({
    required this.id,
    this.url = '',
    this.imdbCode = '',
    required this.title,
    this.titleEnglish = '',
    this.titleLong = '',
    this.slug = '',
    this.year = 0,
    this.rating = 0.0,
    this.runtime = 0,
    this.genres = const [],
    this.likeCount = 0,
    this.summary = '',
    this.descriptionIntro = '',
    this.descriptionFull = '',
    this.synopsis = '',
    this.ytTrailerCode = '',
    this.language = '',
    this.mpaRating = '',
    this.backgroundImage = '',
    this.backgroundImageOriginal = '',
    this.smallCoverImage = '',
    this.mediumCoverImage = '',
    this.largeCoverImage = '',
    this.mediumScreenshotImage1 = '',
    this.mediumScreenshotImage2 = '',
    this.mediumScreenshotImage3 = '',
    this.largeScreenshotImage1 = '',
    this.largeScreenshotImage2 = '',
    this.largeScreenshotImage3 = '',
    this.cast = const [],
    this.torrents = const [],
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      url: json['url']?.toString() ?? '',
      imdbCode: json['imdb_code']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      titleEnglish: json['title_english']?.toString() ?? '',
      titleLong: json['title_long']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      year: (json['year'] as num?)?.toInt() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      runtime: (json['runtime'] as num?)?.toInt() ?? 0,
      genres: (json['genres'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      likeCount: (json['like_count'] as num?)?.toInt() ?? 0,
      summary: json['summary']?.toString() ?? '',
      descriptionIntro: json['description_intro']?.toString() ?? '',
      descriptionFull: json['description_full']?.toString() ?? '',
      synopsis: json['synopsis']?.toString() ?? '',
      ytTrailerCode: json['yt_trailer_code']?.toString() ?? '',
      language: json['language']?.toString() ?? '',
      mpaRating: json['mpa_rating']?.toString() ?? '',
      backgroundImage: json['background_image']?.toString() ?? '',
      backgroundImageOriginal:
      json['background_image_original']?.toString() ?? '',
      smallCoverImage: json['small_cover_image']?.toString() ?? '',
      mediumCoverImage: json['medium_cover_image']?.toString() ?? '',
      largeCoverImage: json['large_cover_image']?.toString() ?? '',
      mediumScreenshotImage1:
      json['medium_screenshot_image1']?.toString() ?? '',
      mediumScreenshotImage2:
      json['medium_screenshot_image2']?.toString() ?? '',
      mediumScreenshotImage3:
      json['medium_screenshot_image3']?.toString() ?? '',
      largeScreenshotImage1:
      json['large_screenshot_image1']?.toString() ?? '',
      largeScreenshotImage2:
      json['large_screenshot_image2']?.toString() ?? '',
      largeScreenshotImage3:
      json['large_screenshot_image3']?.toString() ?? '',
      cast: (json['cast'] as List<dynamic>?)
          ?.map((e) => CastModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      torrents: (json['torrents'] as List<dynamic>?)
          ?.map((e) => TorrentModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'imdb_code': imdbCode,
      'title': title,
      'title_english': titleEnglish,
      'title_long': titleLong,
      'slug': slug,
      'year': year,
      'rating': rating,
      'runtime': runtime,
      'genres': genres,
      'like_count': likeCount,
      'summary': summary,
      'description_intro': descriptionIntro,
      'description_full': descriptionFull,
      'synopsis': synopsis,
      'yt_trailer_code': ytTrailerCode,
      'language': language,
      'mpa_rating': mpaRating,
      'background_image': backgroundImage,
      'background_image_original': backgroundImageOriginal,
      'small_cover_image': smallCoverImage,
      'medium_cover_image': mediumCoverImage,
      'large_cover_image': largeCoverImage,
      'medium_screenshot_image1': mediumScreenshotImage1,
      'medium_screenshot_image2': mediumScreenshotImage2,
      'medium_screenshot_image3': mediumScreenshotImage3,
      'large_screenshot_image1': largeScreenshotImage1,
      'large_screenshot_image2': largeScreenshotImage2,
      'large_screenshot_image3': largeScreenshotImage3,
      'cast': cast.map((e) => e.toJson()).toList(),
      'torrents': torrents.map((e) => e.toJson()).toList(),
    };
  }
}

class CastModel {
  final String name;
  final String characterName;
  final String urlSmallImage;
  final String imdbCode;

  CastModel({
    required this.name,
    this.characterName = '',
    this.urlSmallImage = '',
    this.imdbCode = '',
  });

  factory CastModel.fromJson(Map<String, dynamic> json) {
    return CastModel(
      name: json['name']?.toString() ?? '',
      characterName: json['character_name']?.toString() ?? '',
      urlSmallImage: json['url_small_image']?.toString() ?? '',
      imdbCode: json['imdb_code']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'character_name': characterName,
      'url_small_image': urlSmallImage,
      'imdb_code': imdbCode,
    };
  }
}

class TorrentModel {
  final String url;
  final String hash;
  final String quality;
  final String type;
  final int seeds;
  final int peers;
  final String size;
  final int sizeBytes;

  TorrentModel({
    this.url = '',
    this.hash = '',
    this.quality = '',
    this.type = '',
    this.seeds = 0,
    this.peers = 0,
    this.size = '',
    this.sizeBytes = 0,
  });

  factory TorrentModel.fromJson(Map<String, dynamic> json) {
    return TorrentModel(
      url: json['url']?.toString() ?? '',
      hash: json['hash']?.toString() ?? '',
      quality: json['quality']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      seeds: (json['seeds'] as num?)?.toInt() ?? 0,
      peers: (json['peers'] as num?)?.toInt() ?? 0,
      size: json['size']?.toString() ?? '',
      sizeBytes: (json['size_bytes'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'hash': hash,
      'quality': quality,
      'type': type,
      'seeds': seeds,
      'peers': peers,
      'size': size,
      'size_bytes': sizeBytes,
    };
  }
}