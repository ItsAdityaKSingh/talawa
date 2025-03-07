import 'package:flutter/material.dart';
import 'package:talawa/view_model/after_auth_view_models/feed_view_models/organization_feed_view_model.dart';
import 'package:talawa/view_model/main_screen_view_model.dart';
import 'package:talawa/views/base_view.dart';
import 'package:talawa/widgets/pinned_carousel_widget.dart';
import 'package:talawa/widgets/post_list_widget.dart';

class OrganizationFeed extends StatelessWidget {
  const OrganizationFeed({
    required Key key,
    this.homeModel,
  }) : super(key: key);
  final MainScreenViewModel? homeModel;

  @override
  Widget build(BuildContext context) {
    return BaseView<OrganizationFeedViewModel>(
      onModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 0.0,
            centerTitle: true,
            title: Text(
              model.currentOrgName,
              key: homeModel?.keySHOrgName,
              style: Theme.of(context).textTheme.headline6!.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
            ),
            leading: IconButton(
              key: homeModel?.keySHMenuIcon,
              icon: Icon(
                Icons.menu,
                color: Theme.of(context).iconTheme.color,
              ),
              onPressed: () =>
                  homeModel!.scaffoldKey.currentState!.openDrawer(),
            ),
          ),
          body: model.isBusy
              ? const CircularProgressIndicator()
              : RefreshIndicator(
                  onRefresh: () async => model.fetchNewPosts(),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      model.pinnedPosts.isNotEmpty
                          ? PinnedPostCarousel(
                              key: homeModel?.keySHPinnedPost,
                              pinnedPosts: model.pinnedPosts,
                              navigateToPinnedPostPage:
                                  model.navigateToPinnedPostPage,
                              navigateToIndividualPostPage:
                                  model.navigateToIndividualPage,
                            )
                          : Container(),
                      model.posts.isNotEmpty
                          ? PostListWidget(
                              key: homeModel?.keySHPost,
                              posts: model.posts,
                              function: model.navigateToIndividualPage,
                            )
                          : Container(),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
