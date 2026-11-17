import 'package:anpi_report_flutter/entity/topictype.dart';
import 'package:flutter_test/flutter_test.dart';

// Districts the earthquake server (wsocket/main.go prefectureToDistrict) sends to.
const earthquakeDistricts = {
  'notice_hokkaido', 'notice_tohoku', 'notice_kitakanto', 'notice_tokyo',
  'notice_hokuriku', 'notice_koshinetsu', 'notice_nagoya', 'notice_osaka',
  'notice_chugoku', 'notice_okayama', 'notice_hiroshima', 'notice_shikoku',
  'notice_kyushu',
};

void main() {
  test('every earthquake district can be selected', () {
    final selectable = selectableRegionTopics.map((t) => t.topic).toSet();
    expect(selectable, containsAll(earthquakeDistricts));
  });

  test('bitmask values are unique single bits', () {
    final bits = TopicType.values
        .where((t) => t != TopicType.undefined)
        .map((t) => t.bitMaskNum)
        .toList();
    expect(bits.toSet().length, bits.length);
    for (final b in bits) {
      expect(b & (b - 1), 0, reason: '$b is not a single bit');
    }
  });

  test('new regions avoid bits reserved by older data', () {
    final used = TopicType.values.map((t) => t.bitMaskNum).toSet();
    expect(used.contains(128), isFalse);
    expect(used.contains(512), isFalse);
  });

  test('calcSubscriptionBitmask recognises new regions', () {
    expect(calcSubscriptionBitmask('notice_hokkaido', 1024 | 2), isTrue);
    expect(calcSubscriptionBitmask('notice_shikoku', 1024), isFalse);
  });
}
