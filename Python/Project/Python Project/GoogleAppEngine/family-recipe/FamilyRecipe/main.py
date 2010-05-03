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

class DelAllRecords(webapp.RequestHandler):
    def get(self):
        d = self.request.get("del")
        if (d != "no"):
            self.response.out.write("no such page")
            return
        
        # USE THIS TO DELETE ALL RECORDS
        recipes = db.GqlQuery("SELECT * FROM RecipeModel")
        r = recipes.fetch(1000)
        db.delete(r)
        self.response.out.write("done")
        
class RemoveRecipe(webapp.RequestHandler):
    def post(self):
        key = self.request.get("key")
        if key:
            try:
                recipe = db.get(key)
                recipe.delete()
                self.response.out.write("done")
            except:
                self.response.out.write("error")
        
class PostRecipe(webapp.RequestHandler):
    def get(self):
        results = {}
        f = 0;
        l = 10;
        
        # get key first
        key = self.request.get("key")
        
        # filter key
        if key:
            try:
                recipe = db.get(key)
            except:
                self.response.out.write("error")
                return
                
            recipes = [recipe]
            results["count"] = 1
        else:
            # get params
            name = self.request.get("name")
            fromidx = self.request.get("fromidx")
            len = self.request.get("len")
            cat = self.request.get("cat")
            type = self.request.get("type")
            season = self.request.get("season")
            rate = self.request.get("rate")
            order = self.request.get("order")
            
            # get all recipes first
            query = RecipeModel.all()
            
            # filter name
            if name:
                query.filter("name =", name)
            # filter category
            if cat:
                query.filter("category =", cat)
            # filter type
            if type:
                query.filter("type =", type)
            # filter season
            if season:
                if season == "1":
                    query.filter("sprint =", True)
                if season == "2":
                    query.filter("summer =", True)
                if season == "3":
                    query.filter("fall =", True)
                if season == "4":
                    query.filter("winter =", True)
            # filter rate
            if rate:
                query.filter("rate =", string.atoi(rate))
            # order result
            if order:
                query.order("-" + order)
            else:
                query.order("-createDate")
            # get result
            if fromidx:
                f = string.atoi(fromidx)
            if len:
                l = string.atoi(len)
            
            recipes = query.fetch(l, f)
            results["count"] = query.count(1000)

            if (not recipes):
                self.response.out.write("error")
                return

        #recipes = db.GqlQuery("SELECT * FROM RecipeModel ORDER BY name LIMIT 10")

        results["start"] = f
        results["length"] = l
        data = {}
        results["data"] = data
        i = 0
        for recipe in recipes:
            result = {}
            result["id"] = "%s" % (recipe.key())
            result["createdata"] = recipe.createDate.isoformat()
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
            result["imgurl"] = recipe.imgurl
            data[i] = result
            i = i + 1
            
        k = simplejson.dumps(results)
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
        img = self.request.get("ip_file")
            
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
        if (img):
            #imgv = self.request.params["ip_file"]
            #size = len(imgv.value)
            #filename = imgv.filename
            try:
                nr.img = db.Blob(img)
                nr.put()
            except:
                self.response.out.write("error file too large")
                return
        else:
            nr.put()
        
        if (img):
            nr.imgurl = "img?id=%s" % (nr.key())
            nr.put()

        self.redirect("/browse2")
        
class EditRecipe(webapp.RequestHandler):
    def get(self):
        key = self.request.get("key")
        # get related recipe
        if key:
            try:
                recipe = db.get(key)
            except:
                self.response.out.write("Can not find this recipe!")
                return
        else:
            self.response.out.write("Can not find this recipe!")
            return
        
        template_value = {"pageTitle": "Edit Recipe: " + recipe.name,
                          "id": key,
                          "recipeName": recipe.name,
                          "category": recipe.category,
                          "type": recipe.type,
                          "hot": recipe.hot,
                          "useCount": recipe.count,
                          "sprint": recipe.sprint,
                          "summer": recipe.summer,
                          "fall": recipe.fall,
                          "winter": recipe.winter,
                          "combine": " ".join(recipe.combine),
                          "rate": recipe.rate,
                          "source": " ".join(recipe.source),
                          "note": recipe.other}
        path = os.path.join(os.path.dirname(__file__), "template/edit.html")
        self.response.out.write(template.render(path, template_value))

    def post(self):
        key = self.request.get("ip_key")
        # get related recipe
        if key:
            try:
                recipe = db.get(key)
            except:
                self.response.out.write("error no recipe found")
                return
        else:
            self.response.out.write("error no key input")
            return
        
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

        recipe.name = name
        recipe.category = category
        recipe.type = type
        if (hot):
            recipe.hot = True
        else:
            recipe.hot = False
        recipe.count = string.atoi(count)
        if (sprint):
            recipe.sprint = True
        else:
            recipe.sprint = False
        if (summer):
            recipe.summer = True
        else:
            recipe.summer = False
        if (fall):
            recipe.fall = True
        else:
            recipe.fall = False
        if (winter):
            recipe.winter = True
        else:
            recipe.winter = False
        recipe.rate = string.atoi(rate)
        recipe.combine = combine.split(" ")
        recipe.source = source.split(" ")
        recipe.other = other
        
        recipe.put()
        self.redirect("/browse2")

class AddRecipe(webapp.RequestHandler):
    def get(self):
        template_value = {"pageTitle": "Add New Recipes"}
        path = os.path.join(os.path.dirname(__file__), "template/add.html")
        self.response.out.write(template.render(path, template_value))	

class SearchRecipe(webapp.RequestHandler):
    def get(self):
		self.response.out.write("This is a test page for SearchRecipe service used by client.")
        
class GetRecipeImg(webapp.RequestHandler):
    def get(self):
        key = self.request.get("id")
        # get related recipe
        if key:
            try:
                recipe = db.get(key)
            except:
                self.response.out.write("error no recipe found")
                return
        else:
            self.response.out.write("error no key input")
            return
        
        if (recipe.img):
            self.response.headers["Content-type"]="image/png"
            self.response.out.write(recipe.img)

class RecipeModel(db.Model):
    createDate = db.DateProperty(auto_now_add = True)
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
    img = db.BlobProperty()
    imgurl = db.StringProperty()
      
def main():
  application = webapp.WSGIApplication([
										('/', Welcome),
										('/browse', BrowseRecipe),
                                        ('/browse2', BrowseRecipe2),
										('/add', AddRecipe),
										('/search', SearchRecipe),
                                        ('/postnew', PostRecipe),
                                        ('/edit', EditRecipe),
                                        ('/delallrecords', DelAllRecords),
                                        ('/delete', RemoveRecipe),
                                        ('/img', GetRecipeImg),
										],
										debug=True)
  wsgiref.handlers.CGIHandler().run(application)

if __name__ == '__main__':
  main()
