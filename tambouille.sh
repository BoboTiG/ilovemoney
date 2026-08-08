#!/bin/bash

set -eu

alter_readme() {
    cat > README.md <<EOF
# I Love Money

*I Love Money* is a web application made to ease shared budget management. It keeps track of who bought what, when, and for whom; and helps to settle the bills.

**Note**: This is a modified version of [I Hate Money](https://github.com/spiral-project/ihatemoney) only suitable for my needs:

- new project title: I Love Money
- adapted the logo
- removed the french showcase everywhere
- removed most of footer links
EOF
}

apply_diffs() {
    [ -d ihatemoney ] || return

    # Home: remove the showcase link
    /usr/bin/git apply <<'EOF'
diff --git a/ihatemoney/templates/home.html b/ihatemoney/templates/home.html
index f2c70d0..45b9944 100644
--- a/ihatemoney/templates/home.html
+++ b/ihatemoney/templates/home.html
@@ -9,13 +9,6 @@
             {{ _("Try out the demo") }}
         </a>
     {% endif %}
-    {% if g.lang == 'fr' %}
-        ou
-        <span class="side-to-side">
-          <a class="showcase btn" onclick="javascript:showGallery(); return false;">Voir la BD explicative</a>
-          <img class="showcaseimg" src="{{ url_for("static", filename='images/indicate.svg') }}" />
-        </span>
-    {% endif %}
   </div>
   <div class="col-xs-12 col-sm-4">
     <table class="additional-content"><tr>
EOF

    # General: remove the showcase link
    # General: rename the top-left "logo"
    # General: delete most of footer links
    /usr/bin/git apply <<'EOF'
diff --git a/ihatemoney/templates/layout.html b/ihatemoney/templates/layout.html
index 415113b..9815add 100644
--- a/ihatemoney/templates/layout.html
+++ b/ihatemoney/templates/layout.html
@@ -46,12 +46,11 @@
     </script>
 </head>
 <body class="d-flex flex-column h-100">
-  {% if g.lang == 'fr' %}{% include "showcase.html" %}{% endif %}
   <nav class="navbar navbar-expand-lg fixed-top navbar-dark bg-dark">
     <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarToggler" aria-controls="navbarToggler" aria-expanded="false" aria-label="Toggle navigation">
       <span class="navbar-toggler-icon"></span>
     </button>
-    <h1><a class="navbar-brand" href="{{ url_for("main.home") }}"><span>#!</span> money?</a></h1>
+    <h1><a class="navbar-brand" href="{{ url_for("main.home") }}"><span>I</span> ❤️ money!</a></h1>
 
     <div class="collapse navbar-collapse" id="navbarToggler">
       <ul class="navbar-nav nav-fill w-100">
@@ -158,15 +157,6 @@
       <div class="footer-limiter">
 
           <div class="footer-right">
-            <a target="_blank" rel="noopener" data-toggle="tooltip" data-placement="top" title="{{ _('Code') }}" href="https://github.com/spiral-project/ihatemoney">
-              <i class="icon git">{{ static_include("images/git.svg") | safe }}</i>
-            </a>
-            <a data-toggle="tooltip" data-placement="top" title="{{ _('Mobile Application') }}" href="{{url_for('main.mobile')}}">
-              <i class="icon mobile">{{ static_include("images/mobile-alt.svg") | safe }}</i>
-            </a>
-            <a target="_blank" rel="noopener" data-toggle="tooltip" data-placement="top" title="{{ _('Documentation') }}" href="https://ihatemoney.readthedocs.io/en/latest/">
-              <i class="icon book">{{ static_include("images/book.svg") | safe }}</i>
-            </a>
             {% if g.show_admin_dashboard_link %}
             <a target="_blank" rel="noopener" data-toggle="tooltip" data-placement="top" title="{{ _('Administration Dashboard') }}" href="{{ url_for('main.dashboard') }}">
               <i class="icon admin">{{ static_include("images/cog.svg") | safe }}</i>
EOF

    # Project: remove the showcase link
    /usr/bin/git apply <<'EOF'
diff --git a/ihatemoney/templates/list_bills.html b/ihatemoney/templates/list_bills.html
index 79e2526..631f5fa 100644
--- a/ihatemoney/templates/list_bills.html
+++ b/ihatemoney/templates/list_bills.html
@@ -64,12 +64,6 @@
         </div>
     </div>
     <div class="identifier">
-	{% if g.lang == 'fr' %}
-        <a class="btn btn-secondary btn-block" href=""  onclick="javascript:showGallery(); return false;">
-            <i class="icon icon-white high before-text">{{ static_include("images/read.svg") | safe }}</i>
-	    Voir la BD explicative
-        </a>
-	{% endif %}
         <a class="btn btn-secondary btn-block" href="{{ url_for('.invite') }}">
             <i class="icon icon-white high before-text">{{ static_include("images/paper-plane.svg") | safe }}</i>
             {{ _("Invite people") }}

EOF
}

more_ignored_files() {
    if ! /bin/grep -o 'ilovemoney.cfg' .gitignore >/dev/null; then
        echo -e 'app.py\nilovemoney.cfg\nilovemoney.sqlite\nvenv/' >> .gitignore
    fi
}

rename_project() {
    [ -d ihatemoney ] && /bin/mv -f ihatemoney ilovemoney
    /bin/find . \( -type d -name .git -prune -o -type d -name venv -prune  -o -type f -name 'tambouille.*' -prune  \) -o -type f -print0 | \
        /bin/xargs -0 /bin/sed -i 's/ihate/ilove/g ; s/Ihate/Ilove/g ; s/IHate/ILove/g ; s/I_HATE/I_LOVE/g ; s/IHATE/ILOVE/g ; s/I hate/I love/g ; s/I Hate/I Love/g ; s/-hate-/-love-/g ; s/spiral-project/BoboTiG/g'
    /bin/mv ilovemoney/static/js/ihatemoney.js ilovemoney/static/js/ilovemoney.js
    /bin/mv ilovemoney/conf-templates/ihatemoney.cfg.j2 ilovemoney/conf-templates/ilovemoney.cfg.j2
}

purge() {
    /bin/rm -rf \
        assets \
        ihatemoney/static/photoswipe \
        ihatemoney/static/showcase \
        ihatemoney/templates/showcase.html \
        ihatemoney/tests
}

vscode_settings() {
    [ -d .vscode ] || /bin/mkdir .vscode
    /bin/cat > .vscode/settings.json << EOF
{
    "editor.formatOnSave": false
}
EOF
}

main() {
    clear
    purge
    apply_diffs
    rename_project
    vscode_settings
    more_ignored_files
    alter_readme
}

main
