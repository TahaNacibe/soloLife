
import 'package:SoloLife/app/data/models/profile.dart';
import 'package:SoloLife/app/data/models/shop_data.dart';
import 'package:SoloLife/app/data/models/state.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:SoloLife/app/core/utils/Keys.dart';

class StorageService extends GetxService {
  // var for fast refer
  late GetStorage _box;
  //? initialize the get storage service in the start of the app
  Future<StorageService> init() async {
    // the default values
    // profile
    Map<String,dynamic> profile = Profile(userName: "■ ■ ■ ■",level:1,exp:0,keys:[]).toJson();
    // shop data
    Map<String,dynamic> shop = shopData().toJson();
    // states
    Map<String,dynamic> states = UserState().toJson();
    String formattedStates = '{' + states.entries.map((e) => '"${e.key}": ${e.value}').join(', ') + '}';
    // var get value here (o_o!)
    _box = GetStorage();
    await _box.writeIfNull('logKey', false);
    //? init the task key storage
    await _box.writeIfNull(taskKey, []);
    //? init the userInfo key storage
     //? init the dailies key storage
    await _box.writeIfNull(dailyKey, []);
         //? init the state key storage
    await _box.writeIfNull(statesKey,formattedStates);
    //? init the profile key storage
    await _box.writeIfNull(profileKey,profile);
    //? init the shop key storage
    await _box.writeIfNull(shopKey,shop);
    return this;
  }


  //? read the data of the storage by the key
  T read<T>(String key) {
    return _box.read(key);
  }

  //? write the data on the storage by the key
  void write(String key, dynamic value) async {
    await _box.write(key, value);
  }

  //? check the existing of the storage
  bool check(String key){
    return _box.hasData(key);
  }
}

