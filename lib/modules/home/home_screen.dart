import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/constant/app_constant.dart';
import 'package:restaurant_app/data/model/restaurant/get_restaurant_model.dart';
import 'package:restaurant_app/modules/home/bloc/home_bloc.dart';
import 'package:restaurant_app/modules/home/bloc/home_event.dart';
import 'package:restaurant_app/modules/home/bloc/home_state.dart';
import 'package:restaurant_app/modules/restaurant/detail/detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController keywordNameController = TextEditingController();

  bool isLoading = true;

  List<Restaurant> restaurantList = [];

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(GetListRestaurantsEvent());
  }

  @override
  void dispose() {
    super.dispose();
    keywordNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: SingleChildScrollView(child: _buildBody())),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: 130,
              decoration: BoxDecoration(color: Color(0xFF0D9D68)),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderSection(),
                _buildSearchView(),
              ],
            ),
          ],
        ),
        BlocConsumer<HomeBloc, HomeState>(
          bloc: context.read<HomeBloc>(),
          listener: ((context, state) {
            if (state is HomeSuccess) {
              restaurantList.clear();
              restaurantList.addAll(state.response.restaurants);
            }
          }),
          builder: ((context, state) {
            if (state is HomeLoading) {
              return CircularProgressIndicator();
            }
            if (state is HomeSuccess) {
              return _buildRestaurantList();
            }
            if (state is HomeFailure) {
              return Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16, top: 16),
                child: Center(
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/network.png",
                        height: 200,
                        width: 150,
                      ),
                      Text("Koneksi Gagal",
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      SizedBox(height: 16),
                      Text(
                        "Tidak bisa menyambungkan dengan internet, silahkan coba lagi",
                        style: Theme.of(context).textTheme.bodyText1,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      IconButton(
                        onPressed: () {
                          context
                              .read<HomeBloc>()
                              .add(GetListRestaurantsEvent());
                        },
                        icon: Icon(
                          Icons.refresh,
                          color: Colors.black,
                          size: 32,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            if (state is HomeEmpty) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Align(
                  alignment: Alignment.center,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "Data restoran dengan keyword : ",
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                            text: keywordNameController.text,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: " tidak ditemukan"),
                      ],
                    ),
                  ),
                ),
              );
            }
            return SizedBox();
          }),
        ),
      ],
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 25,
        ),
        Center(
          child: Text(
            "Mau makan \napa hari ini ?",
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 25,
        ),
      ],
    );
  }

  Widget _buildSearchView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        child: TextField(
          controller: keywordNameController,
          maxLines: 1,
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search),
            hintText: 'Cari restoran favorit kamu',
          ),
          onSubmitted: (value) {
            if (value.isEmpty) {
              context.read<HomeBloc>().add(GetListRestaurantsEvent());
            } else {
              context.read<HomeBloc>().add(SearchRestaurantsEvent(value));
            }
          },
        ),
      ),
    );
  }

  Widget _buildRestaurantList() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: restaurantList.length,
        itemBuilder: ((context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Column(
              children: [
                _buildRestaurantItem(restaurantList[index]),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildRestaurantItem(Restaurant restaurant) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, DetailScreen.routeName,
            arguments: restaurant.id);
      },
      child: Row(
        children: [
          Flexible(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Hero(
                tag: restaurant.id,
                child: Image.network(
                  "$IMAGE_URL${restaurant.pictureId}",
                  fit: BoxFit.cover,
                  height: 100,
                  width: 125,
                  errorBuilder: ((context, error, stackTrace) {
                    return Image.asset(
                      "assets/network.png",
                      height: 100,
                      width: 125,
                    );
                  }),
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restaurant.name,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.red,
                    ),
                    Text(
                      restaurant.city,
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          ?.copyWith(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                    ),
                    Text(
                      restaurant.rating.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          ?.copyWith(fontWeight: FontWeight.bold),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
