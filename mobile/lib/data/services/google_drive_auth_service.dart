import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;

class _GoogleAuthHttpClient extends http.BaseClient {
  final GoogleSignInAccount _account;
  final http.Client _inner = http.Client();

  _GoogleAuthHttpClient(this._account);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final headers = await _account.authHeaders;
    request.headers.addAll(headers);
    return _inner.send(request);
  }

  @override
  void close() => _inner.close();
}

class GoogleDriveAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [drive.DriveApi.driveFileScope],
  );

  GoogleSignInAccount? _account;
  _GoogleAuthHttpClient? _client;

  bool get isSignedIn => _account != null;
  String? get email => _account?.email;
  String? get displayName => _account?.displayName;
  String? get photoUrl => _account?.photoUrl;

  Future<void> signIn() async {
    _account = await _googleSignIn.signIn();
    if (_account != null) {
      _client = _GoogleAuthHttpClient(_account!);
    }
  }

  Future<void> signInSilently() async {
    _account = await _googleSignIn.signInSilently();
    if (_account != null) {
      _client = _GoogleAuthHttpClient(_account!);
    }
  }

  Future<void> signOut() async {
    _client?.close();
    _client = null;
    await _googleSignIn.signOut();
    _account = null;
  }

  http.Client? get client => _client;
}
