import os
import app  as flaskr
import unittest
import tempfile

class FlaskrTestCase(unittest.TestCase):

    def setUp(self):
        flaskr.app.testing = True
        self.app = flaskr.app.test_client()

    def test_simple_return(self):
        rv = self.app.get('/')
        assert b'Hello' in rv.data

if __name__ == '__main__':
    unittest.main()
