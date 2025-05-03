import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart_store/features/ticket/domain/models/ticket_category_model.dart';
import 'package:sixam_mart_store/features/ticket/domain/models/ticket_details_model.dart';
import 'package:sixam_mart_store/features/ticket/domain/models/ticket_list_model.dart';
import 'package:sixam_mart_store/features/ticket/domain/repositories/ticket_repository_interface.dart';
import 'package:sixam_mart_store/features/ticket/domain/services/ticket_service_interface.dart';

class TicketService implements TicketServiceInterface{
  final TicketRepositoryInterface ticketRepositoryInterface;
  TicketService({required this.ticketRepositoryInterface});

  @override
  Future<List<Category>?> getTicketCategory() async{
    return await ticketRepositoryInterface.getTicketCategory();
  }

  @override
  Future<bool> createTicket(Map<String, String> data, XFile? image) async{
    return await ticketRepositoryInterface.createTicket(data, image);
  }

  @override
  Future<List<Ticket>?> getTicketList(String userType) async{
    return await ticketRepositoryInterface.getTicketList(userType);
  }

  @override
  Future<TicketDetailsModel?> getTicketDetails(int? id) async{
    return await ticketRepositoryInterface.getTicketDetails(id);
  }

}