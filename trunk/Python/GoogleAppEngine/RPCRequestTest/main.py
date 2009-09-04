import wsgiref.handlers
import os

from django.utils import simplejson
from google.appengine.ext import webapp
from google.appengine.ext.webapp import template

class MainHandler(webapp.RequestHandler):
    def get(self):
        template_values = {"title":"AJAX Add (via GET)"}
        path = os.path.join(os.path.dirname(__file__), "index.html")
        self.response.out.write(template.render(path, template_values))

class RPCHandler(webapp.RequestHandler):
    def __init__(self):
        webapp.RequestHandler.__init__(self)
        self.methods = RPCMethods
        
    def get(self):
        func = None
        action = self.request.get("action")
        if action:
            if action[0] == "_":
                self.error(403)
                return
            else:
                func = getattr(self.methods, action, None)
                
        if not func:
            self.error(404)
            return
        
        args = ()
        while True:
            key = "arg%d" % len(args)
            val = self.request.get(key)
            if val:
                args += (simplejson.loads(val), )
            else:
                break
            
        result = func(*args)
        self.response.out.write(simplejson.dumps(result))
        
class RPCMethod:
    def Add(self, *args):
        ints = [int(arg) for arg in args]
        return sum(ints)

def main():
  application = webapp.WSGIApplication([('/', MainHandler)],
                                       debug=True)
  wsgiref.handlers.CGIHandler().run(application)


if __name__ == '__main__':
  main()
