import app as flaskr
import unittest


class FlaskrTestCase(unittest.TestCase):

    def setUp(self):
        flaskr.app.testing = True
        self.app = flaskr.app.test_client()

    def test_simple_return(self):
        rv = self.app.get('/')
        assert b'Hello' in rv.data

    def test_another_thing(self):
        assert 1 == 1

    def test_new_pr(self):
        assert 2 == 2

    def test_demo_pr(self):
        assert 2 == 2


if __name__ == '__main__':
    unittest.main()
