import 'package:flutter/material.dart';
import 'package:talawa/locator.dart';
import 'package:talawa/services/size_config.dart';
import 'package:talawa/view_model/base_view_model.dart';
import 'package:talawa/widgets/custom_alert_dialog.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class MainScreenViewModel extends BaseModel {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey keyBNHome = GlobalKey(debugLabel: "HomeTab");
  final GlobalKey keySHPinnedPost =
      GlobalKey(debugLabel: "HomeScreenPinnedPost");
  final GlobalKey keySHPost = GlobalKey(debugLabel: "HomeScreenPost");
  final GlobalKey keySHOrgName = GlobalKey(debugLabel: "HomeScreenOrgName");
  final GlobalKey keySHMenuIcon = GlobalKey(debugLabel: "HomeScreenMenuIcon");

  final GlobalKey keyDrawerCurOrg = GlobalKey(debugLabel: "DrawerCurrentOrg");
  final GlobalKey keyDrawerSwitchableOrg =
      GlobalKey(debugLabel: "DrawerSwitchableOrg");
  final GlobalKey keyDrawerJoinOrg = GlobalKey(debugLabel: "DrawerJoinOrg");
  final GlobalKey keyDrawerLeaveCurrentOrg =
      GlobalKey(debugLabel: "DrawerLeaveCurrentOr");

  final GlobalKey keyBNEvents = GlobalKey(debugLabel: "EventTab");
  final GlobalKey keySECategoryMenu =
      GlobalKey(debugLabel: "EventScreenCategory");
  final GlobalKey keySEDateFilter =
      GlobalKey(debugLabel: "EventScreenDateFilter");
  final GlobalKey keySEAdd = GlobalKey(debugLabel: "EventScreenAdd");
  final GlobalKey keySECard = GlobalKey(debugLabel: "EventScreenCard");

  final GlobalKey keyBNPost = GlobalKey(debugLabel: "PostTab");

  final GlobalKey keyBNChat = GlobalKey(debugLabel: "ChatTab");

  final GlobalKey keyBNProfile = GlobalKey(debugLabel: "ProfileTab");
  final GlobalKey keySPEditProfile = GlobalKey(debugLabel: "ProfileScreenEdit");
  final GlobalKey keySPAppSetting =
      GlobalKey(debugLabel: "ProfileScreenAppSetting");
  final GlobalKey keySPHelp = GlobalKey(debugLabel: "ProfileScreenHelp");
  final GlobalKey keySPDonateUs =
      GlobalKey(debugLabel: "ProfileScreenDonateUs");
  final GlobalKey keySPInvite = GlobalKey(debugLabel: "ProfileScreenInvite");
  final GlobalKey keySPLogout = GlobalKey(debugLabel: "ProfileScreenLogout");
  final GlobalKey keySPPalisadoes =
      GlobalKey(debugLabel: "ProfileScreenPalisadoes");

  late bool showAppTour;
  bool tourComplete = false;
  bool tourSkipped = false;
  late BuildContext context;
  late TutorialCoachMark tutorialCoachMark;
  final List<TargetFocus> targets = [];

  int currentIndex = 0;
  onTabTapped(int index) {
    currentIndex = index;
    notifyListeners();
  }

  initialise(
    BuildContext ctx, {
    required bool fromSignUp,
    required int mainScreenIndex,
  }) {
    currentIndex = mainScreenIndex;
    showAppTour = fromSignUp;
    notifyListeners();
    if (!showAppTour) {
      tourComplete = true;
      tourSkipped = false;
    } else {
      Future.delayed(
        const Duration(seconds: 1),
        () => navigationService.pushDialog(
          CustomAlertDialog(
            dialogTitle: 'App Tour',
            dialogSubTitle: 'Start app tour to know talawa functioning',
            successText: 'Start',
            secondaryButtonText: 'Skip',
            success: () {
              context = ctx;
              navigationService.pop();
              tourHomeTargets();
            },
            secondaryButtonTap: () {
              tourComplete = false;
              tourSkipped = true;
              notifyListeners();
            },
          ),
        ),
      );
    }
  }

  void showTutorial({
    required dynamic Function(TargetFocus) onClickTarget,
    required dynamic Function() onFinish,
  }) {
    tutorialCoachMark = TutorialCoachMark(
      context,
      targets: targets,
      colorShadow: Theme.of(context).colorScheme.secondaryContainer,
      textSkip: "SKIP",
      textStyleSkip:
          TextStyle(color: Theme.of(context).backgroundColor, fontSize: 20),
      paddingFocus: 10,
      opacityShadow: 1.0,
      onFinish: onFinish,
      onClickTarget: onClickTarget,
      onSkip: () {
        if (scaffoldKey.currentState!.isDrawerOpen) {
          navigationService.pop();
        }
        tourSkipped = true;
        onTabTapped(0);
      },
      onClickOverlay: (target) {
        onClickTarget(target);
      },
    )..show();
  }

  tourHomeTargets() {
    targets.clear();
    targets.add(
      focusTarget(
        keySHOrgName,
        'keySHOrgName',
        'Current selected Organization Name',
      ),
    );
    targets.add(
      focusTarget(
        keySHMenuIcon,
        'keySHMenuIcon',
        'Click this button to see options related to switching, joining and leaving organization(s)',
        isCircle: true,
        next: () => scaffoldKey.currentState!.openDrawer(),
      ),
    );
    targets.add(
      focusTarget(
        keyDrawerCurOrg,
        'keyDrawerCurOrg',
        "Current selected Organization's Name appears here",
      ),
    );
    targets.add(
      focusTarget(
        keyDrawerSwitchableOrg,
        'keyDrawerSwitchableOrg',
        "All your joined organizations appear over here you can click on them to change the current organization",
      ),
    );
    targets.add(
      focusTarget(
        keyDrawerJoinOrg,
        'keyDrawerJoinOrg',
        "From this button you can join other listed organizations",
        align: ContentAlign.top,
      ),
    );
    targets.add(
      focusTarget(
        keyDrawerLeaveCurrentOrg,
        'keyDrawerLeaveCurrentOrg',
        "To leave the current organization you can use this option",
        align: ContentAlign.top,
        next: () => navigationService.pop(),
      ),
    );
    targets.add(
      focusTarget(
        keyBNHome,
        'keyBNHome',
        "This is the home tab here you can see the latest post from other members of the current organization",
        isCircle: true,
        align: ContentAlign.top,
      ),
    );
    targets.add(
      focusTarget(
        keySHPinnedPost,
        'keySHPinnedPost',
        "This section displays all the important post set by the organization admin(s)",
        align: ContentAlign.bottom,
      ),
    );
    targets.add(
      focusTarget(
        keySHPost,
        'keySHPost',
        "This is the post card you can like and comment on the post from the options available",
        align: ContentAlign.bottom,
      ),
    );
    showTutorial(
      onClickTarget: showHome,
      onFinish: () {
        onTabTapped(currentIndex + 1);
        if (!tourComplete && !tourSkipped) {
          tourEventTargets();
        }
      },
    );
  }

  showHome(TargetFocus clickedTarget) {
    switch (clickedTarget.identify) {
      case "keySHMenuIcon":
        scaffoldKey.currentState!.openDrawer();
        break;
      case "keyDrawerLeaveCurrentOrg":
        navigationService.pop();
    }
  }

  tourEventTargets() {
    targets.clear();
    targets.add(
      focusTarget(
        keyBNEvents,
        'keyBNEvents',
        'This is the Events tab here you can see all event related information of the current selected organization',
        isCircle: true,
        align: ContentAlign.top,
      ),
    );
    targets.add(
      focusTarget(
        keySECategoryMenu,
        'keySECategoryMenu',
        'Filter Events based on categories',
      ),
    );
    targets.add(
      focusTarget(
        keySEDateFilter,
        'keySEDateFilter',
        'Filter Events between selected dates',
      ),
    );
    targets.add(
      focusTarget(
        keySECard,
        'keySECard',
        'Description of event to see more details click on the card',
      ),
    );
    targets.add(
      focusTarget(
        keySEAdd,
        'keySEAdd',
        'You can create a new event from here',
        align: ContentAlign.top,
      ),
    );
    showTutorial(
      onFinish: () {
        onTabTapped(currentIndex + 1);
        if (!tourComplete && !tourSkipped) {
          tourAddPost();
        }
      },
      onClickTarget: (TargetFocus a) {},
    );
  }

  tourAddPost() {
    targets.clear();
    targets.add(
      focusTarget(
        keyBNPost,
        'keyBNPost',
        'This is the Create post tab here you can add post to the current selected organization',
        isCircle: true,
        align: ContentAlign.top,
      ),
    );
    showTutorial(
      onFinish: () {
        onTabTapped(currentIndex + 1);
        if (!tourComplete && !tourSkipped) {
          tourChat();
        }
      },
      onClickTarget: (TargetFocus a) {},
    );
  }

  tourChat() {
    targets.clear();
    targets.add(
      focusTarget(
        keyBNChat,
        'keyBNChat',
        'This is the Chat tab here you can see all your messages of the current selected organization',
        isCircle: true,
        align: ContentAlign.top,
      ),
    );
    showTutorial(
      onFinish: () {
        onTabTapped(currentIndex + 1);
        if (!tourComplete && !tourSkipped) {
          tourProfile();
        }
      },
      onClickTarget: (TargetFocus a) {},
    );
  }

  tourProfile() {
    targets.clear();
    targets.add(
      focusTarget(
        keyBNProfile,
        'keyBNProfile',
        'This is the Profile tab here you can see all options related to account, app setting, invitation, help etc',
        isCircle: true,
        align: ContentAlign.top,
        nextCrossAlign: CrossAxisAlignment.start,
      ),
    );
    targets.add(
      focusTarget(
        keySPAppSetting,
        'keySPAppSetting',
        'You can edit application settings like language, theme etc from here',
      ),
    );
    targets.add(
      focusTarget(
        keySPHelp,
        'keySPHelp',
        'For any help we are always there. You can reach us from here',
      ),
    );
    targets.add(
      focusTarget(
        keySPDonateUs,
        'keySPDonateUs',
        'To help your organization grow you can support them financially from here',
      ),
    );
    targets.add(
      focusTarget(
        keySPInvite,
        'keySPInvite',
        'Wanna invite colleague, invite them from here',
      ),
    );
    targets.add(
      focusTarget(
        keySPPalisadoes,
        'keySPPalisadoes',
        'You are all set to go lets get you in',
        isEnd: true,
      ),
    );
    showTutorial(
      onFinish: () {
        if (!tourComplete && !tourSkipped) {
          tourComplete = true;
          onTabTapped(0);
        }
      },
      onClickTarget: (TargetFocus a) {},
    );
  }

  TargetFocus focusTarget(
    GlobalKey key,
    String keyName,
    String description, {
    bool isCircle = false,
    ContentAlign align = ContentAlign.bottom,
    CrossAxisAlignment crossAlign = CrossAxisAlignment.start,
    Alignment skipAlignment = Alignment.topRight,
    Function? next,
    CrossAxisAlignment nextCrossAlign = CrossAxisAlignment.end,
    bool isEnd = false,
  }) {
    return TargetFocus(
      enableOverlayTab: true,
      color: Colors.transparent,
      identify: keyName,
      keyTarget: key,
      alignSkip: skipAlignment,
      shape: isCircle ? ShapeLightFocus.Circle : ShapeLightFocus.RRect,
      contents: [
        TargetContent(
          align: align,
          builder: (context, controller) {
            return Container(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: crossAlign,
                children: <Widget>[
                  Text(
                    description,
                    style: TextStyle(
                      color: Theme.of(context).backgroundColor,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        TargetContent(
          align: ContentAlign.custom,
          customPosition: CustomTargetContentPosition(
            bottom: SizeConfig.screenHeight! * 0.025,
          ),
          builder: (context, controller) {
            return GestureDetector(
              onTap: () {
                if (next != null) {
                  next();
                }
                tutorialCoachMark.next();
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: nextCrossAlign,
                children: <Widget>[
                  Text(
                    isEnd ? 'COMPLETE' : 'NEXT',
                    style: TextStyle(
                      color: Theme.of(context).backgroundColor,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
