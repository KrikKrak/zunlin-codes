from django.conf.urls.defaults import *
from FirstSite.view import *

# Uncomment the next two lines to enable the admin:
# from django.contrib import admin
# admin.autodiscover()

urlpatterns = patterns('',
                       ('^$', root_view),       # redirect to root
                       ('^hello/$', hello),     # redirect to /hello/
                       ('^browserInfo/$', browserInfo),
                       ('^contact/$', contact),
                       ('^curtime/$', curtime),
                       (r'^time/plus/(\d{1,2})/$', hours_ahead),
)