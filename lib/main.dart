import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monies/consts.dart';
import 'package:monies/data/analyticsProvider.dart';
import 'package:monies/data/dashboardProvider.dart';
import 'package:monies/data/incomesProvider.dart';
import 'package:monies/data/recurringExpensesProvider.dart';
import 'package:monies/utils/navigation.dart';
import 'package:monies/services/signInService.dart';
import 'package:monies/widgets/controls/dismissKeyboard.dart';
import 'package:provider/provider.dart';
import 'data/categoriesProvider.dart';
import 'data/expensesProvider.dart';
import 'data/recurringExpensesMapProvider.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final defaultTextTheme = GoogleFonts.nunitoTextTheme(Theme.of(context).textTheme).apply(
      bodyColor: Consts.textColor,
      decorationColor: Consts.textColor,
      displayColor: Consts.accentColor,
    );
    final authService = SignInService();
    return MultiProvider(
      providers: [
        Provider(create: (context) => authService),
        ChangeNotifierProvider(create: (context) => CategoriesProvider(authService: authService)),
        ChangeNotifierProvider(create: (context) => RecurringExpensesMapProvider(authService: authService)),
        ChangeNotifierProvider(create: (context) => RecurringExpensesProvider(authService: authService)),
        ChangeNotifierProxyProvider2<RecurringExpensesProvider, RecurringExpensesMapProvider, ExpensesProvider>(
          create: (context) => ExpensesProvider(authService: authService),
          update: (context, recurringExpensesProvider, recurringExpensesMapProvider, expensesProvider) {
            expensesProvider.recurringExpensesProvider = recurringExpensesProvider;
            expensesProvider.recurringExpensesMapProvider = recurringExpensesMapProvider;
            return expensesProvider;
          },
        ),
        ChangeNotifierProxyProvider<ExpensesProvider, IncomesProvider>(
          create: (context) => IncomesProvider(authService: authService),
          update: (context, expensesProvider, incomesProvider) {
            incomesProvider.expensesProvider = expensesProvider;
            return incomesProvider;
          },
        ),
        ChangeNotifierProxyProvider2<ExpensesProvider, CategoriesProvider, AnalyticsProvider>(
          create: (context) => AnalyticsProvider(),
          update: (context, expensesProvider, categoriesProvider, dashboardProvider) {
            return dashboardProvider.setProviders(expensesProvider: expensesProvider, categoriesProvider: categoriesProvider);
          },
        ),
        ChangeNotifierProxyProvider3<ExpensesProvider, IncomesProvider, AnalyticsProvider, DashboardProvider>(
          create: (context) => DashboardProvider(),
          update: (context, expensesProvider, incomesProvider, analyticsProvider, dashboardProvider) {
            return dashboardProvider.setProviders(
              expensesProvider: expensesProvider,
              incomesProvider: incomesProvider,
              analyticsProvider: analyticsProvider,
            );
          },
        )
      ],
      child: DismissKeyboard(
        context,
        child: MaterialApp(
          title: 'monies',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.dark().copyWith(
              primary: Consts.accentColor,
              secondary: Consts.backgroundColor,
            ),
            brightness: Brightness.dark,
            primaryColorBrightness: Brightness.dark,
            primaryColor: Consts.accentColor,
            accentColor: Consts.accentColor,
            cursorColor: Consts.accentColor,
            backgroundColor: Consts.backgroundColor,
            canvasColor: Consts.backgroundColor,
            dialogBackgroundColor: Consts.backgroundColor,
            textTheme: defaultTextTheme,
            iconTheme: IconThemeData().copyWith(color: Consts.appBarColor),
            floatingActionButtonTheme: FloatingActionButtonThemeData().copyWith(backgroundColor: Consts.accentColor),
            appBarTheme: AppBarTheme(
                elevation: 0,
                color: Consts.backgroundColor,
                brightness: Brightness.dark,
                textTheme: defaultTextTheme.copyWith(
                  title: GoogleFonts.nunito(
                    textStyle: defaultTextTheme.title,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Consts.appBarColor,
                  ),
                ),
                iconTheme: IconThemeData().copyWith(color: Consts.appBarColor)),
          ),
          routes: Routes.navigationRoutes,
          initialRoute: Routes.login,
        ),
      ),
    );
  }
}
