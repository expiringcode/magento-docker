vcl 4.0;

backend default {
  .host = "nginx";
  .port = "80";
  .first_byte_timeout = 600s;
  .probe = {
    .url = "/pub/health_check.php";
    .timeout = 2s;
    .interval = 5s;
    .window = 10;
    .threshold = 5;
  }
}

acl purge {
  "localhost";
}
