import 'dart:convert';
import 'package:assist/Controllers/global_controller.dart';
import 'package:assist/apis/base_client.dart';
import 'package:get/get.dart';
import '../utils/common_functions.dart';

class MyTransactionsController extends GetxController {
  var tag = "MyTransactionsController";

  final global = Get.find<GlobalController>();
  final isLoading = false.obs;

  final transactionsList = [].obs;

  @override
  void onInit() async {
    super.onInit();
    isLoading.value = true;
    await getTransactionList();
  }

/* Get the use Transaction List from Api */
  Future<void> getTransactionList() async {
    try {
      final response = await BaseClient.get(
          "Phone=${global.customerPhoneNumber.toString()}",
          "GetCustomerTransactions");

      var decodedResponse = json.decode(response);
      transactionsList.clear();
      if (decodedResponse["StatusCode"] != 404) {
        transactionsList.value = decodedResponse["Transactions"];
        printMessage(tag, "List response : ${transactionsList.length}");
        isLoading.value = false;
      } else {
        isLoading.value = false;
      }
    } catch (e, stacktrace) {
      printMessage(tag, e);
      printMessage(tag, stacktrace);
    }
  }
}
