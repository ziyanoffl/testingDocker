from django.test import TestCase, RequestFactory
from django.urls import reverse

from DevopsProject.views import home, calculate


class TestViews(TestCase):
    def setUp(self):
        self.factory = RequestFactory()

    def test_home(self):
        request = self.factory.get(reverse('home'))
        response = home(request)

        self.assertEqual(response.status_code, 200)
        # Add more assertions to test the response content if needed

    def test_calculate(self):
        request = self.factory.post(reverse('calculate'), {'num1': '2', 'num2': '3', 'operation': 'add'})
        response = calculate(request)

        self.assertEqual(response.status_code, 200)
        # Add more assertions to test the response content and calculations if needed
