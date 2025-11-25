import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../theme/colors.dart';
import '../../ui/components/button.dart';
import '../../ui/components/input.dart';
import '../../ui/components/modal.dart';
import 'history_item.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../models/chat_models.dart';
import 'package:go_router/go_router.dart';

class HistoryEntry {
  HistoryEntry(this.title, this.createdAt);
  final String title;
  final DateTime createdAt;
}

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});
  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final _searchCtrl = TextEditingController();
  final List<HistoryEntry> _all = [
    HistoryEntry(
      '대부업 최고 이자율 문의',
      DateTime.now().subtract(const Duration(hours: 1)),
    ),
    HistoryEntry(
      '최근 개정된 금융소비자보호법 요약',
      DateTime.now().subtract(const Duration(hours: 3)),
    ),
    HistoryEntry(
      '대출 연체 시 법적 절차',
      DateTime.now().subtract(const Duration(hours: 5)),
    ),
    HistoryEntry(
      '투자 손실 발생 시 구제 가능 여부',
      DateTime.now().subtract(const Duration(days: 1, hours: 2)),
    ),
    HistoryEntry(
      '불법 사금융 신고 방법 안내',
      DateTime.now().subtract(const Duration(days: 1, hours: 4)),
    ),
    HistoryEntry(
      '예금자보호법 적용 한도',
      DateTime.now().subtract(const Duration(days: 1, hours: 7)),
    ),
    HistoryEntry(
      '금융감독원 민원 절차',
      DateTime.now().subtract(const Duration(days: 3)),
    ),
    HistoryEntry(
      '자주 묻는 금융 규정 TOP 5',
      DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  String _query = '';
  DateTimeRange? _range;

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(
      () => setState(() => _query = _searchCtrl.text.trim()),
    );
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  LinkedHashMap<String, List<HistoryEntry>> _group(List<HistoryEntry> list) {
    final now = DateTime.now();
    bool sameDay(DateTime a, DateTime b) =>
        a.year == b.year && a.month == b.month && a.day == b.day;

    final map = LinkedHashMap<String, List<HistoryEntry>>();
    final today = list.where((e) => sameDay(e.createdAt, now)).toList();
    final yesterday = list
        .where(
          (e) => sameDay(e.createdAt, now.subtract(const Duration(days: 1))),
        )
        .toList();
    final rest =
        list
            .where(
              (e) =>
                  !sameDay(e.createdAt, now) &&
                  !sameDay(e.createdAt, now.subtract(const Duration(days: 1))),
            )
            .toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    if (today.isNotEmpty) map['오늘'] = today;
    if (yesterday.isNotEmpty) map['어제'] = yesterday;
    for (final e in rest) {
      final key =
          '${e.createdAt.year}.${e.createdAt.month.toString().padLeft(2, '0')}.${e.createdAt.day.toString().padLeft(2, '0')}';
      (map[key] ??= []).add(e);
    }
    return map;
  }

  List<HistoryEntry> get _filtered {
    return _all.where((e) {
      final matchText = _query.isEmpty || e.title.contains(_query);
      final matchDate = _range == null
          ? true
          : (e.createdAt.isAfter(
                  _range!.start.subtract(const Duration(seconds: 1)),
                ) &&
                e.createdAt.isBefore(
                  _range!.end.add(const Duration(seconds: 1)),
                ));
      return matchText && matchDate;
    }).toList();
  }

  void _openFilter() async {
    DateTimeRange? pickedRange;

    await showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '검색 기간 선택',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 320,
                  child: SfDateRangePicker(
                    backgroundColor: AppColors.white,
                    selectionMode: DateRangePickerSelectionMode.range,
                    showActionButtons: true,
                    confirmText: '적용',
                    cancelText: '취소',

                    rangeSelectionColor: AppColors.primary.withOpacity(0.1),
                    startRangeSelectionColor: AppColors.primary,
                    endRangeSelectionColor: AppColors.primary,
                    todayHighlightColor: AppColors.primary,
                    selectionTextStyle: const TextStyle(color: Colors.white),

                    headerStyle: const DateRangePickerHeaderStyle(
                      backgroundColor: AppColors.white,
                      textAlign: TextAlign.center,
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: AppColors.secondary,
                      ),
                    ),

                    monthViewSettings: const DateRangePickerMonthViewSettings(
                      firstDayOfWeek: 1,
                      dayFormat: 'EE',
                      viewHeaderStyle: DateRangePickerViewHeaderStyle(
                        backgroundColor: AppColors.white,
                        textStyle: TextStyle(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    monthCellStyle: const DateRangePickerMonthCellStyle(
                      textStyle: TextStyle(color: AppColors.secondary),
                      todayTextStyle: TextStyle(color: AppColors.primary),
                    ),

                    onSubmit: (Object? val) {
                      if (val is PickerDateRange) {
                        pickedRange = DateTimeRange(
                          start: val.startDate!,
                          end: val.endDate ?? val.startDate!,
                        );
                      }
                      Navigator.of(ctx).pop();
                    },
                    onCancel: () => Navigator.of(ctx).pop(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (pickedRange != null) {
      setState(() => _range = pickedRange);
    }
  }

  void _confirmDelete(HistoryEntry entry) {
    AppModal.show(
      context: context,
      title: '삭제 확인',
      isConfirmModal: true,
      message: '이 채팅 기록을 삭제하시겠습니까?\n삭제 후에는 복구할 수 없습니다.',
      confirmLabel: '삭제',
      cancelLabel: '취소',
      confirmColor: AppColors.primary,
      onConfirm: () {
        setState(() => _all.remove(entry));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _group(_filtered);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text(
          '채팅 기록',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 16,
            color: AppColors.secondary,
          ),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: AppColors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: AppInput(
                    variant: AppInputVariant.search,
                    controller: _searchCtrl,
                    hintText: '검색어를 입력하세요.',
                  ),
                ),
                const SizedBox(width: 10),
                AppButton(
                  variant: AppButtonVariant.squareIcon,
                  icon: LucideIcons.slidersHorizontal,
                  bgColor: AppColors.primary,
                  iconColor: Colors.white,
                  onPressed: _openFilter,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: grouped.isEmpty
                  ? const Center(
                      child: Text(
                        '검색 결과가 없습니다.',
                        style: TextStyle(color: AppColors.quaternary),
                      ),
                    )
                  : ListView(
                      children: grouped.entries.map((section) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              section.key,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: AppColors.secondary,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ...section.value.map(
                              (entry) => HistoryItem(
                                title: entry.title,
                                onTap: () {
                                  final thread = ChatThread.mock(entry.title);
                                  context.push('/chatting', extra: thread);
                                },
                                onDelete: () => _confirmDelete(entry),
                              ),
                            ),
                            const SizedBox(height: 14),
                          ],
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
