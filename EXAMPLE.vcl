# ===========================================================================
# START EXAMPLE DETECTION CODE but very similar to Acquia Cloud !!!!!!!!!!!
#
# Routine to identify and classify a device based on User-Agent
# ===========================================================================
sub identify_device {
  unset req.http.X-UA-Device;
  	set req.http.X-UA-Device = "pc";

  	# Handle that a cookie may override the detection alltogether.
  	if (req.http.Cookie ~ "(?i)X-UA-Device-force") {
  		/* ;?? means zero or one ;, non-greedy to match the first. */
  		set req.http.X-UA-Device = regsub(req.http.Cookie, "(?i).*X-UA-Device-force=([^;]+);??.*", "\1");
  		/* Clean up our mess in the cookie header */
  		set req.http.Cookie = regsuball(req.http.Cookie, "(^|; ) *X-UA-Device-force=[^;]+;? *", "\1");
  		/* If the cookie header is now empty, or just whitespace, unset it. */
  		if (req.http.Cookie ~ "^ *$") { unset req.http.Cookie; }
  	} else {
  		if (req.http.User-Agent ~ "(?i)(ads|google|bing|msn|yandex|baidu|ro|career|)bot" ||
  		    req.http.User-Agent ~ "(?i)(baidu|jike|symantec)spider" ||
  		    req.http.User-Agent ~ "(?i)scanner" ||
  		    req.http.User-Agent ~ "(?i)(web)crawler") {
  			set req.http.X-UA-Device = "bot"; }
  		elsif (req.http.User-Agent ~ "(?i)ipad")        { set req.http.X-UA-Device = "tablet-ipad"; }
  		elsif (req.http.User-Agent ~ "(?i)ip(hone|od)") { set req.http.X-UA-Device = "mobile-iphone"; }
  		/* how do we differ between an android phone and an android tablet?
  		   http://stackoverflow.com/questions/5341637/how-do-detect-android-tablets-in-general-useragent */
  		elsif (req.http.User-Agent ~ "(?i)android.*(mobile|mini)") { set req.http.X-UA-Device = "mobile-android"; }
  		// android 3/honeycomb was just about tablet-only, and any phones will probably handle a bigger page layout.
  		elsif (req.http.User-Agent ~ "(?i)android 3")              { set req.http.X-UA-Device = "tablet-android"; }
  		/* see http://my.opera.com/community/openweb/idopera/ */
  		elsif (req.http.User-Agent ~ "Opera Mobi")                  { set req.http.X-UA-Device = "mobile-smartphone"; }
  		// May very well give false positives towards android tablets. Suggestions welcome.
  		elsif (req.http.User-Agent ~ "(?i)android")         { set req.http.X-UA-Device = "tablet-android"; }
  		elsif (req.http.User-Agent ~ "PlayBook; U; RIM Tablet")         { set req.http.X-UA-Device = "tablet-rim"; }
  		elsif (req.http.User-Agent ~ "hp-tablet.*TouchPad")         { set req.http.X-UA-Device = "tablet-hp"; }
  		elsif (req.http.User-Agent ~ "Kindle/3")         { set req.http.X-UA-Device = "tablet-kindle"; }
  		elsif (req.http.User-Agent ~ "Mobile.+Firefox")     { set req.http.X-UA-Device = "mobile-firefoxos"; }
  		elsif (req.http.User-Agent ~ "^HTC" ||
  		    req.http.User-Agent ~ "Fennec" ||
  		    req.http.User-Agent ~ "IEMobile" ||
  		    req.http.User-Agent ~ "BlackBerry" ||
  		    req.http.User-Agent ~ "BB10.*Mobile" ||
  		    req.http.User-Agent ~ "GT-.*Build/GINGERBREAD" ||
  		    req.http.User-Agent ~ "SymbianOS.*AppleWebKit") {
  			set req.http.X-UA-Device = "mobile-smartphone";
  		}
  		elsif (req.http.User-Agent ~ "(?i)symbian" ||
  		    req.http.User-Agent ~ "(?i)^sonyericsson" ||
  		    req.http.User-Agent ~ "(?i)^nokia" ||
  		    req.http.User-Agent ~ "(?i)^samsung" ||
  		    req.http.User-Agent ~ "(?i)^lg" ||
  		    req.http.User-Agent ~ "(?i)bada" ||
  		    req.http.User-Agent ~ "(?i)blazer" ||
  		    req.http.User-Agent ~ "(?i)cellphone" ||
  		    req.http.User-Agent ~ "(?i)iemobile" ||
  		    req.http.User-Agent ~ "(?i)midp-2.0" ||
  		    req.http.User-Agent ~ "(?i)u990" ||
  		    req.http.User-Agent ~ "(?i)netfront" ||
  		    req.http.User-Agent ~ "(?i)opera mini" ||
  		    req.http.User-Agent ~ "(?i)palm" ||
  		    req.http.User-Agent ~ "(?i)nintendo wii" ||
  		    req.http.User-Agent ~ "(?i)playstation portable" ||
  		    req.http.User-Agent ~ "(?i)portalmmm" ||
  		    req.http.User-Agent ~ "(?i)proxinet" ||
  		    req.http.User-Agent ~ "(?i)sonyericsson" ||
  		    req.http.User-Agent ~ "(?i)symbian" ||
  		    req.http.User-Agent ~ "(?i)windows\ ?ce" ||
  		    req.http.User-Agent ~ "(?i)winwap" ||
  		    req.http.User-Agent ~ "(?i)eudoraweb" ||
  		    req.http.User-Agent ~ "(?i)htc" ||
  		    req.http.User-Agent ~ "(?i)240x320" ||
  		    req.http.User-Agent ~ "(?i)avantgo") {
  			set req.http.X-UA-Device = "mobile-generic";
  		}
  	}
}
# ===========================================================================
# END EXAMPLE CODE !!!!!!!!!!!
# ===========================================================================


