import wsgiref.handlers
import os

from django.utils import simplejson
from google.appengine.ext import webapp
from google.appengine.ext.webapp import template

class MainHandler(webapp.RequestHandler):
    def get(self):

        #self.response.out.write("body is:%s" % self.request.body)
        #self.response.out.write("remote_addr is:%s" % self.request.remote_addr)
        #self.response.out.write("url is:%s" % self.request.url)
        #self.response.out.write("path is:%s" % self.request.path)
        #self.response.out.write("headers is:%s" % self.request.headers)
        
        template_values = {}
        path = os.path.join(os.path.dirname(__file__), "flexrptclient.html")
        self.response.out.write(template.render(path, template_values))
        
        return
        
        template_values = {"title":"AJAX Add (via GET)"}
        path = os.path.join(os.path.dirname(__file__), "index.html")
        self.response.out.write(template.render(path, template_values))


class RPCHandler(webapp.RequestHandler):

    def post(self):
        clientName = self.request.get("client")
        userName = self.request.get("user");
        self.response.out.write("welcome to rpc. Client %s, User %s." % (clientName, userName))


def main():
  application = webapp.WSGIApplication([('/', MainHandler),('/rpc', RPCHandler),],
                                       debug=True)
  wsgiref.handlers.CGIHandler().run(application)


if __name__ == '__main__':
  main()
