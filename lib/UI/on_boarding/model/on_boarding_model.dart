import 'package:movies/core/resources/assets_manager.dart';

class OnBoardingModel {
  String image;
  String title ;
  String ?description ;
  OnBoardingModel({ this .description,required this .title,required this.image});

  static
  List<OnBoardingModel> onboardingList = [
    OnBoardingModel(
      image: AssetsManager.onboarding1,
      title: "Find Your Next Favorite Movie Here",
      description: "Get access to a huge library of movies to suit all tastes. You will surely like it.",
    ),
    OnBoardingModel(
      image: AssetsManager.onboarding2,
      title: "Discover Movies",
      description: "Explore a vast collection of movies in all qualities and genres. Find your next favorite film with ease.",
    ),
    OnBoardingModel(
      image: AssetsManager.onboarding3,
      title: "Explore All Genres",
      description: "Discover movies from every genre, in all available qualities. Find something new and exciting to watch every day.",
    ),
    OnBoardingModel(
      image: AssetsManager.onboarding4,
      title: "Create Watchlists",
      description: "Save movies to your watchlist to keep track of what you want to watch next. Enjoy films in various qualities and genres.",
    ),
    OnBoardingModel(
      image: AssetsManager.onboarding5,
      title: "Rate, Review, and Learn",
      description: "Share your thoughts on the movies you've watched. Dive deep into film details and help others discover great movies with your reviews.",
    ),
    OnBoardingModel(
      image: AssetsManager.onboarding6,
      title: "Start Watching Now",
    ),
  ];

}