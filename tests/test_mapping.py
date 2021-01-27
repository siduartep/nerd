from nerd.mapping import safe_divition
from unittest import TestCase
import numpy as np


class TestMapping(TestCase):
    def setUp(self) -> None:
        self.a = 60
        self.b = 2
        self.c = 0

    def test_safe_divition(self):
        expected = 60 / 2
        obtained = safe_divition(self.a, self.b)
        assert expected == obtained

    def test_safe_divition_by_zero(self):
        expected = np.inf
        obtained = safe_divition(self.a, self.c)
        assert expected == obtained
