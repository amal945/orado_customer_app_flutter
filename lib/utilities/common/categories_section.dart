import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:orado_customer/features/home/models/category_model.dart';
import '../utilities.dart';

class CategoriesSection extends StatefulWidget {
  const CategoriesSection({super.key, required this.categories});
  final List<CategoryData> categories;

  @override
  State<CategoriesSection> createState() => _CategoriesSectionState();
}

class _CategoriesSectionState extends State<CategoriesSection> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category List
              Row(
                children: widget.categories.asMap().entries.map((entry) {
                  final i = entry.key;
                  final e = entry.value;

                  final isSelected = widget.categories[index].categoryId == e.categoryId;

                  return Center(
                    child: InkWell(
                      onTap: () {
                        if (!isSelected) {
                          setState(() => index = i);
                        }
                      },
                      child: Card(
                        clipBehavior: Clip.hardEdge,
                        surfaceTintColor: Colors.transparent,
                        color: isSelected ? const Color(0xFFF3DCC5) : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: isSelected ? Colors.red : Colors.white),
                        ),
                        elevation: 6,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 15),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.baseColor.withOpacity(0.2)
                                : Colors.white,
                            border: Border.all(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: CachedNetworkImage(
                                  imageUrl: e.categoryimagerelation?.imageName ?? '',
                                  height: 35,
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                ),
                              ),
                              const SizedBox(width: 10),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 400),
                                child: Text(
                                  e.categoryName ?? '',
                                  key: ValueKey(e.categoryName),
                                  style: AppStyles.getSemiBoldTextStyle(
                                    fontSize: 14,
                                    color: AppColors.baseColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              // Subcategory List
              if (widget.categories.isNotEmpty)
                Row(
                  children: widget.categories[index].categoryrelation1?.map((sub) {
                    return InkWell(
                      onTap: () {
                        // TODO: Handle subcategory tap
                      },
                      child: Card(
                        clipBehavior: Clip.hardEdge,
                        surfaceTintColor: Colors.transparent,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 6,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 15),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: CachedNetworkImage(
                                  imageUrl: sub.subcategoryImagerelation?.imageName ?? '',
                                  height: 35,
                                  errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                                ),
                              ),
                              const SizedBox(width: 10),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 400),
                                child: Text(
                                  sub.subcategoryName ?? '',
                                  key: ValueKey(sub.subcategoryName),
                                  style: AppStyles.getSemiBoldTextStyle(
                                    fontSize: 14,
                                    color: AppColors.baseColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList() ??
                      [],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
