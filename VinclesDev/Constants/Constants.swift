//
//  Constants.swift
//  Vincles BCN
//
//  Copyright © 2018 i2Cat. All rights reserved.


//// PRE AZURE
var IP = ""

var URL_BASE: String{
    return "https://\(IP)"
}

var TENANT = ""
var URL_TENANT: String{
    return "t/\(TENANT)"
}

var URL_PATH = ""
var SUFFIX_LOGIN = ""
var BASIC_AUTH_STR = ""
var USERNAME_SUFFIX = ""

var SERVER_HOST_URL = ""
var STUN_SERVER_URL = ""
var TURN_SERVER_UDP = ""
var TURN_SERVER_UDP_USERNAME = ""
var TURN_SERVER_UDP_PASSWORD = ""
var TURN_SERVER_TCP = ""
var TURN_SERVER_TCP_USERNAME = ""
var TURN_SERVER_TCP_PASSWORD = ""
var VERSION_CONTROL_URL = ""
var RATING_URL = ""
let VIDEO_MAX_SECONDS = 600

let LOGIN_ENDPOINT = "token"
let LOGOUT_ENDPOINT = "revoke"
let REGISTER_VINCULAT_ENDPOINT = "\(URL_TENANT)/\(URL_PATH)/public/users/vinculat/register"
let VALIDATE_VINCULAT_ENDPOINT = "\(URL_TENANT)/\(URL_PATH)/public/users/vinculat/validate"
let RECOVER_PASSWORD_ENDPOINT = "\(URL_TENANT)/\(URL_PATH)/public/users/password/recover"
let USER_SELF_INFO_ENDPOINT = "\(URL_TENANT)/\(URL_PATH)/users/me"
let GET_CONTENTS_LIBRARY_ENDPOINT = "\(URL_TENANT)/\(URL_PATH)/galleries/mine/entries"
let GET_CIRCLES_USER_ENDPOINT = "\(URL_TENANT)/\(URL_PATH)/circles/mine/users"
var GET_USER_PROFILE_PHOTO_ENDPOINT = "\(URL_TENANT)/\(URL_PATH)/users/%i/photo"
var GET_GALLERY_PHOTO_ENDPOINT = "\(URL_TENANT)/\(URL_PATH)/contents/%i"
var UPLOAD_CONTENT = "\(URL_TENANT)/\(URL_PATH)/contents"
let ADD_CONTENT_TO_LIBRARY_ENDPOINT = "\(URL_TENANT)/\(URL_PATH)/galleries/mine/entries"
let REMOVE_CONTENT_FROM_LIBRARY_ENDPOINT = "\(URL_TENANT)/\(URL_PATH)/galleries/mine/entries/%i"
let GET_GROUPS_USER_ENDPOINT = "\(URL_TENANT)/\(URL_PATH)/users/me/groups"
var GET_GROUP_PHOTO_ENDPOINT = "\(URL_TENANT)/\(URL_PATH)/groups/%i/photo"
let GET_CIRCLES_USER_VINCULAT_ENDPOINT = "\(URL_TENANT)/\(URL_PATH)/users/me/circles"
var GET_USER_BASIC_INFO = "\(URL_TENANT)/\(URL_PATH)/users/%i/basic"
var GET_USER_FULL_INFO = "\(URL_TENANT)/\(URL_PATH)/users/%i/full"
let GENERATE_CODE_ENDPOINT = "\(URL_TENANT)/\(URL_PATH)/circles/mine/codes"
let ADD_CODE_ENDPOINT = "\(URL_TENANT)/\(URL_PATH)/circles/users"
let REMOVE_CONTACT_ENDPOINT = "\(URL_TENANT)/\(URL_PATH)/circles/mine/users/%i"
let REMOVE_CONTACT_VINCULAT_ENDPOINT = "\(URL_TENANT)/\(URL_PATH)/circles/%i/user/me"
let CHANGE_USER_PHOTO = "\(URL_TENANT)/\(URL_PATH)/users/me/photo"
let SHARE_CONTENT_USERS = "\(URL_TENANT)/\(URL_PATH)/community/message"
let GET_INSTALLATIONS = "\(URL_TENANT)/\(URL_PATH)/device-installations/mine"
let SEND_INSTALLATION = "\(URL_TENANT)/\(URL_PATH)/device-installations"
let UPDATE_INSTALLATION = "\(URL_TENANT)/\(URL_PATH)/device-installations/%i"
let SEND_USER_TEXT_MESSAGE = "\(URL_TENANT)/\(URL_PATH)/messages"
let CHAT_USER_GET_MESSAGES = "\(URL_TENANT)/\(URL_PATH)/messages/mine"
let GET_NOTIFICATIONS = "\(URL_TENANT)/\(URL_PATH)/device/notifications"
let GET_NOTIFICATION_ID = "\(URL_TENANT)/\(URL_PATH)/device/notifications/%i"
let CHAT_USER_GET_MESSAGE_ID = "\(URL_TENANT)/\(URL_PATH)/messages/%i"
let CHAT_USER_GET_ALL_MESSAGES = "\(URL_TENANT)/\(URL_PATH)/messages/chat/%i"
let MARK_MESSAGE_WATCHED = "\(URL_TENANT)/\(URL_PATH)/messages/%i/watched"
let GET_GROUP_CHAT_MESSAGES = "\(URL_TENANT)/\(URL_PATH)/chats/%i/messages"
let SEND_GROUP_TEXT_MESSAGE = "\(URL_TENANT)/\(URL_PATH)/chats/%i/messages"
let CHAT_GROUP_GET_MESSAGE_ID = "\(URL_TENANT)/\(URL_PATH)/chats/%i/messages/%i"
let GET_GROUP_CHAT_CONTENT = "\(URL_TENANT)/\(URL_PATH)/chats/%i/messages/%i/content"
let GET_SERVER_TIME = "\(URL_TENANT)/\(URL_PATH)/public/time/current"
let GET_GROUP_PARTICIPANTS = "\(URL_TENANT)/\(URL_PATH)/groups/%i/users"
let GET_MEETINGS = "\(URL_TENANT)/\(URL_PATH)/schedule/meeting"
let CREATE_MEETING = "\(URL_TENANT)/\(URL_PATH)/schedule/meeting"
let GET_USER_EVENT_PROFILE_PHOTO = "\(URL_TENANT)/\(URL_PATH)/schedule/meeting/%i/guest/%i/photo"
let ACCEPT_INVITATION_MEETING = "\(URL_TENANT)/\(URL_PATH)/schedule/meeting/%i/accept/true"
let DECLINE_INVITATION_MEETING = "\(URL_TENANT)/\(URL_PATH)/schedule/meeting/%i/accept/false"
let DELETE_MEETING = "\(URL_TENANT)/\(URL_PATH)/schedule/meeting/%i"
let EDIT_MEETING = "\(URL_TENANT)/\(URL_PATH)/schedule/meeting/%i"
let GET_MEETING = "\(URL_TENANT)/\(URL_PATH)/schedule/meeting/%i"
let GET_SPECIFIC_CONTENT = "\(URL_TENANT)/\(URL_PATH)/galleries/mine/entries/%i"
let START_VIDEOCONFERENCE = "\(URL_TENANT)/\(URL_PATH)/videoconference/start"
let ERROR_VIDEOCONFERENCE = "\(URL_TENANT)/\(URL_PATH)/videoconference/error"
let SEND_INVITATION_FROM_GROUP = "\(URL_TENANT)/\(URL_PATH)/groups/%i/users/%i/invite"
let USER_CHANGE_PASSWORD = "\(URL_TENANT)/\(URL_PATH)/users/me/password"
let SEND_MIGRATION_STATUS = "\(URL_TENANT)/\(URL_PATH)/migration/status"
let CHAT_LAST_ACCESS = "\(URL_TENANT)/\(URL_PATH)/chats/%i/lastAccess"
let POST_DATA_USAGE = "\(URL_TENANT)/\(URL_PATH)/consume"


