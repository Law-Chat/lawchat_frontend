import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';

import '../../theme/colors.dart';
import '../../ui/components/button.dart';
import '../../ui/components/input.dart';
import '../../ui/components/modal.dart';
import 'history_item.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../models/chat_history_models.dart';
import '../../services/chat_history_service.dart';
import '../../services/chat_service.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});
  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final _searchCtrl = TextEditingController();

  List<HistoryEntry> _all = [];

  String _query = '';
  DateTimeRange? _range;

  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();

    _searchCtrl.addListener(
      () => setState(() => _query = _searchCtrl.text.trim()),
    );

    _fetchHistories();
  }

  Future<void> _fetchHistories() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final result = await ChatHistoryService.instance.getHistories(
        startDate: _range?.start,
        endDate: _range?.end,
        keyword: _query.isEmpty ? null : _query,
      );
      if (!mounted) return;
      setState(() {
        _all = result;
        _isLoading = false;
      });
    } catch (e) {
      if (e.toString().contains('세션이 만료')) {
        context.go('/login');
        return;
      }

      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
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
      return _query.isEmpty || e.summary.contains(_query);
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
                    initialSelectedRange: _range != null
                        ? PickerDateRange(_range!.start, _range!.end)
                        : null,
                    initialDisplayDate: _range?.start,
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
      _fetchHistories();
    }
  }

  void _onSearch() {
    FocusScope.of(context).unfocus();
    _fetchHistories();
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
      onConfirm: () async {
        try {
          await ChatHistoryService.instance.deleteHistory(entry.chatId);

          if (!mounted) return;

          setState(() {
            _all.removeWhere((e) => e.chatId == entry.chatId);
          });

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('채팅 기록이 삭제되었습니다.')));
        } catch (e) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('삭제 중 오류가 발생했습니다.\n${e.toString()}'),
              backgroundColor: AppColors.error,
            ),
          );
        }
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
                    trailingIcon: LucideIcons.search,
                    onTrailingPressed: _onSearch,
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
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                  ? Center(
                      child: Text(
                        _error!,
                        style: const TextStyle(color: AppColors.error),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : grouped.isEmpty
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
                                chatId: entry.chatId,
                                title: entry.summary,
                                onTap: () async {
                                  try {
                                    final detail = await ChatService.instance
                                        .getChatDetail(entry.chatId);

                                    context.push('/chatting', extra: detail);
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('채팅 불러오기 실패: $e')),
                                    );
                                  }
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
