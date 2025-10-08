import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dignito/services/local_storage_service.dart';
import '../models/CandDetails.dart';
import 'package:get/get.dart';
import '../models/ParticipantDetails.dart';
import '../models/placement_model.dart';
import '../services/shared_pref_service.dart';

class HttpServices {
  static String? appkey;
  static String? usertype;
  static Map<String, String>? appdata;
  static Future<void> _appdata() async {
  appdata =await SharedPrefHelper.getAppData();
}

  
static Future <void> _checkAppKey() async {
    appkey = await SharedPrefHelper.getAppKey();}
  static void _clearResponse(Map<String, dynamic> response) {
  // Clear the map to free up memory
  response.clear();
}
  
  static Future<bool> login(String username, String password) async {
  bool retVal = false;
  await _checkAppKey();
  await _appdata();
  await LocalStorage.setimage('festid', appdata!['festid']);
  final credentials = {
    'username': username,
    'password': password,
    'usertype' : appdata!['usertype'],
    'fest_id' : appdata!['festid'],
    'api_key' : appkey
  };
  Get.log(credentials.toString());
  final headers = {
    'Content-Type': 'application/json',
    
  };

  final body = json.encode(credentials);

  final response = await http.post(
    Uri.parse('https://dicoman.dist.ac.in/api/Fest/Login'),
    headers: headers,
    body: body,
  );
  Get.log(response.body);
  if (response.statusCode == 200) {
    
    final Map<String, dynamic> responseData = json.decode(response.body);
    if (responseData['status'] == 1){
      print(responseData);
      retVal = true;
      
      String staffid = responseData['user_id'].toString();
      print(staffid);
      String category = responseData['category'].toString();
      String eventid = responseData['eventid'].toString();
      Get.log(eventid);
      await LocalStorage.setValue('staff_id', staffid);
      print(staffid);
      await LocalStorage.setValue('category', category);
      await LocalStorage.setValue('event_id', eventid); 
    } else {
      print("status 0");
    }
  } else {
    print('server failed');
  }

  return retVal;
  }


    static Future<bool> loginkey(String username, String password, String key) async {
  bool retVal = false;
  final credentials = {
    'username': username,
    'password': password,
    'userkey' : key
  };
  Get.log(credentials.toString());
  final headers = {
    'Content-Type': 'application/json',
  };

  final body = json.encode(credentials);

  final response = await http.post(
    Uri.parse('https://dicoman.dist.ac.in/api/Fest/FirstLogin'),
    headers: headers,
    body: body,
  );
  Get.log(response.body);
  if (response.statusCode == 200) {
    
    final Map<String, dynamic> responseData = json.decode(response.body);
    if (responseData['status'] == 1){
      print(responseData);
      retVal = true;
      String appKey = responseData['api_key'].toString();
      String appTitle = responseData['fest_name'].toString();
      String logoData = responseData['logo'].toString();
      String festid=responseData['fest_id'].toString();

      //staffid is the userid
      String staffid = responseData['userid'].toString();
      String category = responseData['category'].toString();
      String eventid = responseData['eventid'].toString();
      String usertype = responseData['usertype'].toString();
      String message = responseData['message'].toString();
      //await LocalStorage.setimage('festid', appdata!['festid']);
      await SharedPrefHelper.saveAppData(
      appKey: appKey,
      appTitle: appTitle,
      festid: festid,
      usertype : usertype,

    );
    await _checkAppKey();
    await _appdata();
    print('App data saved to SharedPreferences');


     // Print all extracted values
      print('appKey: $appKey');
      print('appTitle: $appTitle');
      print('festid: $festid');
      print('staffid: $staffid');
      print('category: $category');
      print('eventid: $eventid');
      print('usertype: $usertype');
      print('message: $message');
   
    } else {
      print("status 0");
    }
  } else {
    print('server failed');
  }

  return retVal;
  }



