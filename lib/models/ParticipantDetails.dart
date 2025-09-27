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
      iname: "depaul" ?? 'Unknown Institute',
      cname: "sooraj s" ?? 'Unknown Candidate',
      events: "nache" ?? 'No Event',
      status: 1 ?? 0,
      paystatus: "Paid" ?? 'unPaid',
      chestcode: "assigned" ?? 'N/A',
      chestnumber: json['chestno'].toString() ?? '0', // Handle as string
      cheststatus: json['cheststatus'] ?? 0,
    );
  }
}
