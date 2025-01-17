import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import 'package:simple_live_app/app/app_style.dart';
import 'package:simple_live_app/app/sites.dart';
import 'package:simple_live_app/modules/user/follow_user/follow_user_controller.dart';
import 'package:simple_live_app/routes/app_navigation.dart';
import 'package:simple_live_app/widgets/net_image.dart';
import 'package:simple_live_app/widgets/page_grid_view.dart';
import 'dart:ui' as ui;

class FollowUserPage extends GetView<FollowUserController> {
  const FollowUserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var count = MediaQuery.of(context).size.width ~/ 500;
    if (count < 1) count = 1;
    return Scaffold(
      appBar: AppBar(
        title: const Text("关注用户"),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return const [
                PopupMenuItem(
                  value: 0,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Remix.save_2_line),
                      AppStyle.hGap12,
                      Text("导出列表")
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 1,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Remix.folder_open_line),
                      AppStyle.hGap12,
                      Text("导入列表")
                    ],
                  ),
                ),
              ];
            },
            onSelected: (value) {
              if (value == 0) {
                controller.exportList();
              } else if (value == 1) {
                controller.inputList();
              }
            },
          ),
        ],
      ),
      body: PageGridView(
        crossAxisSpacing: 12,
        crossAxisCount: count,
        pageController: controller,
        firstRefresh: true,
        itemBuilder: (_, i) {
          var item = controller.list[i];
          var site = Sites.supportSites.firstWhere((x) => x.id == item.siteId);
          return ListTile(
            contentPadding: AppStyle.edgeInsetsL16.copyWith(right: 4),
            leading: NetImage(
              item.face,
              width: 48,
              height: 48,
              borderRadius: 24,
            ),
            title: Text.rich(
              TextSpan(
                text: item.userName,
                children: [
                  WidgetSpan(
                    alignment: ui.PlaceholderAlignment.middle,
                    child: Obx(
                      () => Offstage(
                        offstage: item.liveStatus.value == 0,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AppStyle.hGap12,
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: item.liveStatus.value == 2
                                    ? Colors.green
                                    : Colors.grey,
                                borderRadius: AppStyle.radius12,
                              ),
                            ),
                            AppStyle.hGap4,
                            Text(
                              getStatus(item.liveStatus.value),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                color: item.liveStatus.value == 2
                                    ? null
                                    : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            subtitle: Row(
              children: [
                Image.asset(
                  site.logo,
                  width: 20,
                ),
                AppStyle.hGap4,
                Text(
                  site.name,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            trailing: IconButton(
              onPressed: () {
                controller.removeItem(item);
              },
              icon: const Icon(Remix.dislike_line),
            ),
            onTap: () {
              AppNavigator.toLiveRoomDetail(site: site, roomId: item.roomId);
            },
            onLongPress: () {
              controller.removeItem(item);
            },
          );
        },
      ),
    );
  }

  String getStatus(int status) {
    if (status == 0) {
      return "读取中";
    } else if (status == 1) {
      return "未开播";
    } else {
      return "直播中";
    }
  }
}
