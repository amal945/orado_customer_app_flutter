// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'text_formfield.dart';

// class CountryCodeWidget extends StatelessWidget {
//   CountryCodeWidget({super.key, required this.code, required this.countryCodeCubt});
//   String code;
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: InkWell(
//         onTap: () => showCountryCodeSelectionDialogue(context, countryCodeCubt),
//         child: SizedBox(
//           width: 10,
//           // color: Colors.red,
//           child: Center(
//             child: Text(
//               code,
//               style: AppStyles.getMediumTextStyle(
//                 fontSize: 14,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Future<dynamic> showCountryCodeSelectionDialogue(BuildContext context, CountryCodeSelectionCubit countryCodeCubt) {
//     String? selectedCode;
//     final TextEditingController searchController = TextEditingController();
//     final List<Map<String, dynamic>> filteredCountryCodes = <Map<String, dynamic>>[];
//     final int selectedIndex = findCountryPositionByCode(code);
//     filteredCountryCodes.addAll(AppStrings.countryCodes['countries'] ?? <Map<String, String>>[]);
//     final CountryCodeSelectionCubit cc = CountryCodeSelectionCubit();
//     final ScrollController scrollController = ScrollController();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       scrollController.jumpTo(selectedIndex * 70.0); // Adjust 50.0 as needed for item height
//     });

//     return showDialog(
//       context: context,
//       builder: (BuildContext context) => AlertDialog.adaptive(
//         // scrollable: true,
//         elevation: 7,
//         titlePadding: const EdgeInsets.all(8),
//         title: BlocProvider<CountryCodeSelectionCubit>(
//           create: (BuildContext context) => CountryCodeSelectionCubit(),
//           child: BlocConsumer<CountryCodeSelectionCubit, CountryCodeSelectionState>(
//             bloc: cc,
//             listener: (BuildContext context, CountryCodeSelectionState state) {},
//             builder: (BuildContext context, CountryCodeSelectionState state) {
//               // final targetIndex = filteredCountryCodes.indexWhere((element) => element['code'] == code);
//               // _scrollController.jumpTo(targetIndex * 50);
//               return BuildTextFormField(
//                 controller: searchController,
//                 fillColor: Colors.grey.shade200,
//                 hint: 'Search for country code',
//                 onChanged: (String searchText) {
//                   // countryCodeCubt.onSearchCountryCode(searchText);
//                   cc.onSearchCountryCode(searchText);
//                 },
//               );
//             },
//           ),
//         ),
//         insetAnimationDuration: const Duration(milliseconds: 200),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         backgroundColor: AppColors.baseColor.withOpacity(0.6),
//         content: BlocConsumer<CountryCodeSelectionCubit, CountryCodeSelectionState>(
//           bloc: cc,
//           listener: (BuildContext context, CountryCodeSelectionState state) {
//             if (state is CountryCodeSearchSuccessState) {
//               filteredCountryCodes.clear();

//               filteredCountryCodes.addAll(state.filteredCodes);
//             }
//           },
//           builder: (BuildContext context, CountryCodeSelectionState state) {
//             return SingleChildScrollView(
//               controller: scrollController,
//               child: Column(
//                 children: filteredCountryCodes.asMap().entries.map((MapEntry<int, Map<String, dynamic>> e) {
//                   return ListTile(
//                     selected: e.value['code'] == code || e.value['code'] == selectedCode,
//                     selectedTileColor: Colors.blueAccent,
//                     dense: true,
//                     onTap: () {
//                       selectedCode = e.value['code'];
//                       code = '';
//                       countryCodeCubt.onChangeCountryCode(selectedCode ?? code).whenComplete(() {
//                         Future<dynamic>.delayed(const Duration(milliseconds: 700)).whenComplete(() => context.pop());
//                       });
//                       // BlocProvider.of<CountryCodeSelectionCubit>(context).onChangeCountryCode(selectedCode);
//                     },
//                     leading: Text(
//                       e.value['code']!,
//                       maxLines: 1,
//                       style: AppStyles.getRegularTextStyle(
//                         fontSize: 15,
//                         color: Colors.white,
//                       ),
//                     ),
//                     title: Text(
//                       e.value['name']!,
//                       maxLines: 2,
//                       overflow: TextOverflow.visible,
//                       textAlign: TextAlign.right,
//                       style: AppStyles.getMediumTextStyle(
//                         fontSize: 15,
//                         color: Colors.white,
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   int findCountryPositionByCode(String code) {
//     final List<Map<String, String>> countries = AppStrings.countryCodes['countries'] ?? <Map<String, String>>[];
//     for (int i = 0; i < countries.length; i++) {
//       if (countries[i]['code'] == code) {
//         return i;
//       }
//     }
//     return -1; // Code not found
//   }
// }
