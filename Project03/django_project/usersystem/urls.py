from django.urls import path
from . import views

urlpatterns = [
    path('signupuser/', views.signup_user, name = 'usersystem-signup_user'),
    path('loginuser/', views.login_user, name = 'usersystem-login_user'),
    path('logoutuser/', views.logout_user, name = 'usersystem-logout_user'),
]
