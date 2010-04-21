import os
import wsgiref.handlers

from google.appengine.ext import webapp
from google.appengine.ext.webapp import template
from google.appengine.ext import db

class Welcome(webapp.RequestHandler):
  def get(self):
      userIP = self.request.remote_addr
      template_value = {"pageTitle": "Welcome to Family Recipe", "UserIP": userIP}
      path = os.path.join(os.path.dirname(__file__), "template/welcome.html")
      self.response.out.write(template.render(path, template_value))
      
      
class BrowseRecipe(webapp.RequestHandler):
    def get(self):
        template_value = {"pageTitle": "Browse Family Recipes"}
        path = os.path.join(os.path.dirname(__file__), "template/browse.html")
        self.response.out.write(template.render(path, template_value))
        
    def post(self):
        userIp = self.request.get("ip")
        feeling = self.request.get("feeling")
        name = self.request.get("name")
        email = self.request.get("email")
        note = self.request.get("note")
        
        newFeel = MyFeel()
        newFeel.userIp = userIp
        newFeel.feeling = feeling
        if len(name) > 0:
            newFeel.name = name
        if len(email) > 0:
            newFeel.email = email
        if len(note) > 0:
            newFeel.note = note
        newFeel.country = "China"
        newFeel.put()
        
        self.response.out.write("status: %s, detail: %s" % ("success", userIp))

class AddRecipe(webapp.RequestHandler):
    def get(self):
        template_value = {"pageTitle": "Add New Recipes"}
        path = os.path.join(os.path.dirname(__file__), "template/add.html")
        self.response.out.write(template.render(path, template_value))	

#		userIp = db.StringProperty()
#	    feeling = db.StringProperty()
#	    name = db.StringProperty()
#	    email = db.EmailProperty()
#	    country = db.StringProperty()
#	    note = db.StringProperty(multiline = True)
#	    date = db.DateProperty(auto_now_add = True)

class SearchRecipe(webapp.RequestHandler):
    def get(self):
		self.response.out.write("This is a test page for SearchRecipe service used by client.")
	
#        feelings = db.GqlQuery("SELECT * FROM MyFeel ORDER BY date LIMIT 10")
        
#        r = "value:"
#        for feel in feelings:
#            r += feel.userIp
#            print r
#            #self.response.out.write("%s", r)
#            return
#            r += "userIp:" + feel.userIp + ";"
#            r += "feeling:" + feel.feeling + ";"
#            r += "name:" + feel.name + ";"
#            r += "email:" + feel.email + ";"
#            r += "country:" + feel.country + ";"
#            r += "note:" + feel.note + ";"
#            r += "date:" + feel.date + ";"
            
#        self.response.out.write("%s", r)
	
      
def main():
  application = webapp.WSGIApplication([
										('/', Welcome),
										('/browse', BrowseRecipe),
										('/add', AddRecipe),
										('/search', SearchRecipe),
										],
										debug=True)
  wsgiref.handlers.CGIHandler().run(application)

if __name__ == '__main__':
  main()
