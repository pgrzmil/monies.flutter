import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:monies/services/signInService.dart';
import 'package:monies/utils/navigation.dart';
import 'package:provider/provider.dart';
import 'package:monies/data/modules.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var showLoginButton = false;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      final isLoggedIn = await Provider.of<SignInService>(context, listen: false).isLoggedIn;
      if (isLoggedIn) {
        await Navigator.pushNamedAndRemoveUntil(context, Routes.dashboard, (_) => false);
      } else {
        setState(() {
          showLoginButton = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment(0.0, 0.0),
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset("assets/icon.svg", height: 150, width: 150, color: Theme.of(context).accentColor),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 25, horizontal: 0),
              child: Text("monies", style: TextStyle(color: Theme.of(context).accentColor, fontSize: 30)),
            ),
            _signInButton(context),
            AnimatedOpacity(
              opacity: showLoginButton ? 0.0 : 1.0,
              duration: Duration(milliseconds: 150),
              child: LinearProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _signInButton(BuildContext context) {
    return AnimatedOpacity(
      opacity: showLoginButton ? 1.0 : 0.0,
      duration: Duration(milliseconds: 750),
      child: OutlineButton(
        splashColor: Colors.grey,
        onPressed: _signIn,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        highlightElevation: 0,
        borderSide: BorderSide(color: Colors.grey),
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(image: AssetImage("assets/google_logo.png"), height: 35.0),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text('Sign in with Google', style: TextStyle(fontSize: 20, color: Colors.grey)),
              )
            ],
          ),
        ),
      ),
    );
  }

  _signIn() async {
    setState(() {
      showLoginButton = false;
    });
    final user = await Provider.of<SignInService>(context, listen: false).signIn((e) {
      Fluttertoast.showToast(
        msg: "${e}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 8,
        //backgroundColor: Colors.red,
        //textColor: Colors.white,
        // fontSize: 16.0
      );
    });
    if (user != null) {
      _reloadServices();
      await Navigator.pushNamedAndRemoveUntil(context, Routes.dashboard, (_) => false);
    } else {
      setState(() {
        showLoginButton = true;
      });
    }
  }

  _reloadServices() {
    Provider.of<ExpensesProvider>(context, listen: false).refresh();
    Provider.of<IncomesProvider>(context, listen: false).refresh();
    Provider.of<CategoriesProvider>(context, listen: false).refresh();
  }
}