# Default internal definition.
acl internal {
  "localhost";
  "127.0.0.1";
}

# Default backend definition. Set this to point to your content server.
backend default {
  .host = "127.0.0.1";
  .port = "80";
}

# Respond to incoming requests.
sub vcl_recv {
  # call some detection engine that set req.http.X-UA-Device
  call identify_device;

  # allow PURGE from localhost
  if (req.request == "PURGE") {
    if (!client.ip ~ internal) {
      error 405 "Not allowed.";
    }
    return (lookup);
  }

  if (req.http.x-forwarded-for) {
    set req.http.X-Forwarded-For = req.http.X-Forwarded-For + ", " + client.ip;#
  }
  else {
    set req.http.X-Forwarded-For = client.ip;
  }

  # Use anonymous, cached pages if all backends are down.
  if (!req.backend.healthy) {
    unset req.http.Cookie;
  }

  # Allow the backend to serve up stale content if it is responding slowly.
  set req.grace = 6h;

  # Pipe these paths directly to Apache for streaming.
  if (req.url ~ "^.*/admin/content/backup_migrate/export") {
    return (pipe);
  }

  # Do not cache these paths.
  if (req.url ~ "^/status\.php$" ||
      req.url ~ "^/update\.php$" ||
      req.url ~ "^.*/admin$" ||
      req.url ~ "^.*/admin/.*$" ||
      req.url ~ "^.*/nodequeue/.*$" ||
      req.url ~ "^.*/batch$" ||
      req.url ~ "^.*/flag/.*$" ||
      req.url ~ "^.*/ajax/.*$" ||
      req.url ~ "^.*/ahah/.*$" ||
      req.url ~ "^.*/search/.*$" ||
      req.url ~ "^.*/media/.*$") {
    return (pass);
  }

  # Do not allow outside access to cron.php or install.php.
  if (req.url ~ "^/(cron|install)\.php$" && !client.ip ~ internal) {
    # Have Varnish throw the error directly.
    error 404 "Page not found.";
    # Use a custom error page that you've defined in Drupal at the path "404".
     set req.url = "/404";
  }

  # Always cache the following file types for all users. This list of extensions
  # appears twice, once here and again in vcl_fetch so make sure you edit both
  # and keep them equal.
  if (req.url ~ "(?i)\.(pdf|asc|dat|txt|doc|xls|ppt|tgz|csv|png|gif|jpeg|jpg|ico|swf|css|js)(\?.*)?$") {
    unset req.http.Cookie;
  }

  # Remove all cookies that Drupal doesn't need to know about. We explicitly
  # list the ones that Drupal does need, the SESS and NO_CACHE. If, after
  # running this code we find that either of these two cookies remains, we
  # will pass as the page cannot be cached.
  if (req.http.Cookie) {
    # 1. Append a semi-colon to the front of the cookie string.
    # 2. Remove all spaces that appear after semi-colons.
    # 3. Match the cookies we want to keep, adding the space we removed
    #    previously back. (\1) is first matching group in the regsuball.
    # 4. Remove all other cookies, identifying them by the fact that they have
    #    no space after the preceding semi-colon.
    # 5. Remove all spaces and semi-colons from the beginning and end of the
    #    cookie string.
    set req.http.Cookie = ";" + req.http.Cookie;
    set req.http.Cookie = regsuball(req.http.Cookie, "; +", ";");
    set req.http.Cookie = regsuball(req.http.Cookie, ";(SESS[a-z0-9]+|SSESS[a-z0-9]+|NO_CACHE|USE_DESKTOP)=", "; \1=");
    set req.http.Cookie = regsuball(req.http.Cookie, ";[^ ][^;]*", "");
    set req.http.Cookie = regsuball(req.http.Cookie, "^[; ]+|[; ]+$", "");

    if (req.http.Cookie == "") {
      # If there are no remaining cookies, remove the cookie header. If there
      # aren't any cookie headers, Varnish's default behavior will be to cache
      # the page.
      unset req.http.Cookie;
    }
    else {
      # If there is any cookies left (a session or NO_CACHE cookie), do not
      # cache the page. Pass it on to Apache directly.
      return (pass);
    }
  }
}