  static Future<CandidateDetails?> isCandIdValid() async {
    bool isValid = false;
    String? Candid = await LocalStorage.getValue('CandId');
    String? StaffId = await LocalStorage.getValue('staff_id');
    String? category = await LocalStorage.getValue('category');
    String? eventid = await LocalStorage.getValue('event_id');
    String event = eventid.toString();
    Get.log(event);
    final credentials = {
    'cand_id': Candid,
    'user_id':StaffId,
    'category': category,
    'eventid': event,
    'usertype' : appdata!['usertype'],
    'fest_id' : appdata!['festid'],
    'api_key' : appkey
    };

    Get.log(credentials.toString());

    final headers = {
      'Content-Type': 'application/json',
    };
    
    final body = json.encode(credentials);

    final response = await http.post(
      Uri.parse('https://dicoman.dist.ac.in/api/Fest/Candidate'), //change uri
      headers: headers,
      body: body,
    );


    if (response.statusCode == 200){
      print(response.body);
      Get.log("Response: ${response.body}");

        final decodedResponse = json.decode(response.body);
        Get.log(response.body.toString());
        CandidateDetails candidateDetails = CandidateDetails(
          iname: decodedResponse['iname'],
          cname: decodedResponse['cname'],
          events: decodedResponse['events'],
          pay_status: decodedResponse['pay_status'],
          status: decodedResponse['status'],
        );
        return candidateDetails;
    } else {
      return null;
    }
  }

static Future<bool> issueIdCard() async {

  bool retVal = false;
  
  String? Candid = await LocalStorage.getValue('CandId');
  String? StaffId = await LocalStorage.getValue('staff_id');
  String? category = await LocalStorage.getValue('category');
  String? eventid = await LocalStorage.getValue('eventid');
  
  Get.log(eventid.toString());
  Get.log("issuing ID");
  final credentials = {
  'cand_id': Candid,
  'user_id':StaffId,
  'category': category,
  'eventid': eventid,
  'usertype' : appdata!['usertype'],
  'fest_id' : appdata!['festid'],
  'api_key' : appkey
  };

  final headers = {
    'Content-Type': 'application/json',
  };
  Get.log(credentials.toString());
  final body = json.encode(credentials);

  final response = await http.post(
    Uri.parse('https://dicoman.dist.ac.in/api/Fest/Update'),
    headers: headers,
    body: body,
  );
  Get.log(response.statusCode.toString());
  print(response.statusCode.toString());
  print(response.body.toString());
  if(response.statusCode == 200)
  {
    print("updated");
    Get.log("Response: ${response.toString()}");
    retVal = true; 
  }
  return retVal;
}


static Future<Participantdetails?> EventId() async {
  try {
    // Retrieve values from local storage
    String? Candid = await LocalStorage.getValue('CandId');
    String? StaffId = await LocalStorage.getValue('staff_id');
    print(StaffId);
    String? category = await LocalStorage.getValue('category');
    String? eventid = await LocalStorage.getValue('event_id');

    // Ensure all required values are present
    if ([Candid, StaffId, category, eventid].contains(null)) {
      Get.log('Error: One or more local storage values are null.');
      return null;
    }

    // Prepare request body and headers
    final credentials = {
      'cand_id': Candid,
      'user_id': StaffId,
      'category': category,
      'eventid': eventid,
      'fest_id' : appdata!['festid'],
      'usertype' : appdata!['usertype'],
      'api_key' : appkey
    };

    final headers = {'Content-Type': 'application/json'};
    final body = json.encode(credentials);

    Get.log('Request Body: $body'); // Log request

    // Send POST request
    final response = await http.post(
      Uri.parse('https://dicoman.dist.ac.in/api/Fest/Candidate'),
      headers: headers,
      body: body,
    );

    // Log response details
    Get.log("Response Status: ${response.statusCode}");
    Get.log("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);


      print("reponse details after scan qr data");
      print(decodedResponse.toString());

      // Parse the response into Participantdetails model
      try {
        Participantdetails participantDetails = 
            Participantdetails.fromJson(decodedResponse);

            print(participantDetails.toString());
        return participantDetails;
      } catch (e) {
        Get.log('Error parsing Participantdetails: $e');
        return null;
      }
    } else {
      Get.log('Error: Invalid response with status ${response.statusCode}');
      return null;
    }
  } catch (e) {
    Get.log('Error fetching EventId: $e');
    return null;
  }
}






static Future<bool> issueChestNumber(Participantdetails partdet) async {
  bool retVal = false;
    String? Candid = await LocalStorage.getValue('CandId');
    String? StaffId = await LocalStorage.getValue('staff_id');
    String? category = await LocalStorage.getValue('category');
    String? eventid = await LocalStorage.getValue('event_id');
  final credentials = {
  'cand_id': Candid,
  'user_id': StaffId,
  'category': category,
  'eventid': eventid,
  'chest_code': partdet.chestcode,
  'chest_no': partdet.chestnumber,
  'chest_status': partdet.cheststatus,
  'usertype' : appdata!['usertype'],
  'api_key' : appkey,
  'fest_id' : appdata!['festid']
  };
  print(appkey);
  Get.log(credentials.toString());

  final headers = {
    'Content-Type': 'application/json',
  };
  
  final body = json.encode(credentials);

  final response = await http.post(
    Uri.parse('https://dicoman.dist.ac.in/api/Fest/Update'), 
    headers: headers,
    body: body,
  );
  print(response.body);
  final decoderesponse = jsonDecode(response.body);
  print(response.body.toString());
  if(response.statusCode == 200)
  {
    print("updated");
    Get.log("Response: ${response.body.toString()}");
    retVal = true;
    Get.log(decoderesponse['message']);
    Get.snackbar("Message", decoderesponse['message'], colorText: Colors.white); 
  }
  return retVal;
}

static Future<dynamic> getplacementDetails(String chestno) async {
  bool retVal = false;
  final credentials = {
    'chestno' : chestno,
    'fest_id' : appdata!['festid'],
    'user_id' : await LocalStorage.getValue('staff_id'),
    'usertype' : appdata!['usertype'],
    'api_key' : appkey
  };
  final headers = {
    'Content-Type': 'application/json',
  };
  
  final body = json.encode(credentials);
  Get.log(credentials.toString());
  final response = await http.post(
    Uri.parse('https://dicoman.dist.ac.in/api/Fest/Team'), 
    headers: headers,
    body: body,
  );
  print("before  req");
  print(response.body.toString());
  final decoderesponse = jsonDecode(response.body);
  print("reponse");
  print((decoderesponse).toString());
  if(response.statusCode == 200)
  {
    Get.log("Response: ${response.body.toString()}");
    if(decoderesponse['member_status'] == 0 ){
      Get.snackbar('Unsuccessful', 'Invalid chest number', colorText: Colors.white);
      return retVal;
    } else {
      PlacementDetails placementDetails = PlacementDetails(
          instname: decoderesponse['inst_name'],
          members: decoderesponse['members'],
          memberstatus: decoderesponse['member_status'].toString()

        );
        retVal = true;
        return placementDetails;
    }
  }
  Get.snackbar("Error", "An error occured", colorText: Colors.white);
  return retVal;
}

static Future<bool> postplacement(String firstpo, String secondpo) async {
  bool retVal = false;
  String? eventid = await LocalStorage.getValue('event_id');
  final credentials = {
    'event_id': eventid,
    'prize': {
      '1': firstpo,
      '2': secondpo,
    },

    'api_key' : appkey,
    'fest_id' : appdata!['festid'],
    'user_id' : await LocalStorage.getValue('staff_id'),
    'usertype' : appdata!['usertype'],
  };
  final headers = {
    'Content-Type': 'application/json',
  };
  try{
  final body = json.encode(credentials);
  Get.log(credentials.toString());
  final response = await http.post(
    Uri.parse('https://dicoman.dist.ac.in/api/Fest/Prize'), 
    headers: headers,
    body: body,
  );
  Get.log(response.statusCode.toString());
  print(response.statusCode.toString());
  print(response.body.toString());
  if(response.statusCode == 200)
  {
    final decoderesponse = jsonDecode(response.body);
    Get.log("Response: ${response.body.toString()}");
    if(decoderesponse['status'] == 0 ){
      Get.snackbar('Unsuccessful', decoderesponse['message'], colorText: Colors.white);
      return retVal;
    } else {
      Get.snackbar("Successful", decoderesponse['message'],colorText: Colors.white);
     return true;
    }
  }
  else{
    Get.snackbar("Error", "An error occured", colorText: Colors.white);
  }
  }
  catch(e){
    print('error : $e');
  }

  return retVal;
}
static Future<bool> postplacement1(String firstpo) async {
  bool retVal = false;
  String? eventid = await LocalStorage.getValue('event_id');
  final credentials = {
    'event_id': eventid,
    'prize': {
      '1': firstpo
    },

    'api_key' : appkey,
    'fest_id' : appdata!['festid'],
    'user_id' : await LocalStorage.getValue('staff_id'),
    'usertype' : appdata!['usertype'],
  };
  final headers = {
    'Content-Type': 'application/json',
  };
  try{
  final body = json.encode(credentials);
  Get.log(credentials.toString());
  final response = await http.post(
    Uri.parse('https://dicoman.dist.ac.in/api/Fest/Prize'), 
    headers: headers,
    body: body,
  );
  Get.log(response.statusCode.toString());
  print(response.statusCode.toString());
  print(response.body.toString());
  if(response.statusCode == 200)
  {
    final decoderesponse = jsonDecode(response.body);
    Get.log("Response: ${response.body.toString()}");
    if(decoderesponse['status'] == 0 ){
      Get.snackbar('Unsuccessful', decoderesponse['message'], colorText: Colors.white);
      return retVal;
    } else {
      Get.snackbar("Successful", decoderesponse['message'],colorText: Colors.white);
     return true;
    }
  }
  else{
    Get.snackbar("Error", "An error occured", colorText: Colors.white);
  }
  }
  catch(e){
    print('error : $e');
  }

  return retVal;
}


}

