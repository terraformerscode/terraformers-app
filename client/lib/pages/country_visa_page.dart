import 'dart:math';

import 'package:client/pages/profile_page.dart';
import 'package:client/server_interface/experience_details_api.dart';
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

class _CountryVisaPageState extends State<CountryVisaPage> {
  // Experience contains: location, title, tags, regenerative score (localised, authentic, intimate), description, photos

  // SEARCH FLOW ==> Search for place, Get LATLNG of place,
  // Search through village list for closest villages, Populate marker list

  //TODO: Type cast properly (gives error for some reason)
  late dynamic experienceDetails;

  void getExperienceDetails() async {
    experienceDetails = await ExperienceDetailsAPI.getExperienceDetails();
  }

  Map<String, Map<String, dynamic>> getNearestExperiences(
      double searchLat, double searchLng, int numOfExperiences) {
    List<Map<String, dynamic>> idLatLngArr = [];
    experienceDetails.forEach((key, value) {
      double distanceFromSearch = distance(searchLat, searchLng,
          value["position"]["lat"], value["position"]["lng"]);
      Map<String, dynamic> idLatLngItem = {
        "id": key,
        "dist": distanceFromSearch,
      };
      idLatLngArr.add(idLatLngItem);
    });

    idLatLngArr.sort(((a, b) => a["dist"].compareTo(b["dist"])));
    Iterable<Map<String, dynamic>> nearestExperiencesArr =
        idLatLngArr.take(numOfExperiences);

    Map<String, Map<String, dynamic>> nearestExperiencesMap = {};
    nearestExperiencesArr.forEach((element) {
      nearestExperiencesMap[element["id"]] = experienceDetails[element["id"]];
    });

    print("NEAREST EXPERIENCES: $nearestExperiencesMap");
    return nearestExperiencesMap;
  }

  //TODO: Check accuracy
  double distance(double lat1, double lng1, double lat2, double lng2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lng2 - lng1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  //===================Google Maps=====================
  late GoogleMapController mapController;
  late LatLng _center;
  late Set<Marker> markersSet;
  late String gmapsAPIkey;

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
            const InputDecoration(hintText: 'Search for nearby experiences'),
        onError: onSearchError,
        components: [Component(Component.country, "sg")]);

    displayPrediction(p);
  }

  void onSearchError(PlacesAutocompleteResponse response) {
    TFSnackBar.showSnackBar(message: response.errorMessage!, context: context);
  }

  Future<void> displayPrediction(Prediction? p) async {
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

    Map<String, Map<String, dynamic>> fiveNearestExperiences =
        getNearestExperiences(lat, lng, 5);

    markersSet.clear();
    fiveNearestExperiences.forEach((key, value) {
      String experienceTitle = value["title"];
      double experienceLat = value["position"]["lat"];
      double experienceLng = value["position"]["lng"];
      markersSet.add(
        Marker(
          markerId: MarkerId(key),
          position: LatLng(experienceLat, experienceLng),
          infoWindow: InfoWindow(
            title: experienceTitle,
          ),
        ),
      );
    });
    markersSet.add(
      Marker(
        markerId: const MarkerId("searchResult"),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(
          title: detail.result.name,
        ),
      ),
    );

    setState(() {});

    mapController
        .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 11.5));
  }

  Widget googleMapsCard() {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      markers: markersSet,
      mapType: MapType.hybrid,
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
              child: const Text("Search Experiences"),
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
    //TODO: Replace center with user location, IF they are in the same country
    // ELSE use default centre for the country
    // Add Marker also
    _center = const LatLng(1.290270, 103.851959);
    gmapsAPIkey = dotenv.env['GOOGLE_MAPS_API_KEY']!;
    markersSet = {};
    getExperienceDetails();
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
      bottomNavigationBar:
          TFBottomNavBar().build(context, BottomNavBarOptions.countryVisa),
    );
  }
}
