import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class SlotTime {
  String slot;
  int seats;

  SlotTime({
    @required this.slot,
    @required this.seats,
  });
}

class SlotTimes {
  List<SlotTime> slots;
  SlotTimes({
    @required this.slots,
  });

  static SlotTimes fromDocToSlotTimes(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    if (doc.data() == {})
      return SlotTimes(slots: []);
    else {
      DateTime now = DateTime.now();

      List<SlotTime> slots = doc
          .data()
          .entries
          .map((entry) => SlotTime(
              slot: entry.key,
              seats: (entry.key.length < 11 ||
                      int.tryParse(entry.value.toString()) == null)
                  ? -100.toInt()
                  : int.parse(entry.value.toString())))
          .toList();

      slots.removeWhere((SlotTime slot) => slot.seats <= 0.toInt());

      List<SlotTime> removeSlots = [];
      slots.forEach((SlotTime slotTime) {
        String endTime = slotTime.slot.substring(6, 11);

        bool remove = false;

        remove = (!remove)
            ? (int.tryParse(slotTime.slot.substring(0, 2)) == null)
            : true;

        remove = (!remove)
            ? (int.tryParse(endTime.substring(endTime.length - 2)) == null)
            : true;
        remove =
            (!remove) ? (int.tryParse(endTime.substring(0, 2)) == null) : true;

        if (!remove) {
          int minute = int.parse(endTime.substring(endTime.length - 2));

          int hour = int.parse(endTime.substring(0, 2));

          DateTime slotEndTime =
              DateTime(now.year, now.month, now.day, hour, minute);

          if (now.isAfter(slotEndTime)) {
            removeSlots.add(slotTime);
          }
        } else {
          removeSlots.add(slotTime);
        }
      });
      removeSlots.forEach((SlotTime removeSlot) {
        slots.remove(removeSlot);
      });
      slots.sort((SlotTime a, SlotTime b) => int.parse(a.slot.substring(0, 2))
          .compareTo(int.parse(b.slot.substring(0, 2))));
      return SlotTimes(slots: slots ?? []);
    }
  }
}
