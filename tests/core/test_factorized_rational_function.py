import pycarl

import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from package_selector import PackageSelector


class TestFactorizedRationalFunction(PackageSelector):

    def test_init(self, package):
        pol1 = package.FactorizedPolynomial(32)
        pol2 = package.FactorizedPolynomial(2)
        rat = package.FactorizedRationalFunction(pol1, pol2)
        assert rat.numerator == 16
        assert rat.denominator == 1

    def test_derivation(self, package):
        x = pycarl.Variable("x")
        cache = package.factorization_cache
        p1 = package.FactorizedPolynomial(x*x+package.Integer(3), cache)
        p2 = package.FactorizedPolynomial(x+package.Integer(1), cache)

        rat = package.FactorizedRationalFunction(p1, p2)
        derivation = rat.derive(x)

        pe1 = package.FactorizedPolynomial(package.Integer(2)*x+x*x-3, cache)
        pe2 = package.FactorizedPolynomial((x+package.Integer(1))*(x+package.Integer(1)), cache)
        expected = package.FactorizedRationalFunction(pe1, pe2)
        assert derivation == expected
