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
import 'package:geolocator/geolocator.dart';
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

  double distance(double lat1, double lng1, double lat2, double lng2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lng2 - lng1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  //=======================Location=========================
  Future<Position> getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  //===================Google Maps=====================
  late GoogleMapController mapController;
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

    resetMarketSet();
    fiveNearestExperiences.forEach((key, value) {
      String experienceTitle = value["title"];
      String experienceDescription = value["description"];
      double experienceLat = value["position"]["lat"];
      double experienceLng = value["position"]["lng"];
      markersSet.add(
        Marker(
          markerId: MarkerId(key),
          position: LatLng(experienceLat, experienceLng),
          infoWindow: InfoWindow(
            title: experienceTitle,
            snippet: experienceDescription
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
            snippet: "Searched Location"
          ),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)),
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
      initialCameraPosition: const CameraPosition(
        target: LatLng(0, 0),
        zoom: 11.0,
      ),
    );
  }

  Future<LatLng> getCurrentLocation() async {
    Position currentPosition = await getGeoLocationPosition();
    LatLng currLatLng =
        LatLng(currentPosition.latitude, currentPosition.longitude);
    Marker marker = Marker(
        markerId: const MarkerId("currentLocation"),
        position: currLatLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue));
    markersSet.add(marker);
    setState(() {});
    return currLatLng;
  }

  void displayCurrentLocation() async {
    LatLng currLatLng = await getCurrentLocation();
    mapController.animateCamera(CameraUpdate.newLatLngZoom(currLatLng, 11.5));
  }

  void resetMarketSet() async {
    markersSet.clear();
    LatLng currLatLng = await getCurrentLocation();
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
    displayCurrentLocation();
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
      appBar: TFAppBars().buildMediumBlue(context, title: "Singapore"),
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
