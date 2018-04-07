upstream eventlistenr_unicorn {
  # This is the socket we configured in unicorn.rb
  server unix:/tmp/sockets/unicorn.sock;
}

server {
  listen   80;
  client_max_body_size 4G;
  # server_name  *;

  root <%= node['eventlistenr']['path'] %>/public;
  access_log  <%= node['nginx']['log_dir'] %>/eventlistenr.access.log;

  location / {
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header Host $http_host;
    proxy_redirect off;

    # If you don't find the filename in the static files
    # Then request it from the unicorn server
    if (!-f $request_filename) {
      proxy_pass http://eventlistenr_unicorn;
      break;
    }
  }

  error_page 500 502 503 504 /500.html;
  location = /500.html {
    root <%= node['eventlistenr']['path'] %>/public;
  }
}
