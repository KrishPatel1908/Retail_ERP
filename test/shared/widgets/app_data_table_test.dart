import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:retail_erp/shared/widgets/app_data_table.dart';

class SampleItem {
  SampleItem({required this.id, required this.name, required this.value});
  final int id;
  final String name;
  final int value;
}

void main() {
  final testItems = [
    SampleItem(id: 1, name: 'Alpha', value: 100),
    SampleItem(id: 2, name: 'Beta', value: 200),
    SampleItem(id: 3, name: 'Gamma', value: 300),
  ];

  final testColumns = [
    AppDataTableColumn<SampleItem>(
      label: 'ID',
      width: 60,
      cellBuilder: (context, item) => Text('${item.id}'),
    ),
    AppDataTableColumn<SampleItem>(
      label: 'Name',
      flex: 2,
      sortable: true,
      cellBuilder: (context, item) => Text(item.name),
    ),
    AppDataTableColumn<SampleItem>(
      label: 'Value',
      flex: 1,
      numeric: true,
      cellBuilder: (context, item) => Text('${item.value}'),
    ),
  ];

  Widget buildTestTable({
    List<SampleItem>? items,
    bool selectable = false,
    Set<SampleItem> selectedItems = const {},
    ValueChanged<Set<SampleItem>>? onSelectionChanged,
    int? sortColumnIndex,
    bool sortAscending = true,
    void Function(int, bool)? onSort,
    bool isLoading = false,
    Object? error,
    bool showPagination = false,
    int page = 1,
    int pageSize = 10,
    ValueChanged<int>? onPageChanged,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: AppDataTable<SampleItem>(
          items: items ?? testItems,
          columns: testColumns,
          keyExtractor: (item) => item.id,
          selectable: selectable,
          selectedItems: selectedItems,
          onSelectionChanged: onSelectionChanged,
          sortColumnIndex: sortColumnIndex,
          sortAscending: sortAscending,
          onSort: onSort,
          isLoading: isLoading,
          error: error,
          showPagination: showPagination,
          page: page,
          pageSize: pageSize,
          onPageChanged: onPageChanged,
        ),
      ),
    );
  }

  testWidgets('renders items and column headers correctly', (tester) async {
    await tester.pumpWidget(buildTestTable());

    expect(find.text('ID'), findsOneWidget);
    expect(find.text('Name'), findsOneWidget);
    expect(find.text('Value'), findsOneWidget);

    expect(find.text('Alpha'), findsOneWidget);
    expect(find.text('Beta'), findsOneWidget);
    expect(find.text('Gamma'), findsOneWidget);
  });

  testWidgets('triggers column sorting callback when header is tapped', (
    tester,
  ) async {
    int? sortedCol;
    bool? sortedAsc;

    await tester.pumpWidget(
      buildTestTable(
        onSort: (colIndex, asc) {
          sortedCol = colIndex;
          sortedAsc = asc;
        },
      ),
    );

    await tester.tap(find.text('Name'));
    await tester.pumpAndSettle();

    expect(sortedCol, equals(1));
    expect(sortedAsc, equals(true));
  });

  testWidgets('handles row selection via checkboxes', (tester) async {
    Set<SampleItem> currentSelection = {};

    await tester.pumpWidget(
      buildTestTable(
        selectable: true,
        selectedItems: currentSelection,
        onSelectionChanged: (updated) {
          currentSelection = updated;
        },
      ),
    );

    expect(find.byType(Checkbox), findsNWidgets(4)); // 1 header + 3 rows

    await tester.tap(find.byType(Checkbox).at(1)); // Select first row
    await tester.pumpAndSettle();

    expect(currentSelection.length, equals(1));
    expect(currentSelection.first.id, equals(1));
  });

  testWidgets('renders loading state when isLoading is true', (tester) async {
    await tester.pumpWidget(buildTestTable(isLoading: true));

    expect(find.text('Loading data...'), findsOneWidget);
    expect(find.text('Alpha'), findsNothing);
  });

  testWidgets('renders error state when error is provided', (tester) async {
    await tester.pumpWidget(buildTestTable(error: 'Connection timeout'));

    expect(find.textContaining('Connection timeout'), findsOneWidget);
    expect(find.text('Alpha'), findsNothing);
  });

  testWidgets('renders pagination controls when enabled', (tester) async {
    int page = 1;
    await tester.pumpWidget(
      buildTestTable(
        showPagination: true,
        page: page,
        pageSize: 2,
        onPageChanged: (newPage) {
          page = newPage;
        },
      ),
    );

    expect(find.text('Showing 1 to 2 of 3 entries'), findsOneWidget);
    expect(find.text('Page 1 of 2'), findsOneWidget);

    await tester.tap(find.byTooltip('Next page'));
    await tester.pumpAndSettle();

    expect(page, equals(2));
  });

  testWidgets('supports keyboard navigation arrow keys', (tester) async {
    await tester.pumpWidget(buildTestTable());

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pumpAndSettle();

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pumpAndSettle();

    // Verify widget builds without error under keyboard interaction
    expect(find.text('Alpha'), findsOneWidget);
  });

  testWidgets('does not overflow when less than header height is available', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 34,
            child: AppDataTable<SampleItem>(
              items: testItems,
              columns: testColumns,
              keyExtractor: (item) => item.id,
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });
}
