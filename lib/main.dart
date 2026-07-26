import 'package:flutter/material.dart';
import 'package:green_kitchen_ui/green_kitchen_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Green Kitchen',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: const UiKitchenSinkPage(),
    );
  }
}

class UiKitchenSinkPage extends StatefulWidget {
  const UiKitchenSinkPage({super.key});

  @override
  State<UiKitchenSinkPage> createState() => _UiKitchenSinkPageState();
}

class _UiKitchenSinkPageState extends State<UiKitchenSinkPage> {
  var _tab = 0;
  var _agreed = false;
  var _reminder = true;
  var _volume = 0.6;
  String? _project;
  var _chips = <String>{'Design'};
  var _themeMode = 'light';
  var _page = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            AppNavigationHeader(
              title: 'Design System',
              showBack: false,
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_vert),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.gap16),
            AppTabs(
              tabs: const ['Active', 'Completed'],
              selectedIndex: _tab,
              onChanged: (i) => setState(() => _tab = i),
            ),
            const SizedBox(height: AppSpacing.gap20),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const AppText('Buttons', variant: AppTextVariant.h4),
                  const SizedBox(height: AppSpacing.gap12),
                  AppButton(
                    label: 'Sign up',
                    onPressed: () {},
                  ),
                  const SizedBox(height: AppSpacing.gap10),
                  AppButton(
                    label: 'Sign in',
                    variant: AppButtonVariant.soft,
                    onPressed: () {},
                  ),
                  const SizedBox(height: AppSpacing.gap10),
                  AppButton(
                    label: 'Add Custom',
                    variant: AppButtonVariant.outline,
                    leading: const Icon(Icons.add),
                    onPressed: () {},
                  ),
                  const SizedBox(height: AppSpacing.gap10),
                  AppButton(
                    label: 'Continue with Google',
                    variant: AppButtonVariant.social,
                    leading: const Icon(Icons.g_mobiledata),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.gap16),
            AppTextField(
              label: 'Email',
              hint: 'Email',
              prefixIcon: const Icon(Icons.mail_outline),
            ),
            const SizedBox(height: AppSpacing.gap12),
            const AppTextField(
              label: 'Password',
              hint: 'Password',
              obscureText: true,
              prefixIcon: Icon(Icons.lock_outline),
            ),
            const SizedBox(height: AppSpacing.gap16),
            AppDropdown<String>(
              hint: 'Select project',
              value: _project,
              items: const [
                AppDropdownItem(value: 'general', label: 'General'),
                AppDropdownItem(value: 'focuso', label: 'Pomodoro App'),
                AppDropdownItem(value: 'shop', label: 'E-Commerce App'),
              ],
              onChanged: (v) => setState(() => _project = v),
            ),
            const SizedBox(height: AppSpacing.gap16),
            AppChips(
              options: const ['General', 'Design', 'Urgent', 'Work'],
              selected: _chips,
              layout: AppChipsLayout.wrap,
              onChanged: (v) => setState(() => _chips = v),
            ),
            const SizedBox(height: AppSpacing.gap16),
            AppCheckbox(
              value: _agreed,
              onChanged: (v) => setState(() => _agreed = v),
              child: AppLinkText(
                spans: [
                  const AppTextSpan(text: 'I agree to Focuso '),
                  AppTextSpan(
                    text: 'Terms & Conditions.',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.gap16),
            Row(
              children: [
                const Expanded(
                  child: AppText('Reminder', variant: AppTextVariant.body),
                ),
                AppSwitch(
                  value: _reminder,
                  onChanged: (v) => setState(() => _reminder = v),
                ),
              ],
            ),
            AppSlider(
              value: _volume,
              onChanged: (v) => setState(() => _volume = v),
            ),
            const SizedBox(height: AppSpacing.gap16),
            AppRadioGroup<String>(
              value: _themeMode,
              onChanged: (v) => setState(() => _themeMode = v),
              items: const [
                AppRadioGroupItem(value: 'system', label: 'System Default'),
                AppRadioGroupItem(value: 'light', label: 'Light'),
                AppRadioGroupItem(value: 'dark', label: 'Dark'),
              ],
            ),
            const SizedBox(height: AppSpacing.gap20),
            Center(
              child: AppPageIndicator(
                count: 3,
                index: _page,
                onChanged: (i) => setState(() => _page = i),
              ),
            ),
            const SizedBox(height: AppSpacing.gap16),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'Dialog',
                    variant: AppButtonVariant.soft,
                    onPressed: () {
                      AppDialog.show(
                        context: context,
                        title: 'Great Work!\nTime for a Break',
                        body:
                            'You just finished 25 minutes of deep focus. Let your brain rest and recharge.',
                        actions: AppButton(
                          label: 'OK',
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: AppSpacing.gap10),
                Expanded(
                  child: AppButton(
                    label: 'Sheet',
                    onPressed: () {
                      AppBottomSheet.show(
                        context: context,
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: AppSelectionList<String>(
                            items: const [
                              AppSelectionItem(value: '5', label: '5 mins'),
                              AppSelectionItem(value: '10', label: '10 mins'),
                              AppSelectionItem(value: '15', label: '15 mins'),
                              AppSelectionItem(value: '25', label: '25 mins'),
                            ],
                            selected: const {'25'},
                            onChanged: (_) => Navigator.of(context).pop(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
