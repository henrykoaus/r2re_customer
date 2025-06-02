// lib/env/env.dart
import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env.dev')
abstract class Env {
  @EnviedField(varName: 'kakao', obfuscate: true)
  static final String kakao = _Env.kakao;
  @EnviedField(varName: 'kakao_restapi', obfuscate: true)
  static final String kakao_restapi = _Env.kakao_restapi;
  @EnviedField(varName: 'naver_map', obfuscate: true)
  static final String naver_map = _Env.naver_map;
  @EnviedField(varName: 'naver_map_secret', obfuscate: true)
  static final String naver_map_secret = _Env.naver_map_secret;
  @EnviedField(varName: 'bootpay_web', obfuscate: true)
  static final String bootpay_web = _Env.bootpay_web;
  @EnviedField(varName: 'bootpay_android', obfuscate: true)
  static final String bootpay_android = _Env.bootpay_android;
  @EnviedField(varName: 'bootpay_ios', obfuscate: true)
  static final String bootpay_ios = _Env.bootpay_ios;
  @EnviedField(varName: 'googleAndroid', obfuscate: true)
  static final String googleAndroid = _Env.googleAndroid;
  @EnviedField(varName: 'googleIos', obfuscate: true)
  static final String googleIos = _Env.googleIos;
}
