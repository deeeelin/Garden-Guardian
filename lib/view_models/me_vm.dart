import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/models/appUser.dart';
import 'package:flutter_app/repositories/appUser_repo.dart';

class MeViewModel with ChangeNotifier {
  final AppUserRepository _appUserRepository;
  late StreamSubscription<appUser?> _meSubscription;

  appUser? _me;
  appUser? get me => _me;
  bool _isInitializing = true;
  bool get isInitializing => _isInitializing;

  MeViewModel(String appUserId, {AppUserRepository? appUserRepository})
      : _appUserRepository = appUserRepository ?? AppUserRepository() {
    _meSubscription = _appUserRepository.streamUser(appUserId).listen((me) {
      if (me == null) {
        return;
      }

      _isInitializing = false;
      _me = me;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _meSubscription.cancel();
    super.dispose();
  }

  Future<void> addMe(appUser me) async {
    await _appUserRepository.createOrUpdateUser(me);
  }
}
