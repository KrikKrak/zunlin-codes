import os
import wsgiref.handlers
import string

from django.utils import simplejson
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
        template_value = {"pageTitle": "Browse Family Recipes from XML"}
        path = os.path.join(os.path.dirname(__file__), "template/browse.html")
        self.response.out.write(template.render(path, template_value))
        
class BrowseRecipe2(webapp.RequestHandler):
    def get(self):
        template_value = {"pageTitle": "Browse Family Recipes from Database"}
        path = os.path.join(os.path.dirname(__file__), "template/browse2.html")
        self.response.out.write(template.render(path, template_value))

class PostRecipe(webapp.RequestHandler):
    def get(self):
        recipes = db.GqlQuery("SELECT * FROM RecipeModel ORDER BY name LIMIT 10")
        
        results = {}
        i = 0
        for recipe in recipes:
            result = {}
            result["name"] = recipe.name
            result["category"] = recipe.category
            result["type"] = recipe.type
            result["hot"] = recipe.hot
            result["count"] = recipe.count
            result["sprint"] = recipe.sprint
            result["summer"] = recipe.summer
            result["fall"] = recipe.fall
            result["winter"] = recipe.winter
            result["combine"] = " ".join(recipe.combine)
            result["rate"] = recipe.rate
            result["source"] = " ".join(recipe.source)
            result["other"] = recipe.other
            results[i] = result
            i = i + 1
            
        k = simplejson.dumps(results);
        self.response.out.write(k)
        
    def post(self):
        name = self.request.get("ip_name")
        category = self.request.get("ip_category")
        type = self.request.get("ip_type")
        hot = self.request.get("ip_hot")
        count = self.request.get("ip_count")
        sprint = self.request.get("ip_sprint")
        summer = self.request.get("ip_summer")
        fall = self.request.get("ip_fall")
        winter = self.request.get("ip_winter")
        combine = self.request.get("ip_combine")
        rate = self.request.get("ip_r")
        source = self.request.get("ip_source")
        other = self.request.get("ip_other")
            
        nr = RecipeModel()
        nr.name = name
        nr.category = category
        nr.type = type
        if (hot):
            nr.hot = True
        else:
            nr.hot = False
        nr.count = string.atoi(count)
        if (sprint):
            nr.sprint = True
        else:
            nr.sprint = False
        if (summer):
            nr.summer = True
        else:
            nr.summer = False
        if (fall):
            nr.fall = True
        else:
            nr.fall = False
        if (winter):
            nr.winter = True
        else:
            nr.winter = False
        nr.rate = string.atoi(rate)
        nr.combine = combine.split(" ")
        nr.source = source.split(" ")
        nr.other = other
        
        nr.put()
        self.redirect("/browse2")
        
class AddRecipe(webapp.RequestHandler):
    def get(self):
        template_value = {"pageTitle": "Add New Recipes"}
        path = os.path.join(os.path.dirname(__file__), "template/add.html")
        self.response.out.write(template.render(path, template_value))	

class SearchRecipe(webapp.RequestHandler):
    def get(self):
		self.response.out.write("This is a test page for SearchRecipe service used by client.")

class RecipeModel(db.Model):
    name = db.StringProperty()
    category = db.StringProperty()
    type = db.StringProperty()
    hot = db.BooleanProperty()
    count = db.IntegerProperty()
    sprint = db.BooleanProperty()
    summer = db.BooleanProperty()
    fall = db.BooleanProperty()
    winter = db.BooleanProperty()
    combine = db.StringListProperty()
    rate = db.IntegerProperty()
    source = db.StringListProperty()
    other = db.StringProperty(multiline = True)
      
def main():
  application = webapp.WSGIApplication([
										('/', Welcome),
										('/browse', BrowseRecipe),
                                        ('/browse2', BrowseRecipe2),
										('/add', AddRecipe),
										('/search', SearchRecipe),
                                        ('/postnew', PostRecipe),
										],
										debug=True)
  wsgiref.handlers.CGIHandler().run(application)

if __name__ == '__main__':
  main()
