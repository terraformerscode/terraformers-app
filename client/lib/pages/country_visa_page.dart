import 'package:client/pages/profile_page.dart';
import 'package:client/utils/app_bar.dart';
import 'package:client/utils/bottom_nav_bar.dart';
import 'package:client/utils/constants.dart';
import 'package:client/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:page_transition/page_transition.dart';

class CountryVisaPage extends StatefulWidget {
  const CountryVisaPage({Key? key}) : super(key: key);

  @override
  _CountryVisaPageState createState() => _CountryVisaPageState();
}

class _CountryVisaPageState extends State<CountryVisaPage> {
  // Experience contains: location, title, tags, regenerative score (localised, authentic, intimate), description, photos

  //===================Google Maps=====================
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(1.290270, 103.851959);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> handleSearchPlaces() async {
    Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey: dotenv.env['GOOGLE_MAPS_API_KEY']!,
      // onError: onError,
      mode: Mode.overlay,
    );

  }

  //=========================Cards=======================================
  Widget googleMapsCard() {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 11.0,
      ),
    );
  }

  Widget searchPlacesButton() {
    return ElevatedButton(
      onPressed: handleSearchPlaces,
      child: const Text("Search Places"),
    );
  }

  //=====================Flutter Override Methods==============================
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TFAppBars().buildMediumBlue(context, "Singapore"),
      body: SizedBox(
        // Phone screen's height and width to wrap column
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Singapore"),
              const SizedBox(height: 80),
              Container(
                  constraints: BoxConstraints(
                      maxHeight: 300,
                      maxWidth: MediaQuery.of(context).size.width - 20),
                  child: googleMapsCard()),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      bottomNavigationBar:
          TFBottomNavBar().build(context, BottomNavBarOptions.countryVisa),
    );
  }
}
