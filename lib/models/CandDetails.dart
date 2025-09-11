// models/candidate_details_model.dart

class CandidateDetails {
  final String iname;
  final String cname;
  final String events;
  final String pay_status;
  final int status;

  CandidateDetails({
    required this.iname,
    required this.cname,
    required this.events,
    required this.pay_status,
    required this.status,
  });
    
  Map<String, dynamic> toJson() {
    return {
      'iname': iname,
      'cname': cname,
      'events': events,
      'pay_status': pay_status,
      'status': status,
    };
  }
} 
