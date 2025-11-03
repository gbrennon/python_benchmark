"""
Property Benchmark

Compares direct attribute access vs property access.
Compatible with run.sh summary-table parser.
"""

import platform
import timeit


def run_benchmark() -> None:
    N = 10_000_000

    setup_code = """
class Entity:
    def __init__(self):
        self._id = 123
    @property
    def id(self):
        return self._id
entity = Entity()
"""

    tests = {
        "Direct Access": "entity._id",
        "Property Access": "entity.id",
    }

    print(f"Benchmark: property_benchmark.py")
    print(f"Python: {platform.python_version()}")

    for name, stmt in tests.items():
        t = timeit.timeit(stmt, setup=setup_code, number=N)
        print(f"{name}: {t:.6f}")


if __name__ == "__main__":
    run_benchmark()
