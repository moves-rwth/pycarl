from . import _config

if not _config.CARL_WITH_CLN:
    raise ImportError("CLN is not available!")
from . import cln
from .cln import *


def numerator(x):
    if type(x) == cln.RationalFunction or  type(x) == cln.Rational or type(x) == cln.FactorizedRationalFunction:
        return x.numerator
    else:
        return x

def denominator(x):
    if type(x) == cln.RationalFunction or type(x) == cln.Rational or type(x) == cln.FactorizedRationalFunction:
        return x.denominator
    else:
        return 1

factorization_cache = cln._FactorizationCache()
