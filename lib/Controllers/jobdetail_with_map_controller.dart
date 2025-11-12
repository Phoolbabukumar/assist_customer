import 'package:assist/Controllers/global_controller.dart';
import 'package:assist/Controllers/jobs_datalist_controller.dart';
import 'package:assist/Controllers/rating_controller.dart';
import 'package:assist/Controllers/theme_controller.dart';
import 'package:assist/apis/response/job_data_response.dart';
import 'package:assist/app_constants/app_images_path.dart';
import 'package:assist/utils/Widgets/widgets_file.dart';
import 'package:assist/utils/common_functions.dart';
import 'package:assist/utils/custom_widgets.dart';
import 'package:assist/utils/pusher/pusher_new_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/* Made for showing JobBookingListDetails */
class JobDetailsWithMapController extends GetxController {
  final global = Get.find<GlobalController>();
  final ratingController = Get.put(RatingController());

  final jobsDataListController = Get.find<JobsDataListController>();
  final themeController = Get.find<ThemeController>();

  PusherNewServices pusherService = PusherNewServices();

  GoogleMapController? _googleMapController;

  final box = GetStorage();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final isloading = true.obs;

  // List<Marker> markers = [];
  final Set<Marker> markers = {};
  final lat = 0.0.obs;
  final lng = 0.0.obs;
  var feedBackURL = "https://g.page/r/CckdoTfQECflEAg/review";
  bool isFeedbackBox = false;
  bool firstStar = false;
  bool secondStar = false;
  bool thirdStar = false;
  bool fourthStar = false;
  bool fifthStar = false;
  String? jobId;
  final Set<Polyline> _polylines = {};

  List<LatLng> polylineCoordinates = [];

  PolylinePoints polylinePoints = PolylinePoints();

  //Timer timer;
  int rating = 0;

  @override
  void onInit() {
    super.onInit();
    jobId = Get.arguments["jobId"];
    pusherService
        .firePusher('my-channel', 'job-update-event')
        .then((value) => callApi(true));
  }

  @override
  void onClose() {
    super.onClose();
    pusherService.unbindEvent('job-update-event');
  }

  callApi(bool isLoading) {
    if (isLoading) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        debugPrint("this schedular is called 111");
        const CustomWidgets().widgetLoadingData();
      });
    }

    jobsDataListController.getJobDataFuture =
        jobsDataListController.getJobData2(jobId).then((value) {
      isloading.value = false;
      if (isLoading) {
        SchedulerBinding.instance.addPostFrameCallback(
            (_) => Future.delayed(const Duration(seconds: 1), () {
                  debugPrint("this schedular is called and loader closed 111");
                  Get.back();
                }));
      }

      if (jobsDataListController.getJobsByJobIdResponse.omJobsView?[0].status ==
          "Completed") {
        if (jobsDataListController
                .getJobsByJobIdResponse.omJobsView?[0].sendFeedbackEmail ==
            "Yes") {
          isFeedbackBox = true;
        }
      }
      setMapPins();
      update();
    });
  }

  buildMap() {
    return GoogleMap(
      onMapCreated: (GoogleMapController controller) {
        _googleMapController = controller;
        update();
      },
      initialCameraPosition:
          CameraPosition(target: LatLng(lat.value, lng.value), zoom: 14.0),
      markers: Set.from(markers),
      polylines: _polylines,
      myLocationEnabled: false,
    );
  }

/* This method used to set the pin on a perticular lat, lng where the job raised */
  void setMapPins() async {
    debugPrint(
        'lat${jobsDataListController.getJobsByJobIdResponse.omJobsView?[0].customerLatitude}');
    debugPrint(
        'lng${jobsDataListController.getJobsByJobIdResponse.omJobsView?[0].customerLongitude}');
    try {
      lat.value = jobsDataListController
                  .getJobsByJobIdResponse.omJobsView?[0].customerLatitude !=
              null
          ? double.parse(jobsDataListController
              .getJobsByJobIdResponse.omJobsView![0].customerLatitude
              .toString())
          : 0;
      lng.value = jobsDataListController
                  .getJobsByJobIdResponse.omJobsView?[0].customerLongitude !=
              null
          ? double.parse(jobsDataListController
              .getJobsByJobIdResponse.omJobsView![0].customerLongitude
              .toString())
          : 0;
      markers.add(Marker(
          markerId: const MarkerId("curr_loc"),
          position: LatLng(lat.value, lng.value),
          infoWindow: InfoWindow(
            title: jobsDataListController
                    .getJobsByJobIdResponse.omJobsView?[0].vehicleDetail ??
                "NA",
          ),
          icon: await getBitmapDescriptorFromAssetBytes(markerIconone, 80)));
      moveCamera(lat.value, lng.value);
      update();
    } catch (e) {
      printMessage(tag, "Error : ${e.toString()}");
    }
  }

  void moveCamera(double lat, double lng) {
    printMessage(tag, "Moving camera");
    _googleMapController?.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(lat, lng), zoom: 14.0),
    ));
    update();
  }

/* this method can show the rating dialog */
  void callApi2() {
    jobsDataListController.getJobDataFuture =
        jobsDataListController.getJobData2(jobId).then((value) {
      if (jobsDataListController.getJobsByJobIdResponse.omJobsView?[0].status ==
          "Completed") {
        if (jobsDataListController
                .getJobsByJobIdResponse.omJobsView?[0].sendFeedbackEmail ==
            "Yes") {
          isFeedbackBox = true;
        }
        showRatingBox(
            responsebody:
                jobsDataListController.getJobsByJobIdResponse.omJobsView?[0] ??
                    JobDataResponse(),
            isFeedbackBox: isFeedbackBox,
            fBUrl: feedBackURL,
            jobdetailMapController: JobDetailsWithMapController());
      }
      //jobsDataListController.jobDataResponseList =value;
      isloading.value = false;
      setMapPins();
    });
  }
}