// NOTIFICATION TYPE
let NOTI_NEW_CHAT_MESSAGE = "NEW_CHAT_MESSAGE"
let NOTI_NEW_MESSAGE = "NEW_MESSAGE"
let NOTI_USER_UNLINKED = "USER_UNLINKED"
let NOTI_USER_LINKED = "USER_LINKED"
let NOTI_USER_LEFT_CIRCLE = "USER_LEFT_CIRCLE"
let NOTI_ADDED_TO_GROUP = "ADDED_TO_GROUP"
let NOTI_REMOVED_FROM_GROUP = "REMOVED_FROM_GROUP"
let NOTI_USER_UPDATED = "USER_UPDATED"
let NOTI_NEW_USER_GROUP = "NEW_USER_GROUP"
let NOTI_REMOVED_USER_GROUP = "REMOVED_USER_GROUP"
let NOTI_GROUP_UPDATED = "GROUP_UPDATED"
let NOTI_MEETING_INVITATION_EVENT = "MEETING_INVITATION_EVENT"
let NOTI_MEETING_ACCEPTED_EVENT = "MEETING_ACCEPTED_EVENT"
let NOTI_MEETING_REJECTED_EVENT = "MEETING_REJECTED_EVENT"
let NOTI_MEETING_CHANGED_EVENT = "MEETING_CHANGED_EVENT"
let NOTI_MEETING_INVITATION_REVOKE_EVENT = "MEETING_INVITATION_REVOKE_EVENT"
let NOTI_MEETING_INVITATION_DELETED_EVENT = "MEETING_INVITATION_DELETED_EVENT"
let NOTI_MEETING_DELETED_EVENT = "MEETING_DELETED_EVENT"
let NOTI_MEETING_INVITATION_ADDED_EVENT = "MEETING_INVITATION_ADDED_EVENT"
let NOTI_INCOMING_CALL = "INCOMING_CALL"
let NOTI_GROUP_USER_INVITATION_CIRCLE = "GROUP_USER_INVITATION_CIRCLE"
let NOTI_NEW_PHOTO_CHAT = "NEW_PHOTO_CHAT"
let NOTI_FAKE_REMINDER_EVENT = "FAKE_REMINDER_EVENT"
let NOTI_ERROR_IN_CALL = "ERROR_IN_CALL"
let NOTI_TOKEN_EXPIRED = "NOTI_TOKEN_EXPIRED"
let NOTI_FINISH_CALL = "NOTI_FINISH_CALL"
let NOTI_START_CALL = "NOTI_START_CALL"

