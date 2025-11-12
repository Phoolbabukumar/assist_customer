import 'package:assist/Controllers/vehicle_update_controller.dart';
import 'package:get/get.dart';

class VehicleEditController extends GetxController {
  VehicleUpdateController? edit;
  @override
  void onInit() {
    super.onInit();
    edit = Get.put(VehicleUpdateController());
  }

/* For accessive use of one controller this controller I made to use vehicleUpdateControlelr features and made easy according to future */
  modelGetMethod() {
    edit!.vehicleModelList(edit!.makeId.toString()).then(
      (value) {
        edit!.modelItems = [];
        for (var item in edit!.modelList) {
          if (item.type == edit!.vehicleListResponse?.vehicleType) {
            edit!.modelItems.add(item.modelName ?? "");
          }
        }
        update();
      },
    );
  }
}
