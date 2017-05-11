import pytest

import pycarl
import pycarl.cln, pycarl.gmp

class PackageSelector:

    @pytest.fixture(params=[pycarl.cln, pycarl.gmp])
    def package(self, request):
        return request.param