import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens stores, web pages and the share sheet.
class LinkService {
  /// Opens the store app if it is installed, otherwise the browser.
  Future<bool> openExternal(String url) async {
    final uri = Uri.parse(url);
    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (error) {
      return false;
    }
  }

  Future<bool> openInApp(String url) async {
    try {
      return await launchUrl(Uri.parse(url), mode: LaunchMode.inAppBrowserView);
    } catch (error) {
      return false;
    }
  }

  Future<bool> email(String address, {String subject = ''}) async {
    final uri = Uri(scheme: 'mailto', path: address, query: 'subject=${Uri.encodeComponent(subject)}');
    try {
      return await launchUrl(uri);
    } catch (error) {
      return false;
    }
  }

  Future<void> share(String text) async {
    await SharePlus.instance.share(ShareParams(text: text));
  }
}