let NOTI_CONTENT_ADDED_TO_GALLERY = "CONTENT_ADDED_TO_GALLERY"

let NOTIFICATION_PROCESSED =  "NOTIFICATION_PROCESSED"
let CALL_FINISHED =  "CALL_FINISHED"

let SMALL_FONT_CHAT =  12.0
let MEDIUM_FONT_CHAT =  15.0
let BIG_FONT_CHAT =  19.0
let MEDIUM_FONT_AGENDA =  17.0

let ANALYTICS_HOME = "Inici"
let ANALYTICS_CALL = "Vídeo-trucada"
let ANALYTICS_NOTIFICATIONS = "Avisos"
let ANALYTICS_CONTACTS = "Contactes"
let ANALYTICS_ADD_CONTACTS = "Afegir contactes"
let ANALYTICS_GALLERY = "Fotos i Vídeos"
let ANALYTICS_GALLERY_DETAIL = "Fotos i Vídeos: detall"
let ANALYTICS_GALLERY_SHARE = "Fotos i Vídeos: compartir"
let ANALYTICS_CONFIGURATION = "Configuració"
let ANALYTICS_CONFIGURATION_PERSONAL_DATA = "Editar perfil"
let ANALYTICS_AGENDA = "Agenda"
let ANALYTICS_AGENDA_NEW_EVENT = "Crear nova cita de l'agenda"
let ANALYTICS_AGENDA_EVENT_DETAIL = "Detall de cita de l'agenda"
let ANALYTICS_CHAT = "Chat"
let ANALYTICS_GROUP_INFO = "Grups: detall de grup"
let ANALYTICS_SPLASH = "Splash screen"
let ANALYTICS_LOGIN = "Login"
let ANALYTICS_REGISTER = "Nou registre"
let ANALYTICS_TERMS = "Termes i condicions"
let ANALYTICS_FORGOT_PASSWORD = "Recuperació de contrasenya"
let ANALYTICS_REGISTER_VALIDATE = "Validació d'usuari registrat"
let ANALYTICS_ABOUT = "Sobre Vincles BCN"
let ANALYTICS_TOUR = "Tour"
var GA_TRACKING = ""

