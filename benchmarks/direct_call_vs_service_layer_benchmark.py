"""
Direct Call vs Service Layer Benchmark

Simulates architectural layering cost by comparing direct domain invocation
versus passing through service or adapter indirection layers.
"""

import platform
import timeit


def run_benchmark() -> None:
    N = 1_000_000

    setup_code = """
class Repository:
    def fetch_value(self) -> int:
        return 42

class Service:
    def __init__(self, repository: Repository):
        self._repository = repository
    def compute(self) -> int:
        return self._repository.fetch_value() * 2

repo = Repository()
service = Service(repo)

def domain_compute():
    return 42 * 2
"""

    tests = {
        "Direct Domain Call": "domain_compute()",
        "Service Layer": "service.compute()",
        "Service + Repository Adapter": "service._repository.fetch_value() * 2",
    }

    print(f"Benchmark: direct_call_vs_service_layer_benchmark.py")
    print(f"Python: {platform.python_version()}")

    for name, stmt in tests.items():
        t = timeit.timeit(stmt, setup=setup_code, number=N)
        print(f"{name}: {t:.6f}")


if __name__ == "__main__":
    run_benchmark()
