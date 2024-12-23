import 'package:rx_bloc_cli/src/extensions/string_extensions.dart';
import 'package:rx_bloc_cli/src/extensions/xml_extensions.dart';
import 'package:xml/xml.dart';

import '../common/abstract_processors.dart';

/// String processor used for processing of the AndroidManifest file located at:
/// {project_root}/android/app/src/main/AndroidManifest.xml
class AndroidManifestProcessor extends StringProcessor {
  /// Android manifest processor constructor
  AndroidManifestProcessor(super.args);

  @override
  String execute() {
    if (input == null) return '';
    final xmlDoc = XmlDocument.parse(input!);

    _setupMissingNodes(xmlDoc);
    _addDeepLinkingSupport(xmlDoc);

    if (args.pushNotificationsEnabled) {
      _addPushNotificationSupport(xmlDoc);
    }
    if (args.socialLoginsEnabled) {
      _addSocialLoginsSupport(xmlDoc);
    }
    if (args.pinCodeEnabled) {
      _addPinCodeSupport(xmlDoc);
    }
    if (args.qrScannerEnabled) {
      _addQrCodeSupport(xmlDoc);
    }

    return _parseToXmlString(xmlDoc);
  }

  /// region Private methods

  /// Converts the xml document to a prettified string following specified
  /// indentation rules.
  String _parseToXmlString(XmlDocument doc) => doc.toXmlString(
      pretty: true,
      indent: '    ',
      indentAttribute: (XmlAttribute xmlAttr) {
        if (xmlAttr.name.toString() == 'xmlns:android') return false;
        if (xmlAttr.value == 'android.intent.action.MAIN') return false;
        if (xmlAttr.value == 'android.intent.category.LAUNCHER') return false;
        if (xmlAttr.elementName == 'uses-permission') return false;
        if (xmlAttr.elementName == 'provider') return false;

        if (xmlAttr.elementName == 'intent-filter' ||
            xmlAttr.getAncestorWithName('intent-filter',
                    hasAttributes: ['android:autoVerify']) !=
                null) return false;

        return true;
      });

  /// Add missing nodes from generated structure
  void _setupMissingNodes(XmlDocument doc) {
    doc.addNodeToElement('manifest', '<queries></queries>'.toXmlNode());
  }

  void _addDeepLinkingSupport(XmlDocument doc) {
    final deeplinkMetadataNode =
        '<meta-data android:name="flutter_deeplinking_enabled"'
                ' android:value="true" />'
            .toXmlNode();
    var deeplinkIntent = '''
<intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="http" android:host="$packageId" />
    <data android:scheme="https" />''';

    if (args.onboardingEnabled) {
      deeplinkIntent += '''
    <data android:scheme="${args.projectName}"/>
    <data android:host="${args.projectName}"/>
    <data android:pathPattern="/onboarding/email-confirmed/.*" />
</intent-filter>
''';
    } else {
      deeplinkIntent += '''
</intent-filter>
''';
    }

    final mailtoIntent = '''<intent>
            <action android:name="android.intent.action.VIEW" />
            <category android:name="android.intent.category.BROWSABLE" />
            <data android:scheme="mailto" />
        </intent>'''
        .toXmlNode();

    doc
      ..addNodesToElement('activity', [
        XmlComment(' Deep links '),
        deeplinkMetadataNode,
        deeplinkIntent.toXmlNode(),
        XmlComment(' /Deep links '),
      ])
      ..addNodeToElement(
        'queries',
        mailtoIntent,
      );
  }

  void _addPushNotificationSupport(XmlDocument doc) {
    final notificationsComment =
        ' This tag below enables push notifications to be '
        'registered when app is in foreground ';
    final notificationsChannelNode = '''
    <meta-data
           android:name="com.google.firebase.messaging.default_notification_channel_id"
           android:value="high_importance_channel" />
    '''
        .toXmlNode();

    doc.addNodesToElement('application', [
      XmlComment(notificationsComment),
      notificationsChannelNode,
    ]);
  }

  void _addSocialLoginsSupport(XmlDocument doc) {
    final fbAppIdNode =
        '<meta-data android:name="com.facebook.sdk.ApplicationId" '
                'android:value="@string/facebook_app_id"/>'
            .toXmlNode();
    final fbClientTokenNode =
        '<meta-data android:name="com.facebook.sdk.ClientToken" '
                'android:value="@string/facebook_client_token"/>'
            .toXmlNode();
    final internetUPNode =
        '<uses-permission android:name="android.permission.INTERNET"/>'
            .toXmlNode();
    final fbProviderQueryNode = '<provider android:authorities='
            '"com.facebook.katana.provider.PlatformProvider" />'
        .toXmlNode();

    doc
      ..addNodeToElement('manifest', internetUPNode)
      ..addNodeToElement('queries', fbProviderQueryNode)
      ..addNodesToElement('application', [fbAppIdNode, fbClientTokenNode]);
  }

  void _addPinCodeSupport(XmlDocument doc) {
    final biometricsUPNode =
        '<uses-permission android:name="android.permission.USE_BIOMETRIC"/>'
            .toXmlNode();
    doc.addNodeToElement('manifest', biometricsUPNode);
  }

  void _addQrCodeSupport(XmlDocument doc) {
    final biometricsUPNode =
        '<uses-permission android:name="android.permission.CAMERA"/>'
            .toXmlNode();
    doc.addNodeToElement('manifest', biometricsUPNode);
  }

  /// endregion
}
