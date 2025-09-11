// models/candidate_details_model.dart

class Participantdetails {
  final String iname;
  final String cname;
  final String events;
  final int status;
  final String paystatus;
  final String chestcode;
  String chestnumber;
  final int cheststatus;

  Participantdetails({
    required this.iname,
    required this.cname,
    required this.events,
    required this.status,
    required this.paystatus,
    required this.chestcode,
    required this.chestnumber,
    required this.cheststatus,
  });
    
 factory Participantdetails.fromJson(Map<String, dynamic> json) {
    return Participantdetails(
      iname: json['iname'] ?? 'Unknown Institute',
      cname: json['cname'] ?? 'Unknown Candidate',
      events: json['events'] ?? 'No Event',
      status: json['status'] ?? 0,
      paystatus: json['pay_status'] ?? 'Unpaid',
      chestcode: json['chestcode'] ?? 'N/A',
      chestnumber: json['chestno'].toString() ?? '0', // Handle as string
      cheststatus: json['cheststatus'] ?? 0,
    );
  }
}
