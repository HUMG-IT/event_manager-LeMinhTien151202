import 'package:event_manager/event/event_model.dart';
import 'package:localstore/localstore.dart';

class EventService {
  final db = Localstore.getInstance(useSupportDir: true);

  //tên collection trong localstore giống vs tên bảng
  final path = 'events';

  //hàm llấy ds sự kiện localstore
  Future<List<EventModel>> getAllEvents() async{
    final eventsMap = await db.collection(path).get();

    if (eventsMap != null) {
      return eventsMap.entries.map((entry){
        final eventData = entry.value as Map<String, dynamic>;
        if(!eventData.containsKey('id')){
          eventData['id'] = entry.key.split('/').last;
        }
        return EventModel.fromMap(eventData);
      }).toList();
    }
    return [];
  }

  //hàm lưu trữ 1 sư kiện vào localstore
  Future<void> saveEvent(EventModel item) async{
    //nêu id ko tồn tại tạo ms và lấy 1 id ngẫu nhiên
    item.id ??= db.collection(path).doc().id;
    await db.collection(path).doc(item.id).set(item.toMap());
  }

  //hàm xóa 1 sự kiện từ localstore
  Future<void> deleteEvent(EventModel item) async{
    await db.collection(path).doc(item.id).delete();
  }
}