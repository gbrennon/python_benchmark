"""
Dataclass vs Manual __init__ Benchmark

Compares instantiation cost between manual class, dataclass, and NamedTuple.
"""

import platform
import timeit


def run_benchmark() -> None:
    N = 1_000_000

    setup_code = """
from dataclasses import dataclass
from typing import NamedTuple

class Manual:
    def __init__(self, x: int, y: int):
        self.x = x
        self.y = y

@dataclass
class Data:
    x: int
    y: int

class Point(NamedTuple):
    x: int
    y: int
"""

    tests = {
        "Manual Class": "Manual(1, 2)",
        "Dataclass": "Data(1, 2)",
        "NamedTuple": "Point(1, 2)",
    }

    print(f"Benchmark: dataclass_vs_manual_init_benchmark.py")
    print(f"Python: {platform.python_version()}")

    for name, stmt in tests.items():
        t = timeit.timeit(stmt, setup=setup_code, number=N)
        print(f"{name}: {t:.6f}")


if __name__ == "__main__":
    run_benchmark()
