from django.shortcuts import render
from django.contrib.auth.models import User
from django.contrib.auth import authenticate, login, logout
import json


def signup_user(request):
    """recieves a json request { 'username' : 'val0', 'password' : 'val1' } and saves it
       it to the database using the django User Model
       Assumes success and returns an empty Http Response"""

    json_req = json.loads(request.body)
    uname = json_req.get('username','')
    passw = json_req.get('password','')

    if uname != '' and passw!= "":
        user = User.objects.create_user(username=uname,password=passw)
        login(request, user)
        return HttpResponse('LoggedIn')
    else:
        return HttpResponse('LoggedOut')

def login_user(request):
    """recieves a json request { 'username' : 'val0' : 'password' : 'val1' } and
       authenticates and loggs in the user upon success """

    json_req = json.loads(request.body)
    uname = json_req.get('username','')
    passw = json_req.get('password','')

    user = authenticate(request,username=uname,password=passw)
    if user is not None:
        login(reqest, user)
        return HttpResponse('LoggedIn')
    return HttpResponse('LoginFailed')

def logout_user(request):
    logout(request)
    return HttpResponse('LoggedOut')
