enum NotificationType { follow, like }





class TwitterNotificationModel {
  String id;
  NotificationType type;
  TwitterNotificationModel({required this.id, required this.type});
}

List<TwitterNotificationModel> notifications = [
  TwitterNotificationModel(id: '3', type: NotificationType.follow),
  TwitterNotificationModel(id: '4', type: NotificationType.like),
  TwitterNotificationModel(id: '3', type: NotificationType.follow),
  TwitterNotificationModel(id: '4', type: NotificationType.like),
  TwitterNotificationModel(id: '3', type: NotificationType.follow),
  TwitterNotificationModel(id: '4', type: NotificationType.like),
  TwitterNotificationModel(id: '3', type: NotificationType.follow),
  TwitterNotificationModel(id: '4', type: NotificationType.like),
  TwitterNotificationModel(id: '3', type: NotificationType.follow),
  TwitterNotificationModel(id: '4', type: NotificationType.like),
];