/*import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dignito/services/local_storage_service.dart';
import '../models/CandDetails.dart';
import 'package:get/get.dart';
import '../models/ParticipantDetails.dart';
import '../models/placement_model.dart';
import '../services/shared_pref_service.dart';

class HttpServices {
  static String baseUrl = 'http://dicoman.dist.ac.in/api/';

  static void _clearResponse(Map<String, dynamic> response) {
  // Clear the map to free up memory
  response.clear();
}
    
  static Future<bool> login(String username, String password, int usertype) async {
  bool retVal = false;

  // Keep original credentials logging
  final credentials = {
    'username': username,
    'password': password,
    'usertype': usertype
  };
  Get.log(credentials.toString());

  // Simulate delay as if contacting server
  await Future.delayed(const Duration(milliseconds: 500));

  // Mock response data (hardcoded)
  final Map<String, dynamic> responseData = {
    'status': 1,
    'staff_id': 'IMCA22016',
    'category': '2',
    'eventid': '12'
  };

  // Keep the original logic intact
  if (responseData['status'] == 1) {
    print(responseData);
    retVal = true;
    String staffid = responseData['staff_id'].toString();
    String category = responseData['category'].toString();
    String eventid = responseData['eventid'].toString();
    Get.log(eventid);

    // Store the mock values in LocalStorage
    await LocalStorage.setValue('staff_id', staffid);
    await LocalStorage.setValue('category', category);
    await LocalStorage.setValue('event_id', eventid);
  } else {
    print("status 0");
  }

  return retVal;
}

static Future<bool> loginkey(String username, String password, String key) async {
  bool retVal = false;

  // Keep original credentials logging
  final credentials = {
    'username': username,
    'password': password,
    'key': key
  };
  Get.log(credentials.toString());

  // Simulate delay as if contacting server
  await Future.delayed(const Duration(milliseconds: 500));

  String base64Logo = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAAAAlwSFlzAAAuIwAALiMBeKU/dgAAAVlpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IlhNUCBDb3JlIDUuNC4wIj4KICAgPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4KICAgICAgPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIKICAgICAgICAgICAgeG1sbnM6dGlmZj0iaHR0cDovL25zLmFkb2JlLmNvbS90aWZmLzEuMC8iPgogICAgICAgICA8dGlmZjpPcmllbnRhdGlvbj4xPC90aWZmOk9yaWVudGF0aW9uPgogICAgICA8L3JkZjpEZXNjcmlwdGlvbj4KICAgPC9yZGY6UkRGPgo8L3g6eG1wbWV0YT4KTMInWQAAAdVJREFUOBF9Uz1PG0EQfXt3PoNEYgrCh4AiSEnhICQLI0qoqHGN6PIDEE0qmqSNlCapwg9ImTpFAjYIR5DQuECyEFKk2HJhLEJxyN69zcyd116fE29xuzu7772Zt3NC08CIYZ8KMXzRGw71IwxOgpKx/xKEBHZI8aKh8PM2BO+n0sD20xQ8OxMuITlUGEfKNanXjgPtfQ104eRB1+5VdBB2z3kj+NNPGpESK5frCvvVDjK0eU7Kr1d8ZNKid24wjlnwbNL+boEXU8DBcgzuhHFZNqaXgTGHwXukPEnK8wR+l/PxyLeLtuFkMpdgwKXfEq+uZQSeJXvfr/qQpFppKqRdAUnF5p448GltxkAJbMaZAjjtD3kfbVq//NHG1pVEvtKJSmSw7VqvBMNYrks8m3ThUmCzGGB63EHGd3GwJLAy7YFF+vrdEgzYmPhAub74EuBOuGgqhaNsiI2lCXRUiJQ7kDQGdvx8TDJGnXKY9dFsS+qkU3z6+BmtP0EEph4wevEcm5j4djvl2+UvjYU3Gt5bPbdzqGuNVnQxtDppyAOmZQ1+God+hNJ5FcWLG0hKf3HmMXYL60h5bs+LfxLEucVEtmEcpy6OiM2dkQQGYEhE8tekC38BADIeNqhZl4wAAAAASUVORK5CYII=';

   await SharedPrefHelper.saveAppData(
      appKey: '343434',
      appTitle: 'Digito',
      logoData: base64Logo,
   );
   retVal = true;


  return retVal;
}


  static Future<CandidateDetails?> isCandIdValid() async {
  bool isValid = false;
  String? Candid = await LocalStorage.getValue('CandId');
  String? StaffId = await LocalStorage.getValue('staff_id');
  String? category = await LocalStorage.getValue('category');
  String? eventid = await LocalStorage.getValue('event_id');
  String event = eventid.toString();
  Get.log(event);

  final credentials = {
    'cand_id': Candid,
    'staff_id': StaffId,
    'category': category,
    'eventid': event
  };

  Get.log(credentials.toString());

  // Simulate a network delay
  await Future.delayed(const Duration(milliseconds: 500));

  // Hardcoded sample response (mock)
  final decodedResponse = {
    'iname': 'John Doe',
    'cname': 'Sample Candidate',
    'events': 'Sample Event',
    'pay_status': 'Paid',
    'status': 1,
  };

  Get.log("Response: ${decodedResponse.toString()}");
  print(decodedResponse);

  // Construct the CandidateDetails object
  CandidateDetails candidateDetails = CandidateDetails(
  iname: decodedResponse['iname'] as String,
  cname: decodedResponse['cname'] as String,
  events: decodedResponse['events'] as String,
  pay_status: decodedResponse['pay_status'] as String,
  status: decodedResponse['status'] as int,
);


  return candidateDetails;
}

static Future<bool> issueIdCard() async {
  bool retVal = false;

  // Manually set sample values instead of fetching from server
  String? Candid = await LocalStorage.getValue('CandId') ?? "CAND123";
  String? StaffId = await LocalStorage.getValue('staff_id') ?? "STAFF001";
  String? category = await LocalStorage.getValue('category') ?? "CategoryA";
  String? eventid = await LocalStorage.getValue('eventid') ?? "EVENT2025";

  Get.log(eventid.toString());
  Get.log("issuing ID");

  // Keep the credentials structure same
  final credentials = {
    'cand_id': Candid,
    'staff_id': StaffId,
    'category': category,
    'eventid': eventid
  };

  Get.log(credentials.toString());

  // Simulate successful response manually
  await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
  Get.log("Response Status: 200");
  Get.log("Response: {status: 1, message: 'ID card issued successfully'}");

  retVal = true; // Set manual success

  return retVal;
}



static Future<Participantdetails?> EventId() async {
  try {
    // Retrieve values from local storage or use sample defaults
    String? Candid = await LocalStorage.getValue('CandId') ?? "CAND123";
    String? StaffId = await LocalStorage.getValue('staff_id') ?? "STAFF001";
    String? category = await LocalStorage.getValue('category') ?? "CategoryA";
    String? eventid = await LocalStorage.getValue('event_id') ?? "EVENT2025";

    // Keep the credentials object same
    final credentials = {
      'cand_id': Candid,
      'staff_id': StaffId,
      'category': category,
      'eventid': eventid,
    };
    Get.log('Request Body: ${json.encode(credentials)}');

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Log a manual response
    Get.log("Response Status: 200");
    Get.log("Response Body: {"
        "'cand_id': '$Candid', "
        "'staff_id': '$StaffId', "
        "'category': '$category', "
        "'eventid': '$eventid', "
        "'chestcode': 'CHEST001', "
        "'chestnumber': '10', "
        "'cheststatus': 'not assigned',"
        "}");

    // Return manually created Participantdetails
    Participantdetails participantDetails = Participantdetails(
      iname: "depaul Institution",
      cname: "sooraj s",
      events: "nache",
      paystatus: "Paid",
      status: 1,
      chestcode: "CHEST001",
      chestnumber: "10",
      cheststatus: 2,
    );

    return participantDetails;
  } catch (e) {
    Get.log('Error fetching EventId: $e');
    return null;
  }
}







static Future<bool> issueChestNumber(Participantdetails partdet) async {
  bool retVal = false;

  // Retrieve values from local storage or use sample defaults
  String? Candid = await LocalStorage.getValue('CandId') ?? "CAND123";
  String? StaffId = await LocalStorage.getValue('staff_id') ?? "STAFF001";
  String? category = await LocalStorage.getValue('category') ?? "CategoryA";
  String? eventid = await LocalStorage.getValue('event_id') ?? "EVENT2025";

  // Prepare credentials object (structure remains the same)
  final credentials = {
    'cand_id': Candid,
    'staff_id': StaffId,
    'category': category,
    'eventid': eventid,
    'chest_code': partdet.chestcode,
    'chest_no': partdet.chestnumber,
    'chest_status': partdet.cheststatus,
  };

  Get.log(credentials.toString());

  // Simulate network delay
  await Future.delayed(const Duration(seconds: 1));

  // Simulate server response
  final decoderesponse = {
    'message': "Chest number ${partdet.chestnumber} assigned successfully"
  };

  Get.log("Response: $decoderesponse");
  retVal = true;

  // Show snackbar with simulated message
  Get.snackbar("Successful", decoderesponse['message']!, colorText: Colors.white);

  return retVal;
}


static Future<dynamic> getplacementDetails(String chestno) async {
  bool retVal = false;
  final credentials = {
    'chestno' : chestno
  };
  final headers = {
    'Content-Type': 'application/json',
  };
  
  final body = json.encode(credentials);
  Get.log(credentials.toString());
  final response = await http.post(
    Uri.parse('https://dicoman.dist.ac.in/api/team'), 
    headers: headers,
    body: body,
  );
  final decoderesponse = jsonDecode(response.body);
  if(response.statusCode == 200)
  {
    Get.log("Response: ${response.body.toString()}");
    if(decoderesponse['member_status'] == 0 ){
      Get.snackbar('Unsuccessful', 'Invalid chest number', colorText: Colors.white);
      return retVal;
    } else {
      PlacementDetails placementDetails = PlacementDetails(
          instname: decoderesponse['inst_name'],
          members: decoderesponse['members']
        );
        return placementDetails;
    }
  }
  Get.snackbar("Error", "An error occured", colorText: Colors.white);
  return retVal;
}

static Future<bool> postplacement(String firstpo, String secondpo) async {
  bool retVal = false;
  String? eventid = await LocalStorage.getValue('event_id');
  final credentials = {
    'event_id': eventid,
    'prize': {
      '1': firstpo,
      '2': secondpo
    }
  };
  final headers = {
    'Content-Type': 'application/json',
  };
  
  final body = json.encode(credentials);
  Get.log(credentials.toString());
  final response = await http.post(
    Uri.parse('https://dicoman.dist.ac.in/api/prize'), 
    headers: headers,
    body: body,
  );
  Get.log(response.statusCode.toString());
  if(response.statusCode == 200)
  {
    final decoderesponse = jsonDecode(response.body);
    Get.log("Response: ${response.body.toString()}");
    if(decoderesponse['status'] == 0 ){
      Get.snackbar('Unsuccessful', decoderesponse['message'], colorText: Colors.white);
      return retVal;
    } else {
      Get.snackbar("Successful", decoderesponse['message'],colorText: Colors.white);
     return true;
    }
  }
  Get.snackbar("Error", "An error occured", colorText: Colors.white);
  return retVal;
}*/
