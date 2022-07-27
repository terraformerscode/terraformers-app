import 'package:client/appimagespath.dart';
import 'package:client/server_interface/experience_details_api.dart';
import 'package:client/utils/app_bar.dart';
import 'package:client/utils/bottom_nav_bar.dart';
import 'package:client/utils/constants.dart';
import 'package:client/utils/routes.dart';
import 'package:flutter/material.dart';

class AllCountryVisasPage extends StatefulWidget {
  const AllCountryVisasPage({Key? key}) : super(key: key);

  @override
  _AllCountryVisasPageState createState() => _AllCountryVisasPageState();
}

class _AllCountryVisasPageState extends State<AllCountryVisasPage> {
  late Image _globeWhite;
  // TODO: Transfer to database and retrieve from there
  //TODO: HERE NOW - Use futurebuilder to build the all country visa page
  Future<dynamic> userCountryVisasFuture =
      ExperienceDetailsAPI.getUserCountryISO();
  Map<String, String> initialData = {"Singapore": "SG"};

  double pageHorizontalPadding = 20;
  double pageVerticalPadding = 0;

  //=========================Widget=======================================
  Widget terraformersYellowGlobe() {
    return SizedBox(
      child: _globeWhite,
    );
  }

  Widget buildRow(List<String> countryVisas, int count, int heightFraction) {
    return SizedBox(
        height: MediaQuery.of(context).size.height / heightFraction,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: count,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: MediaQuery.of(context).size.height / heightFraction,
                width: (MediaQuery.of(context).size.width -
                        pageHorizontalPadding -
                        20) /
                    count,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: GestureDetector(
                  onTap: () {
                    Routes.countryVisaRoute(context, false);
                  },
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      terraformersYellowGlobe(),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: TerraformersConst.mediumBlue,
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        child: Text(
                          countryVisas[index],
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(color: TerraformersConst.yellow),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }));
  }

  //=====================Flutter Override Methods==============================
  @override
  void initState() {
    _globeWhite = Image.asset(
      AppImagesPath.globeWhite,
      fit: BoxFit.fitHeight,
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TFAppBars().buildMediumBlue(context, title: "Your Country Visas"),
      body: SizedBox(
        // Phone screen's height and width to wrap column
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: pageVerticalPadding, horizontal: pageHorizontalPadding),
          child: FutureBuilder(
            future: userCountryVisasFuture,
            initialData: initialData,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return const Text("Loading...");
              }
              if (snapshot.hasError) {
                return const Text("ERROR LOADING!");
              }

              print(snapshot.data);
              dynamic userCountryVisasMap = snapshot.data;
              List<String> userCountryVisas = [];
              userCountryVisasMap.forEach((countryName, countryMap) {
                userCountryVisas.add(countryName);
              });

              //TODO: Take in the country code and use it to display appropriate
              // countryVisaPage
              return Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  buildRow(userCountryVisas, 3, 5),
                  const SizedBox(height: 20),
                ],
              );
            },
          ),
        ),
      ),
      bottomNavigationBar:
          TFBottomNavBar().build(context, BottomNavBarOptions.countryVisa),
    );
  }
}
