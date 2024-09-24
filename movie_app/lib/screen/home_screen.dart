import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/model/movie.dart';
import 'package:recipe_app/services/service.dart';

class HomeScreen extends StatefulWidget {
  static double offset = 0;
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Movie>> nowShowing;
  late Future<List<Movie>> upComing;
  late Future<List<Movie>> popularMovies;

  @override
  void initState() {
    nowShowing = APIservices().getNowShowing();
    upComing = APIservices().getUpComing();
    popularMovies = APIservices().getPopular();
    super.initState();
  }

  ScrollController scrollController =
      ScrollController(initialScrollOffset: HomeScreen.offset);
  ScrollController headerScrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    headerScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    scrollController.addListener(() {
      headerScrollController.jumpTo(headerScrollController.offset +
          scrollController.offset -
          HomeScreen.offset);
      HomeScreen.offset = scrollController.offset;
    });

    return Scaffold(
        body: NestedScrollView(
            controller: headerScrollController,
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverAppBar(
                    toolbarHeight: 60,
                    titleSpacing: 0,
                    pinned: true,
                    floating: true,
                    primary: false,
                    centerTitle: true,
                    automaticallyImplyLeading: false,
                    snap: true,
                    forceElevated: innerBoxIsScrolled,
                    bottom: const PreferredSize(
                        preferredSize: Size.fromHeight(0), child: SizedBox()),
                    title: const Padding(
                      padding: EdgeInsets.only(top: 30, left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.menu),
                          Text(
                            'Movie App',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(Icons.search_rounded),
                              SizedBox(width: 20),
                              Icon(Icons.notifications),
                              SizedBox(width: 10),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        ' Now Showing',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      FutureBuilder(
                        future: nowShowing,
                        builder: (context, snapshot) {
                          // dang cho du lieu => loadinh
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }
                          final movies = snapshot.data!;
                          return CarouselSlider.builder(
                            itemCount: movies.length,
                            itemBuilder: (context, index, movieIndex) {
                              final movie = movies[index];
                              return Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          'https://image.tmdb.org/t/p/original/${movie.backDropPath}',
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 15,
                                    left: 0,
                                    right: 0,
                                    child: Text(
                                      movie.title,
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                ],
                              );
                            },
                            options: CarouselOptions(
                              autoPlay: true,
                              enlargeCenterPage: true,
                              aspectRatio: 1.7,
                              autoPlayInterval: const Duration(seconds: 5),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "  Up Coming Movies",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        height: 250,
                        child: FutureBuilder(
                          future: upComing,
                          builder: (context, snapshot) {
                            // dang cho du lieu => loadinh
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }
                            final movies = snapshot.data!;
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: movies.length,
                              itemBuilder: (context, index) {
                                final movie = movies[index];
                                return Stack(
                                  children: [
                                    Container(
                                      width: 180,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              "https://image.tmdb.org/t/p/original/${movie.backDropPath}"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 15,
                                      left: 0,
                                      right: 0,
                                      child: Text(
                                        movie.title,
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "  Popular Movies",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        height: 250,
                        child: FutureBuilder(
                            future: popularMovies,
                            builder: (context, snapshot) {
                              // dang cho du lieu => loadinh
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              }
                              final movies = snapshot.data!;
                              return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: movies.length,
                                  itemBuilder: (context, index) {
                                    final movie = movies[index];
                                    return Stack(
                                      children: [
                                        Container(
                                          width: 180,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  "https://image.tmdb.org/t/p/original/${movie.backDropPath}"),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 15,
                                          left: 0,
                                          right: 0,
                                          child: Text(
                                            movie.title,
                                            textAlign: TextAlign.center,
                                            maxLines: 1,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )
                                      ],
                                    );
                                  });
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            )));
  }
}
