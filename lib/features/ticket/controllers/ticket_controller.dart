import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/features/ticket/domain/models/ticket_category_model.dart';
import 'package:sixam_mart_store/features/ticket/domain/models/ticket_details_model.dart';
import 'package:sixam_mart_store/features/ticket/domain/models/ticket_list_model.dart';
import 'package:sixam_mart_store/features/ticket/domain/services/ticket_service_interface.dart';

class TicketController extends GetxController implements GetxService {
  final TicketServiceInterface ticketServiceInterface;
  TicketController({required this.ticketServiceInterface});

  List<Category>? _ticketCategoryList;
  List<Category>? get ticketCategoryList => _ticketCategoryList;

  int? _selectedCategoryId;
  int? get selectedCategoryId => _selectedCategoryId;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  XFile? _pickedFile;
  XFile? get pickedFile => _pickedFile;

  List<Ticket>? _ticketList;
  List<Ticket>? get ticketList => _ticketList;

  TicketDetailsModel? _ticketDetailsModel;
  TicketDetailsModel? get ticketDetailsModel => _ticketDetailsModel;

  Future<void> getTicketCategory() async {
    List<Category>? ticketCategory = await ticketServiceInterface.getTicketCategory();
    if(ticketCategory != null) {
      _ticketCategoryList = [];
      _ticketCategoryList = ticketCategory;
    }
    update();
  }

  void setSelectedCategoryId(int index) {
    _selectedCategoryId = index;
    update();
  }

  Future<void> createTicket(Map<String, String> data) async {
    _isLoading = true;
    update();

    bool isSuccess = await ticketServiceInterface.createTicket(data, _pickedFile);
    if(isSuccess) {
      getTicketList('vendor');
      Get.back();
      showCustomSnackBar('Your ticket has been created successfully', isError: false);
    } else {
      showCustomSnackBar('Failed to create ticket');
    }

    _isLoading = false;
    update();
  }


  void pickImage() async {
    _pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    update();
  }

  void initData() {
    _pickedFile = null;
  }

  Future<void> getTicketList(String userType) async {
    List<Ticket>? ticketList = await ticketServiceInterface.getTicketList(userType);
    if(ticketList != null) {
      _ticketList = [];
      _ticketList = ticketList;
    }
    update();
  }

  Future<void> getTicketDetails(int? id) async {
    TicketDetailsModel? ticketDetailsModel = await ticketServiceInterface.getTicketDetails(id);
    if(ticketDetailsModel != null) {
      _ticketDetailsModel = ticketDetailsModel;
    }
    update();
  }

}