//RELATIONSHIPS
let RELATION_PARTNER = "PARTNER"
let RELATION_CHILD = "CHILD"
let RELATION_GRANDCHILD = "GRANDCHILD"
let RELATION_CAREGIVER = "CAREGIVER"
let RELATION_FRIEND = "FRIEND"
let RELATION_VOLUNTEER = "VOLUNTEER"
let RELATION_BROTHER = "SIBLING"
let RELATION_NEPHEW = "NEPHEW"
let RELATION_OTHER = "OTHER"

let TOKEN_FAIL = "401"

// DATA CONSUMPTION
let DATA_CONSUMPTION_LOGIN = "LoginRequest"
let DATA_CONSUMPTION_SHARE_CONTENT = "SendMessageMulticastRequest"
let DATA_CONSUMPTION_MIGRATION = "MigrationPostLogin"
let DATA_CONSUMPTION_RECOVER_PASSWORD = "RecoverPasswordRequest"
let DATA_CONSUMPTION_REGISTER = "RegisterUserRequest"
let DATA_CONSUMPTION_VALIDATE_REGISTER = "ValidateNewUserRequest"
let DATA_CONSUMPTION_LOGOUT = "LogoutRequest"
let DATA_CONSUMPTION_GET_USER_SELF_INFO = "GetAuthenticatedUserDataRequest"
let DATA_CONSUMPTION_GET_USER_SELF_INFO_NO_VALIDATION = "GetPublicUserDataRequest"
let DATA_CONSUMPTION_GET_CIRCLES = "GetUserCircleRequest"
let DATA_CONSUMPTION_GET_CIRCLES_USER_VINCULAT = "GetCircleUserRequest"
let DATA_CONSUMPTION_ADD_CONTENT_TO_LIBRARY = "AddContentInTheGallery"
let DATA_CONSUMPTION_REMOVE_CONTENT_FROM_LIBRARY = "DeleteGalleryContentRequest"
let DATA_CONSUMPTION_GET_GROUPS_USER = "GetUserGroupsRequest"
let DATA_CONSUMPTION_GENERATE_CODE = "GenerateUserCodeRequest"
let DATA_CONSUMPTION_ADD_CODE = "AddUserRequest"
let DATA_CONSUMPTION_REMOVE_CONTACT = "ExitCircleRequest"
let DATA_CONSUMPTION_REMOVE_CONTACT_FROM_VINCULAT = "DeleteCircleRequest"
let DATA_CONSUMPTION_DOWNLOAD_PROFILE_PICTURE = "GetUserPhotoRequest"
let DATA_CONSUMPTION_DOWNLOAD_PROFILE_PICTURE_EVENT = "GetMeetingUserPhotoRequest"
let DATA_CONSUMPTION_DOWNLOAD_GROUP_PICTURE = "GetGroupPhotoRequest"
let DATA_CONSUMPTION_DOWNLOAD_GALLERY_PICTURE = "GetGalleryContentRequest"
let DATA_CONSUMPTION_DOWNLOAD_GALLERY_VIDEO = "GetGalleryContentRequest"
let DATA_CONSUMPTION_DOWNLOAD_CHAT_MEDIA_ITEM = "GetGalleryContentRequest"
let DATA_CONSUMPTION_SEND_USER_MESSAGE = "SendMessageRequest"
let DATA_CONSUMPTION_GET_CHAT_USER_MESSAGES = "GetUserMessagesRequest"
let DATA_CONSUMPTION_GET_CHAT_GROUP_MESSAGES = "GetGroupMessagesRequest"
let DATA_CONSUMPTION_GET_NOTIFICATIONS = "GetNotificationsRequest"
let DATA_CONSUMPTION_GET_NOTIFICATION = "GetNotificationRequest"
let DATA_CONSUMPTION_GET_MESSAGE = "GetMessageRequest"
let DATA_CONSUMPTION_MARK_MESSAGE_WATCHED = "SetMessageWatchedRequest"
let DATA_CONSUMPTION_SEND_GROUP_MESSAGE = "SendGroupMessageRequest"
let DATA_CONSUMPTION_GET_GROUP_MESSAGE = "GetGroupMessageRequest"
let DATA_CONSUMPTION_DOWNLOAD_GROUP_CHAT_MEDIA_ITEM = "GetGroupMessageFileRequest"
let DATA_CONSUMPTION_GET_USER_FULL_INFO = "GetUserDataRequest"
let DATA_CONSUMPTION_GET_SERVER_TIME = "GetServerTimeRequest"
let DATA_CONSUMPTION_GET_GROUP_PARTICIPANTS = "GetGroupUserListRequest"
let DATA_CONSUMPTION_GET_MEETINGS = "GetMeetingsRequest"
let DATA_CONSUMPTION_GET_MEETING = "GetMeetingRequest"
let DATA_CONSUMPTION_CREATE_MEETING = "SendMeetingRequest"
let DATA_CONSUMPTION_EDIT_MEETING = "SendMeetingRequest"
let DATA_CONSUMPTION_UPDATE_USER = "UpdateUserRequest"
let DATA_CONSUMPTION_ACCEPT_EVENT_INVITATION = "AcceptDeclineMeetingRequest"
let DATA_CONSUMPTION_DECLINE_EVENT_INVITATION = "AcceptDeclineMeetingRequest"
let DATA_CONSUMPTION_DELETE_MEETING = "DeleteMeetingRequest"
let DATA_CONSUMPTION_GET_SPECIFIC_CONTENT = "GetContentInMyGallery"
let DATA_CONSUMPTION_START_VIDEOCONFERENCE = "StartVideoconferenceRequest"
let DATA_CONSUMPTION_ERROR_VIDEOCONFERENCE = "ErrorVideoconferenceRequest"
let DATA_CONSUMPTION_INVITE_USER_FROM_GROUP = "GroupInviteUserToCircle"
let DATA_CONSUMPTION_GET_CHAT_LAST_ACCESS = "GetGroupLastAccessRequest"
let DATA_CONSUMPTION_PUT_CHAT_LAST_ACCESS = "PutGroupLastAccessRequest"
let DATA_CONSUMPTION_CHANGE_PASSWORD = "ChangePasswordRequest"
let DATA_CONSUMPTION_START_API_CALL = "StartVideoconferenceRequest"
let DATA_CONSUMPTION_UPLOAD_AUDIO = "GalleryAddContentRequest"
let DATA_CONSUMPTION_UPLOAD_IMAGE = "GalleryAddContentRequest"
let DATA_CONSUMPTION_UPLOAD_VIDEO = "GalleryAddContentRequest"
let DATA_CONSUMPTION_REFRESH_TOKEN = "RenewTokenRequest"
let DATA_CONSUMPTION_GET_CONTENTS_LIBRARY = "GetGalleryContentsRequest"

