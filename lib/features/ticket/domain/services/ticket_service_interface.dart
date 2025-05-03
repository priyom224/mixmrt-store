import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart_store/features/ticket/domain/models/ticket_category_model.dart';
import 'package:sixam_mart_store/features/ticket/domain/models/ticket_details_model.dart';
import 'package:sixam_mart_store/features/ticket/domain/models/ticket_list_model.dart';

abstract class TicketServiceInterface {
  Future<List<Category>?> getTicketCategory();
  Future<bool> createTicket(Map<String, String> data, XFile? image);
  Future<List<Ticket>?> getTicketList(String userType);
  Future<TicketDetailsModel?> getTicketDetails(int? id);
}