import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../utilities/common/custom_ui.dart';
import '../../../utilities/orado_icon_icons.dart';
import '../../../utilities/utilities.dart';

class OrderStatusScreen extends StatelessWidget {
  const OrderStatusScreen({super.key});
  static String route = 'prepare_order';
  @override
  Widget build(BuildContext context) {
    return CustomUi(
      physics: const NeverScrollableScrollPhysics(),
      centreTitle: true,
      title: 'Topform Restuarant',
      padding: EdgeInsets.zero,
      backGround: Align(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 10),
            Text(
              'Order will be picked up shortly',
              style: AppStyles.getSemiBoldTextStyle(
                  fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 5),
            ActionChip(
                onPressed: () {},
                color: WidgetStateColor.resolveWith(
                  (Set<WidgetState> states) =>
                      AppColors.baseColor.withValues(alpha: 0.6),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: const BorderSide(color: Colors.transparent),
                ),
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                        style: AppStyles.getSemiBoldTextStyle(
                            fontSize: 12, color: Colors.white),
                        'On time'),
                    const VerticalDivider(),
                    Text(
                        style: AppStyles.getSemiBoldTextStyle(
                            fontSize: 12, color: Colors.white),
                        'Arriving in 22 minutes'),
                  ],
                )),
          ],
        ),
      ),
      gap: 100,
      children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.sizeOf(context).height,
              color: Colors.grey.shade300,
              child: DraggableScrollableSheet(
                initialChildSize: .6,
                maxChildSize: 0.9,
                minChildSize: .32,
                builder:
                    (BuildContext context, ScrollController scrollController) {
                  return Container(
                    color: Colors.white,
                    child: ListView(
                      padding: const EdgeInsets.all(14),
                      controller: scrollController,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.shade100,
                          ),
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                dense: true,
                                tileColor: Colors.grey.shade100,
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: AppColors.yellow,
                                  child: Image.asset(
                                    height: 30,
                                    fit: BoxFit.contain,
                                    'assets/images/delivery-man 1.png',
                                  ),
                                ),
                                title: Text(
                                  'Manu Dev',
                                  style: AppStyles.getMediumTextStyle(
                                      fontSize: 14),
                                ),
                                subtitle: Text(
                                  'Your Delivery Partner',
                                  style: AppStyles.getMediumTextStyle(
                                      fontSize: 12),
                                ),
                                trailing: SizedBox(
                                  width: 100,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      InkWell(
                                        onTap: () {
                                          //! context.pushNamed(ChatScreen.route);
                                          // Navigator.push(context, MaterialPageRoute(builder: (c) => TestChat()));
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          child: Icon(
                                              color: AppColors.baseColor,
                                              size: 17,
                                              OradoIcon.message),
                                        ),
                                      ),
                                      CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: Icon(
                                            color: AppColors.baseColor,
                                            size: 17,
                                            OradoIcon.phone),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Thanks Manu Dev by leaving a tip',
                                      style: AppStyles.getMediumTextStyle(
                                          fontSize: 14),
                                    ),
                                    const SizedBox(height: 7),
                                    Row(
                                      children: <Widget>[
                                        ActionChip(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              side: BorderSide(
                                                color: Colors.grey.shade300,
                                              )),
                                          onPressed: () {},
                                          label: Text(
                                            '${AppStrings.inrSymbol}15',
                                            style: AppStyles.getMediumTextStyle(
                                                fontSize: 13),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        ActionChip(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                side: BorderSide(
                                                  color: Colors.grey.shade300,
                                                )),
                                            onPressed: () {},
                                            label: Text(
                                              '${AppStrings.inrSymbol}20',
                                              style:
                                                  AppStyles.getMediumTextStyle(
                                                      fontSize: 13),
                                            )),
                                        const SizedBox(width: 10),
                                        ActionChip(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                side: BorderSide(
                                                  color: Colors.grey.shade300,
                                                )),
                                            onPressed: () {},
                                            label: Text(
                                              '${AppStrings.inrSymbol}30',
                                              style:
                                                  AppStyles.getMediumTextStyle(
                                                      fontSize: 13),
                                            )),
                                        const SizedBox(width: 10),
                                        ActionChip(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              side: BorderSide(
                                                color: Colors.grey.shade300,
                                              )),
                                          onPressed: () {},
                                          label: Text(
                                            'Other',
                                            style: AppStyles.getMediumTextStyle(
                                                fontSize: 13),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.shade100,
                          ),
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                dense: true,
                                tileColor: Colors.grey.shade100,
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: AppColors.yellow,
                                  backgroundImage: Image.asset(
                                    // height: 30,
                                    fit: BoxFit.contain,
                                    'assets/images/food.png',
                                  ).image,
                                ),
                                title: Text(
                                  'Topform Restaurant',
                                  style: AppStyles.getMediumTextStyle(
                                      fontSize: 14),
                                ),
                                subtitle: Text(
                                  'Pavangad, Kozhikkode',
                                  style: AppStyles.getMediumTextStyle(
                                      fontSize: 12),
                                ),
                                trailing: SizedBox(
                                  width: 100,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: Icon(
                                            color: AppColors.baseColor,
                                            size: 17,
                                            OradoIcon.message),
                                      ),
                                      CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: Icon(
                                            color: AppColors.baseColor,
                                            size: 17,
                                            OradoIcon.phone),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(),
                              ListTile(
                                dense: true,
                                tileColor: Colors.grey.shade100,
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: AppColors.yellow,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: SvgPicture.asset(
                                        'assets/images/Vector.svg'),
                                  ),
                                ),
                                title: Text(
                                  'Order Details',
                                  style: AppStyles.getMediumTextStyle(
                                      fontSize: 14),
                                ),
                                isThreeLine: true,
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      '1x Biriyani',
                                      style: AppStyles.getMediumTextStyle(
                                          fontSize: 12),
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        foregroundColor: AppColors.baseColor,
                                        padding: EdgeInsets.zero,
                                      ),
                                      onPressed: () {},
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            'View Order Summary ',
                                            style: AppStyles.getMediumTextStyle(
                                                fontSize: 12),
                                          ),
                                          Icon(
                                            Icons.keyboard_arrow_right_outlined,
                                            color: AppColors.baseColor,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(),
                              const SizedBox(height: 10),
                              ListTile(
                                dense: true,
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.white,
                                  child: SvgPicture.asset(
                                    height: 30,
                                    'assets/images/chef.svg',
                                  ),
                                ),
                                title: Text(
                                  'Add Cooking Instructions',
                                  style: AppStyles.getMediumTextStyle(
                                      fontSize: 14),
                                ),
                                trailing: Icon(
                                  Icons.keyboard_arrow_right_outlined,
                                  color: AppColors.baseColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.shade100,
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: SvgPicture.asset('assets/images/home.svg'),
                            ),
                            title: Text(
                              'Delivery Address',
                              style: AppStyles.getMediumTextStyle(fontSize: 14),
                            ),
                            subtitle: Text(
                              'Lorem ipsum dolor sit amet copticuter',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppStyles.getMediumTextStyle(fontSize: 12),
                            ),
                            trailing: Icon(
                              Icons.keyboard_arrow_right_outlined,
                              color: AppColors.baseColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.shade100,
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: SvgPicture.asset('assets/images/logo.svg'),
                            ),
                            title: Text(
                              'Orado',
                              style: AppStyles.getMediumTextStyle(fontSize: 14),
                            ),
                            subtitle: Text(
                              'Need help? Contact us',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppStyles.getMediumTextStyle(fontSize: 12),
                            ),
                            trailing: SizedBox(
                              width: 100,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: Icon(
                                        color: AppColors.baseColor,
                                        size: 17,
                                        OradoIcon.message),
                                  ),
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: Icon(
                                        color: AppColors.baseColor,
                                        size: 17,
                                        OradoIcon.phone),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}
