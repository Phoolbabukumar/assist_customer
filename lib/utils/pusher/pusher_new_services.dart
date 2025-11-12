import 'dart:async';
import 'package:pusher_client/pusher_client.dart';

import '../common_functions.dart';


class PusherNewServices{
  var tag = "PusherNewServices";
  //Event lastEvent;
  dynamic lastConnectionState;
  Channel? channel;

  final StreamController<String> _eventData = StreamController<String>.broadcast();

  Sink get _inEventData => _eventData.sink;

  Stream get eventStream => _eventData.stream;

  PusherClient? pusher;

  Future<void> initPusher() async {
    try {
      printMessage(tag,"init try");
      pusher= PusherClient("cad2bf0c67bec60943b6", PusherOptions(cluster: "ap4"),
          enableLogging: true);
    } on Exception catch (e) {
      printMessage(tag,"init error $e");
    }
  }

  void connectPusher() {

    pusher!.connect();

    pusher!.onConnectionStateChange((state) {
      printMessage(tag,"previousState: ${state!.previousState}, currentState: ${state.currentState}");
    });

    pusher!.onConnectionError((error) {
      printMessage(tag,"error: ${error!.message}");
    });

  }

  Future<void> subscribePusher(String channelName) async {
    channel = pusher!.subscribe(channelName);
  }

  void unSubscribePusher(String channelName) {
    pusher!.unsubscribe(channelName);
  }

  void bindEvent(String eventName) {
    channel!.bind(eventName, (last) {
      try {
        final String? data = last!.data;
        _inEventData.add(data);
      } catch (e) {
        printMessage(tag,"bind..");
        printMessage(tag,e.toString());
      }
    });

  }


  void unbindEvent(String eventName) {
    channel!.unbind(eventName);
    _eventData.close();
  }




  Future<void> firePusher(String channelName, String eventName) async {
    await initPusher();
    connectPusher();
    await subscribePusher(channelName);
    bindEvent(eventName);
  }


  void clearData() {
    _inEventData.add('');
  }
}
