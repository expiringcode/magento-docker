vcl 4.0;

backend default {
  .host = "nginx";
  .port = "80";
  .first_byte_timeout = 600s;
}
