import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orado_customer/features/auth/presentation/get_started_screen.dart';
import 'package:orado_customer/features/profile/presentation/edit_profile_screen.dart';
import 'package:orado_customer/features/profile/presentation/loyalty_info_screen.dart';
import 'package:orado_customer/features/profile/provider/profile_provider.dart';
import 'package:orado_customer/features/ticket/presentation/ticket_screen.dart';
import 'package:orado_customer/utilities/common/custom_coloured_button.dart';
import 'package:orado_customer/utilities/utilities.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utilities/common/logout_confirm_dialogue_box.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  static const String route = 'profile';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        context.read<ProfileProvider>().fetchAndUpdateProfile();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<ProfileProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style:
              AppStyles.getBoldTextStyle(fontSize: 22, color: AppColors.yellow),
        ),
        backgroundColor: AppColors.baseColor,
        iconTheme: IconThemeData(color: AppColors.yellow, size: 24),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.yellow, size: 24),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit_rounded, color: AppColors.yellow, size: 24),
            onPressed: () {
              context.pushNamed(EditProfileScreen.route);
            },
          ),
        ],
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          Center(
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.baseColor, width: 2),
              ),
              child: CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.yellow,
                child: Icon(Icons.person, size: 50, color: AppColors.baseColor),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              user.name,
              style: AppStyles.getBoldTextStyle(fontSize: 24),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              user.email,
              style: AppStyles.getMediumTextStyle(
                  fontSize: 16, color: AppColors.baseColor),
            ),
          ),
          const SizedBox(height: 24),
          _cardTitle('User Info'),
          const SizedBox(height: 16),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.phone, color: AppColors.baseColor),
                  title: Text('Phone',
                      style: AppStyles.getBoldTextStyle(fontSize: 16)),
                  subtitle: Text(user.phone),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.location_on, color: AppColors.baseColor),
                  title: Text('Address',
                      style: AppStyles.getBoldTextStyle(fontSize: 16)),
                  subtitle: Text(user.address),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _cardTitle('More'),
          const SizedBox(height: 16),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: Column(
              children: [
                ListTile(
                  minVerticalPadding: 20,
                  onTap: () {},
                  leading: Icon(Icons.info_outline, color: AppColors.baseColor),
                  title: Text('About',
                      style: AppStyles.getBoldTextStyle(fontSize: 20)),
                  trailing: Icon(Icons.arrow_forward_ios,
                      color: AppColors.baseColor, size: 16),
                ),
                const Divider(height: 1),
                ListTile(
                  minVerticalPadding: 20,
                  onTap: () {},
                  leading: Icon(Icons.privacy_tip_outlined,
                      color: AppColors.baseColor),
                  title: Text('Privacy Policy',
                      style: AppStyles.getBoldTextStyle(fontSize: 20)),
                  trailing: Icon(Icons.arrow_forward_ios,
                      color: AppColors.baseColor, size: 16),
                ),
                const Divider(height: 1),
                ListTile(
                  minVerticalPadding: 20,
                  onTap: () {
                    context.pushNamed(TicketScreen.route);
                  },
                  leading: Icon(Icons.support_agent_outlined,
                      color: AppColors.baseColor),
                  title: Text('Raise a Ticket',
                      style: AppStyles.getBoldTextStyle(fontSize: 20)),
                  trailing: Icon(Icons.arrow_forward_ios,
                      color: AppColors.baseColor, size: 16),
                ),
                const Divider(height: 1),
                ListTile(
                  minVerticalPadding: 20,
                  onTap: () {
                    context.pushNamed(LoyaltyInfoScreen.route);
                  },
                  leading:
                      Icon(Icons.verified_outlined, color: AppColors.baseColor),
                  title: Text('Loyalty Points',
                      style: AppStyles.getBoldTextStyle(fontSize: 20)),
                  trailing: Icon(Icons.arrow_forward_ios,
                      color: AppColors.baseColor, size: 16),
                ),
                const Divider(height: 1),
                ListTile(
                  minVerticalPadding: 20,
                  onTap: () {
                    showLogoutConfirmationDialog(
                      context,
                      onLogout: () async {
                        final sharedPreferences =
                            await SharedPreferences.getInstance();
                        await sharedPreferences.clear();
                        context.goNamed(GetStartedScreen.route);
                      },
                    );
                  },
                  leading: Icon(Icons.logout, color: AppColors.baseColor),
                  title: Text('Logout',
                      style: AppStyles.getBoldTextStyle(fontSize: 20)),
                  trailing: Icon(Icons.arrow_forward_ios,
                      color: AppColors.baseColor, size: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardTitle(String text) {
    return RichText(
      text: TextSpan(
        style: AppStyles.getRegularTextStyle(
            fontSize: 16, color: AppColors.titleTextColor),
        children: <TextSpan>[
          TextSpan(
            text: '| ',
            style: AppStyles.getBoldTextStyle(
                fontSize: 24, color: AppColors.baseColor),
          ),
          TextSpan(
            text: text,
            style: AppStyles.getBoldTextStyle(
                fontSize: 24, color: AppColors.titleTextColor),
          ),
        ],
      ),
    );
  }
}
