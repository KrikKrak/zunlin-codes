from django import forms

class ContactForm(forms.Form):
    subject = forms.CharField(max_length=100)
    email = forms.EmailField(required = False, label="Enter Your  Email")
    message = forms.CharField(widget=forms.Textarea)
    
    def clean_subject(self):
        sg = self.cleaned_data['subject']
        if len(sg) > 10:
            raise forms.ValidationError("Too many subjects")
        return sg