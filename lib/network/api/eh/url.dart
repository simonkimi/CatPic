class EhUrl {
  static const SITE_E = 0;
  static const SITE_EX = 1;

  static const DOMAIN_EX = "exhentai.org";
  static const DOMAIN_E = "e-hentai.org";
  static const DOMAIN_LOFI = "lofi.e-hentai.org";

  static const HOST_EX = "https://" + DOMAIN_EX + "/";
  static const HOST_E = "https://" + DOMAIN_E + "/";

  static const API_SIGN_IN = "https://forums.e-hentai.org/index.php?act=Login&CODE=01";

  static const API_E = HOST_E + "api.php";
  static const API_EX = HOST_EX + "api.php";

  static const URL_POPULAR_E = "https://e-hentai.org/popular";
  static const URL_POPULAR_EX = "https://exhentai.org/popular";

  static const URL_IMAGE_SEARCH_E = "https://upload.e-hentai.org/image_lookup.php";
  static const URL_IMAGE_SEARCH_EX = "https://exhentai.org/upload/image_lookup.php";

  static const URL_SIGN_IN = "https://forums.e-hentai.org/index.php?act=Login";
  static const URL_REGISTER = "https://forums.e-hentai.org/index.php?act=Reg&CODE=00";
  static const URL_FAVORITES_E = HOST_E + "favorites.php";
  static const URL_FAVORITES_EX = HOST_EX + "favorites.php";
  static const URL_FORUMS = "https://forums.e-hentai.org/";

  static const REFERER_EX = "https://" + DOMAIN_EX;
  static const REFERER_E = "https://" + DOMAIN_E;

  static const ORIGIN_EX = REFERER_EX;
  static const ORIGIN_E = REFERER_E;

  static const URL_WATCHED_E = HOST_E + "watched";
  static const URL_WATCHED_EX = HOST_EX + "watched";

  static const URL_PREFIX_THUMB_E = "https://ehgt.org/";

  static const URL_PREFIX_THUMB_EX = "https://exhentai.org/t/";
}
