import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dignito/services/local_storage_service.dart';
import '../models/CandDetails.dart';
import 'package:get/get.dart';
import '../models/ParticipantDetails.dart';
import '../models/placement_model.dart';

class HttpServices {
  static String baseUrl = 'http://dicoman.dist.ac.in/api/';

  static void _clearResponse(Map<String, dynamic> response) {
  // Clear the map to free up memory
  response.clear();
}
    
  static Future<bool> login(String username, String password, int usertype) async {
  bool retVal = false;
  final credentials = {
    'username': username,
    'password': password,
    'usertype' : usertype
  };
  Get.log(credentials.toString());
  final headers = {
    'Content-Type': 'application/json',
  };

  final body = json.encode(credentials);

  final response = await http.post(
    Uri.parse('https://dicoman.dist.ac.in/api/login'),
    headers: headers,
    body: body,
  );
  Get.log(response.body);
  if (response.statusCode == 200) {
    
    final Map<String, dynamic> responseData = json.decode(response.body);
    if (responseData['status'] == 1){
      print(responseData);
      retVal = true;
      String staffid = responseData['staff_id'].toString();
      String category = responseData['category'].toString();
      String eventid = responseData['eventid'].toString();
      Get.log(eventid);
      await LocalStorage.setValue('staff_id', staffid);
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
    'staff_id':StaffId,
    'category': category,
    'eventid': event
    };

    Get.log(credentials.toString());


    final headers = {
      'Content-Type': 'application/json',
    };
    
    final body = json.encode(credentials);

    final response = await http.post(
      Uri.parse('https://dicoman.dist.ac.in/api/candidate'), //change uri
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
  'staff_id':StaffId,
  'category': category,
  'eventid': eventid
  };

  final headers = {
    'Content-Type': 'application/json',
  };
  Get.log(credentials.toString());
  final body = json.encode(credentials);

  final response = await http.post(
    Uri.parse('https://dicoman.dist.ac.in/api/update'),
    headers: headers,
    body: body,
  );
  Get.log(response.statusCode.toString());
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
      'staff_id': StaffId,
      'category': category,
      'eventid': eventid,
    };

    final headers = {'Content-Type': 'application/json'};
    final body = json.encode(credentials);

    Get.log('Request Body: $body'); // Log request

    // Send POST request
    final response = await http.post(
      Uri.parse('https://dicoman.dist.ac.in/api/candidate'),
      headers: headers,
      body: body,
    );

    // Log response details
    Get.log("Response Status: ${response.statusCode}");
    Get.log("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);

      // Parse the response into Participantdetails model
      try {
        Participantdetails participantDetails = 
            Participantdetails.fromJson(decodedResponse);
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
  'staff_id': StaffId,
  'category': category,
  'eventid': eventid,
  'chest_code': partdet.chestcode,
  'chest_no': partdet.chestnumber,
  'chest_status': partdet.cheststatus,
  };

  Get.log(credentials.toString());

  final headers = {
    'Content-Type': 'application/json',
  };
  
  final body = json.encode(credentials);

  final response = await http.post(
    Uri.parse('https://dicoman.dist.ac.in/api/update'), 
    headers: headers,
    body: body,
  );
  print(response.body);
  final decoderesponse = jsonDecode(response.body);
  if(response.statusCode == 200)
  {
    print("updated");
    Get.log("Response: ${response.body.toString()}");
    retVal = true;
    Get.log(decoderesponse['message']);
    Get.snackbar("Successful", decoderesponse['message'], colorText: Colors.white); 
  }
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
}


}

