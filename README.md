## serendipity

This repository contains the Dockerfile to build an image for Serendipity
http://s9y.org/

The image uses PHP 5.6 and is based upon the official docker PHP image
https://hub.docker.com/_/php/

### Features

* Does not require URL rewriting when called via sub-uri

### Example

    docker run -e SERVER_NAME=www.example.com -e SERVER_ADMIN=webmaster@example.com SERENDIPITY_URI=/blog -e LOG_LEVEL=notice -e MAX_SIZE=1000 -p 127.0.0.1:8010:80 volkerwiegand/serendipity:2.0.2

### Environment variables

*SERVER_NAME*

  Usually the name of the host running Serendipity. Used for setting up Apache.

*SERVER_ADMIN*

  Also used for setting up Apache.

*SERENDIPITY_URI*

  This helps to call Serendipity as e.g. https://www.example.com/blog/
  See below for an Nginx configuration example.

*LOG_LEVEL*

  The apache log level (defaults to warn).

*MAX_SIZE*

  The value for memory_limit (only if larget than the default of 128),
  upload_max_filesize and post_max_size. Please enter the number only,
  as the "M" suffix will be appended automatically.

### Nginx example

The following snippet is an Nginx location block proxying
https://www.example.com/blog/ to the docker container
installed using the command line above.

    location /blog {
      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto $scheme;
      proxy_pass https://127.0.0.1:8010;
    }
 
