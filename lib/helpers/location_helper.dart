import 'dart:convert';

import 'package:http/http.dart' as http;

const _kGoogleApiKey = 'AIzaSyCT9ld5GaIHsmcn_3FHw_Ynb5QYNkMVho0';

class LocationHelper {
  static String generateLocationPreviewImage(
      {double? latitude, double? longitude}) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&zoom=13&size=600x300&maptype=roadmap&markers=color:blue%7Clabel:L%7C$latitude,$longitude&key=$_kGoogleApiKey';
  }

  static Future<String> getPlaceAddress(double lat, double lng) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$_kGoogleApiKey');
    final response = await http.get(url);

    return jsonDecode(response.body)['results'][0]['formatted_address'];
  }
}
