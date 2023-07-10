from django.urls import path
from DevopsProject import views

urlpatterns = [
    path('', views.home, name='home'),
    path('calculate', views.calculate, name='calculate'),
]