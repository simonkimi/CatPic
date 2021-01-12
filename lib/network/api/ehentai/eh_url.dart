class EhUrl {
  static const SITE_E = 0;
  static const SITE_EX = 1;

  static const DOMAIN_E = 'e-hentai.org';
  static const DSN_E = '104.20.26.25';
  static const HOST_E = 'https://' + DOMAIN_E + '/';
  static const SNI_E = 'https://' + DSN_E + '/';

  static const DOMAIN_EX = 'exhentai.org';
  static const DSN_EX = '178.175.128.252';
  static const HOST_EX = 'https://$DOMAIN_EX/';
  static const SNI_EX = 'https://$DSN_EX/';

  static const API_E = HOST_E + 'api.php';
  static const API_EX = HOST_EX + 'api.php';

  static const URL_SIGN_IN = 'https://forums.e-hentai.org/index.php?act=Login';
}
