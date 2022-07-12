import 'package:client/pages/profile_page.dart';
import 'package:client/utils/app_bar.dart';
import 'package:client/utils/bottom_nav_bar.dart';
import 'package:client/utils/constants.dart';
import 'package:client/utils/routes.dart';
import 'package:client/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:page_transition/page_transition.dart';

class CountryVisaPage extends StatefulWidget {
  const CountryVisaPage({Key? key}) : super(key: key);

  @override
  _CountryVisaPageState createState() => _CountryVisaPageState();
}

GlobalKey<ScaffoldState> countryVisaScaffoldKey = GlobalKey<ScaffoldState>();

class _CountryVisaPageState extends State<CountryVisaPage> {
  // Experience contains: location, title, tags, regenerative score (localised, authentic, intimate), description, photos

  //===================Google Maps=====================
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(1.290270, 103.851959);
  Set<Marker> markersList = {};
  String gmapsAPIkey = dotenv.env['GOOGLE_MAPS_API_KEY']!;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> handleSearchPlaces() async {
    // TODO: investigate strictbounds and types and components
    // TODO: Replace country code for component with retrieval from database
    Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: gmapsAPIkey,
        mode: Mode.fullscreen,
        language: 'en',
        strictbounds: false,
        types: [""],
        decoration:
            const InputDecoration(hintText: 'Search Within Your Country'),
        onError: onSearchError,
        components: [Component(Component.country, "sg")]);

    displayPrediction(p, countryVisaScaffoldKey.currentState);
  }

  void onSearchError(PlacesAutocompleteResponse response) {
    TFSnackBar.showSnackBar(message: response.errorMessage!, context: context);
  }

  Future<void> displayPrediction(
      Prediction? p, ScaffoldState? currentState) async {
    if (p == null) {
      TFSnackBar.showErrorSnackBar(
          message: "Enter a valid search place! (Must be within the country)",
          context: context);
      print("Enter a valid search place! (Must be within the country)");
      return;
    }

    GoogleMapsPlaces places = GoogleMapsPlaces(
        apiKey: gmapsAPIkey,
        apiHeaders: await const GoogleApiHeaders().getHeaders());

    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);

    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;

    markersList.clear();
    markersList.add(
      Marker(
        markerId: const MarkerId("0"),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(
          title: detail.result.name,
        ),
      ),
    );

    setState(() {});

    mapController
        .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 14.0));
  }

  Widget googleMapsCard() {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      markers: markersList,
      mapType: MapType.satellite,
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 11.0,
      ),
    );
  }

  //=========================Widget=======================================
  Widget searchPlacesButton() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: handleSearchPlaces,
              child: const Text("Search Places"),
            ),
            const Text("*You may only search\nwithin this country")
          ],
        ),
        const Expanded(child: SizedBox())
      ],
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
      key: countryVisaScaffoldKey,
      appBar: TFAppBars().buildMediumBlue(context, "Singapore"),
      body: SingleChildScrollView(
        child: SizedBox(
          // Phone screen's height and width to wrap column
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                searchPlacesButton(),
                const SizedBox(height: 20),
                Container(
                    constraints: BoxConstraints(
                        maxHeight: 300,
                        maxWidth: MediaQuery.of(context).size.width - 20),
                    child: googleMapsCard()),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar:
          TFBottomNavBar().build(context, BottomNavBarOptions.countryVisa),
    );
  }
}
