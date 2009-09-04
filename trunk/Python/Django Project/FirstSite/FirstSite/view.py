from django.http import HttpResponse
from django.http import HttpResponseRedirect
import datetime
from django.template.loader import get_template
from django.template import Context
from django.shortcuts import render_to_response
from FirstSite.forms import ContactForm

def hello(request):
    return HttpResponse("Hello World")

def browserInfo(request):
    values = request.META.items()
    values.sort()
    html = []
    for k, v in values:
        html.append('<tr><td>%s</td><td>%s</td></tr>' % (k, v))
        
    return HttpResponse('<table>%s</table>' % '\n'.join(html))

def root_view(request):
    return HttpResponse("This is root view")

def curtime(request):
    now = datetime.datetime.now()
    
    # use hard code
    #html = "<html><body>It is now %s.</body></html>" % now
    
    # use template
    t = get_template('current_datetime.html')
    html = t.render(Context({"current_date":now}))

    # use template shortcut
    return render_to_response('current_datetime.html', {'current_date': now})

def hours_ahead(request, offset):
    try:
        offset = int(offset)
    except ValueError:
        raise Http404()
    
    dt = datetime.datetime.now() + datetime.timedelta(hours = offset)
    html = "<html><body>In %s hours, it will be %s. </body></html>" % (offset, dt)
    
    # We can use this code for viewing the local var from error page 
    #assert False
    
    return HttpResponse(html)

def contact(request):
    if request.method == "POST":

        """values = request.POST.items()
        values.sort()
        html = []
        for k, v in values:
            html.append('<tr><td>%s</td><td>%s</td></tr>' % (k, v))
        
        return HttpResponse('<table>%s</table>' % '\n'.join(html))
        """
        form = ContactForm(request.POST)
        if (form.is_valid()):
            cd  = form.cleaned_data
            return HttpResponseRedirect("/thanks/")
    else:
        form = ContactForm()
    return render_to_response("contact_form.html", {"form": form})