sub vcl_hash {
  # If the device has been classified as any sort of mobile device, include the User-Agent in the hash
  # However, do not do this for any static assets as our web application returns the same ones for every device.
  if (!(req.url ~ ".(gif|jpg|jpeg|swf|flv|mp3|mp4|pdf|ico|png|gz|tgz|bz2)(\?.*)$")) {
    hash_data(req.http.X-UA-Device);
  }
}

sub vcl_pass {
  if (!req.http.Cookie) {
    set bereq.http.Cookie = "has_js=1";
  }
}

sub vcl_hit {
  if (req.request == "PURGE") {
    purge;
    error 200 "Purged.";
  }
}

sub vcl_miss {
  if (req.request == "PURGE") {
    purge;
    error 200 "Purged.";
  }
  if (!req.http.Cookie) {
    set bereq.http.Cookie = "has_js=1";
  }
}


# Set a header to track a cache HIT/MISS.
sub vcl_deliver {
  if (obj.hits > 0) {
    set resp.http.X-Varnish-Cache = "HIT";
  }
  else {
    set resp.http.X-Varnish-Cache = "MISS";
  }
  # to keep any caches in the wild from serving wrong content to client #2
  # behind them, we need to transform the Vary on the way out.
  if ((req.http.X-UA-Device) && (resp.http.Vary)) {
    set resp.http.Vary = regsub(resp.http.Vary, "X-UA-Device", "User-Agent");
  }
}

# Code determining what to do when serving items from the Apache servers.
# beresp == Back-end response from the web server.
sub vcl_fetch {
  # We need this to cache 404s, 301s, 500s. Otherwise, depending on backend but
  # definitely in Drupal's case these responses are not cacheable by default.
  if(beresp.status == 500) {
    set beresp.ttl = 5m;
    error 520 "Unknown error occured";
  }
  else if (beresp.status > 500) {
    set beresp.ttl = 0s;
  }
  else if (beresp.ttl < 48h) {
    set beresp.ttl = 48h;
  }
  # Don't allow static files to set cookies.
  # (?i) denotes case insensitive in PCRE (perl compatible regular expressions).
  # This list of extensions appears twice, once here and again in vcl_recv so
  # make sure you edit both and keep them equal.
  if (req.url ~ "(?i)\.(pdf|asc|dat|txt|doc|xls|ppt|tgz|csv|png|gif|jpeg|jpg|ico|swf|css|js)(\?.*)?$") {
    unset beresp.http.set-cookie;
  }

  # Allow items to be stale if needed.
  set beresp.grace = 6h;

  # Pass on our custom device header to the backend.
  if (bereq.http.X-UA-Device) {
    if (!beresp.http.Vary) { # no Vary at all
      set beresp.http.Vary = "X-UA-Device";
    } elseif (beresp.http.Vary !~ "X-UA-Device") { # add to existing Vary
      set beresp.http.Vary = beresp.http.Vary + ", X-UA-Device";
    }
  }
  # comment this out if you don't want the client to know your
  # classification
  set beresp.http.X-UA-Device = bereq.http.X-UA-Device;

  # Set the clients TTL on this object
  #set beresp.http.cache-control = "max-age=60";
  set beresp.http.cache-control = regsuball(beresp.http.cache-control, "max-age=([a-z0-9]+)", "max-age=60");
}


sub vcl_error {
  # Redirect to some other URL in the case of a homepage failure.
    #if (req.url ~ "^/?$") {
    #  set obj.status = 302;
    #  set obj.http.Location = "http://backup.example.com/";
    #}

    # Otherwise redirect to the homepage, which will likely be in the cache.
    set obj.http.Content-Type = "text/html; charset=utf-8";
    synthetic {"
  <html>
  <head>
    <title>Page Unavailable</title>
    <style>
      body { background: #303030; text-align: center; color: white; }
      #page { border: 1px solid #CCC; width: 500px; margin: 100px auto 0; padding: 30px; background: #323232; }
      a, a:link, a:visited { color: #CCC; }
      .error { color: #222; }
    </style>
  </head>
  <body onload="setTimeout(function() { window.location = '/' }, 5000)">
    <div id="page">
      <h1 class="title">Page Unavailable</h1>
      <p>The page you requested is temporarily unavailable.</p>
      <p>We're redirecting you to the <a href="/">homepage</a> in 5 seconds.</p>
      <div class="error">(Error "} + obj.status + " " + obj.response + {")</div>
    </div>
  </body>
  </html>
  "};
    return (deliver);
}
