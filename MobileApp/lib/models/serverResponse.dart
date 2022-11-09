class ServerResponse {
  int? count;
  String? message;
  dynamic searchCriteria;
  dynamic results;

  ServerResponse({this.count, this.message, this.searchCriteria, this.results});

  ServerResponse.fromJson(Map<String, dynamic> json) {
    count = json['Count'];
    message = json['Message'];
    searchCriteria = json['SearchCriteria'];
    if (json['Results'] != null) {
      results = [];
      json['Results'].forEach((v) {
        results!.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Count'] = this.count;
    data['Message'] = this.message;
    data['SearchCriteria'] = this.searchCriteria;
    if (this.results != null) {
      data['Results'] = this.results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

