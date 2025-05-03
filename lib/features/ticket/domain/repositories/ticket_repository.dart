import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart_store/api/api_client.dart';
import 'package:sixam_mart_store/features/ticket/domain/models/ticket_category_model.dart';
import 'package:sixam_mart_store/features/ticket/domain/models/ticket_details_model.dart';
import 'package:sixam_mart_store/features/ticket/domain/models/ticket_list_model.dart';
import 'package:sixam_mart_store/features/ticket/domain/repositories/ticket_repository_interface.dart';
import 'package:sixam_mart_store/util/app_constants.dart';

class TicketRepository implements TicketRepositoryInterface {
  final ApiClient apiClient;
  TicketRepository({required this.apiClient});

  @override
  Future<List<Category>?> getTicketCategory() async{
    List<Category>? ticketCategory;

    Response response = await apiClient.getData(AppConstants.ticketCategoryUri);
    if(response.statusCode == 200) {
      ticketCategory = [];
      response.body['data'].forEach((category) => ticketCategory?.add(Category.fromJson(category)));
    }
    return ticketCategory;
  }

  @override
  Future<bool> createTicket(Map<String, String> data, XFile? image) async{
    Response response = await apiClient.postMultipartData(AppConstants.ticketUri, data, [MultipartBody('files[]', image)], handleError: false);
    return response.statusCode == 200;
  }

  @override
  Future<List<Ticket>?> getTicketList(String userType) async{
    List<Ticket>? ticketList;

    Response response = await apiClient.getData('${AppConstants.ticketUri}?user_type=$userType');
    if(response.statusCode == 200) {
      ticketList = [];
      response.body['tickets']['data'].forEach((ticket) => ticketList?.add(Ticket.fromJson(ticket)));
    }
    return ticketList;
  }

  @override
  Future<TicketDetailsModel?> getTicketDetails(int? id) async {
    TicketDetailsModel? ticketDetailsModel;
    Response response = await apiClient.getData('${AppConstants.ticketUri}/$id');
    if(response.statusCode == 200) {
      ticketDetailsModel = TicketDetailsModel.fromJson(response.body);
    }
    return ticketDetailsModel;
  }

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future delete(int? id) {
    throw UnimplementedError();
  }

  @override
  Future get(int? id) {
    throw UnimplementedError();
  }

  @override
  Future getList() {
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body) {
    throw UnimplementedError();
  }

}