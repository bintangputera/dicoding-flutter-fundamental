import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/modules/restaurant/bloc/restaurant_bloc.dart';
import 'package:restaurant_app/modules/restaurant/bloc/restaurant_event.dart';
import 'package:restaurant_app/modules/restaurant/bloc/restaurant_state.dart';
import 'package:restaurant_app/modules/restaurant/review/bloc/review_bloc.dart';
import 'package:restaurant_app/modules/restaurant/review/bloc/review_event.dart';
import 'package:restaurant_app/modules/restaurant/review/bloc/review_state.dart';

import '../../../constant/app_constant.dart';
import '../../../data/model/restaurant/customer_review_model.dart';
import '../../../data/model/restaurant/get_detail_restaurant_model.dart';

class DetailScreen extends StatefulWidget {
  final String id;

  DetailScreen(this.id);

  static const String routeName = "/detailScreem";

  @override
  State<DetailScreen> createState() => DetailScreenState();
}

class DetailScreenState extends State<DetailScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _reviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    print(widget.id);

    context.read<RestaurantBloc>().add(GetDetailRestaurantsEvent(widget.id));
    context.read<ReviewBloc>().add(GetRestaurantsReviewEvent(widget.id));
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _reviewController.dispose();
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
        BlocBuilder<RestaurantBloc, RestaurantState>(
          bloc: context.read<RestaurantBloc>(),
          builder: ((context, state) {
            if (state is RestaurantLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is RestaurantDetailSuccess) {
              return _buildContent(state.response.restaurant);
            }
            if (state is RestaurantFailure) {
              return Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16, top: 16),
                child: Center(
                  child: Column(
                    children: [
                      Image.asset("assets/network.png"),
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
                              .read<RestaurantBloc>()
                              .add(GetDetailRestaurantsEvent(widget.id));
                          context
                              .read<ReviewBloc>()
                              .add(GetRestaurantsReviewEvent(widget.id));
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
            return SizedBox();
          }),
        ),
        SizedBox(height: 16),
        BlocConsumer<ReviewBloc, ReviewState>(
          bloc: context.read<ReviewBloc>(),
          listener: (context, state) {
            if (state is ReviewSuccess) {
              _nameController.text = "";
              _reviewController.text = "";
            }
          },
          builder: ((context, state) {
            if (state is ReviewLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is ReviewSuccess) {
              return _buildCustomerReviewSection(state.response);
            }
            return SizedBox();
          }),
        )
      ],
    );
  }

  Widget _buildContent(Restaurant restaurant) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: restaurant.id,
                  child: Image.network(
                    "$IMAGE_URL${restaurant.pictureId}",
                    height: 175,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16)),
                child: Icon(
                  Icons.chevron_left,
                  color: Colors.black,
                  size: 32,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 100.0, left: 16, right: 16),
              child: Center(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            restaurant.name,
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Divider(thickness: 1),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: restaurant.categories.length,
                          itemBuilder: ((context, index) {
                            final category = restaurant.categories[index];
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(category.name),
                            );
                          }),
                        ),
                        Divider(thickness: 1),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            _buildTextWithIcon(
                              Icon(Icons.star, color: Colors.yellow),
                              restaurant.rating.toString(),
                            ),
                            SizedBox(width: 10),
                            _buildTextWithIcon(
                              Icon(Icons.location_on, color: Colors.red),
                              restaurant.city,
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Divider(thickness: 1),
                        SizedBox(height: 8),
                        Text(
                          "Deskripsi Restoran",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          restaurant.description,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Menu Minuman",
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: restaurant.menus.drinks.length,
                  itemBuilder: ((context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Container(
                        decoration: BoxDecoration(
                            border:
                                Border.all(width: 1, color: Color(0xFFEDEDED)),
                            borderRadius: BorderRadius.circular(16)),
                        child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(restaurant.menus.drinks[index].name),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Menu Makanan",
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: restaurant.menus.foods.length,
                  itemBuilder: ((context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Container(
                        decoration: BoxDecoration(
                            border:
                                Border.all(width: 1, color: Color(0xFFEDEDED)),
                            borderRadius: BorderRadius.circular(16)),
                        child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(restaurant.menus.foods[index].name),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerReviewSection(List<CustomerReview> reviews) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Review Customer",
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          _buildCustomerReviewInputBox(),
          SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  _buildCustomerReviewItem(reviews[index]),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerReviewInputBox() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Tulis review kamu!"),
        SizedBox(height: 8),
        TextField(
          controller: _nameController,
          maxLines: 1,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Tulis nama kamu',
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: _reviewController,
          maxLines: 5,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Tulis review kamu',
          ),
        ),
        SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xFF0D9D68)),
          width: double.infinity,
          child: MaterialButton(
            child: Text(
              "Kirim review",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              var body = {
                "id": widget.id,
                "name": _nameController.text,
                "review": _reviewController.text
              };
              context.read<ReviewBloc>().add(AddNewReviewEvent(body));
            },
          ),
        )
      ],
    );
  }

  Widget _buildCustomerReviewItem(CustomerReview review) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              child: Container(
                decoration: BoxDecoration(
                    color: Color(0xFFEDEDED),
                    borderRadius: BorderRadius.circular(32)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.person,
                    color: Color.fromARGB(255, 188, 188, 188),
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
                    review.name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(review.date)
                ],
              ),
            )
          ],
        ),
        SizedBox(height: 8),
        Text(review.review),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTextWithIcon(Icon icon, String text) {
    return Row(
      children: [
        icon,
        Text(
          text,
          style: Theme.of(context)
              .textTheme
              .caption
              ?.copyWith(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ],
    );
  }
}
