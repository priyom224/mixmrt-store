class TicketDetailsModel {
  int? id;
  int? ticketSystemCategoryId;
  String? reqFrom;
  int? foreignId;
  int? ticketSystemId;
  int? assignedAdminId;
  String? subject;
  String? message;
  String? status;
  String? isSeen;
  String? isSolved;
  String? isApprovedBy;
  String? adminResponseMsg;
  String? createdAt;
  String? updatedAt;
  List<String>? filesUrl;

  TicketDetailsModel({
    this.id,
    this.ticketSystemCategoryId,
    this.reqFrom,
    this.foreignId,
    this.ticketSystemId,
    this.assignedAdminId,
    this.subject,
    this.message,
    this.status,
    this.isSeen,
    this.isSolved,
    this.isApprovedBy,
    this.adminResponseMsg,
    this.createdAt,
    this.updatedAt,
    this.filesUrl,
  });

  TicketDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ticketSystemCategoryId = json['ticket_system_category_id'];
    reqFrom = json['req_from'];
    foreignId = json['foreign_id'];
    ticketSystemId = json['ticket_system_id'];
    assignedAdminId = json['assigned_admin_id'];
    subject = json['subject'];
    message = json['message'];
    status = json['status'];
    isSeen = json['is_seen'];
    isSolved = json['is_solved'];
    isApprovedBy = json['is_approved_by'];
    adminResponseMsg = json['admin_response_msg'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['files_url'] != null) {
      filesUrl = <String>[];
      json['files_url'].forEach((v) {
        if (v != null) {
          filesUrl!.add(v);
        }
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['ticket_system_category_id'] = ticketSystemCategoryId;
    data['req_from'] = reqFrom;
    data['foreign_id'] = foreignId;
    data['ticket_system_id'] = ticketSystemId;
    data['assigned_admin_id'] = assignedAdminId;
    data['subject'] = subject;
    data['message'] = message;
    data['status'] = status;
    data['is_seen'] = isSeen;
    data['is_solved'] = isSolved;
    data['is_approved_by'] = isApprovedBy;
    data['admin_response_msg'] = adminResponseMsg;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (filesUrl != null) {
      data['files_url'] = filesUrl!.map((v) => v).toList();
    }
    return data;
  }
}
