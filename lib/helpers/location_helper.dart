import 'package:http/http.dart' as http;

const GOOGLE_API_KEY = 'AIzaSyDGm6nuFk3eR9hUbz4cce6NM41mPgdkoGE';

class LoactionHelpers {
  static String generateLocationPreviewImage(
      {double latitude, double longitude}) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=${latitude},${longitude}&zoom=13&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C${latitude},${longitude}&key=${GOOGLE_API_KEY}';
  }

  static Future<String> getPlaceAddress(double lat, double long) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json/?latlng=${lat},${long}&key=$GOOGLE_API_KEY');
    final response = await http.get(url);
  }
}
