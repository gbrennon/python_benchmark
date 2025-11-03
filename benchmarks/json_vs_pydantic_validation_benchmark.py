"""
JSON vs Pydantic Validation Benchmark

Compares pure JSON parsing against dataclass validation and Pydantic model validation.
"""

import platform
import timeit


def run_benchmark() -> None:
    N = 100_000

    setup_code = """
import json
from dataclasses import dataclass
from pydantic import BaseModel

data_json = '{"name": "Alice", "age": 30, "email": "alice@example.com"}'

@dataclass
class UserData:
    name: str
    age: int
    email: str

class UserModel(BaseModel):
    name: str
    age: int
    email: str
"""

    tests = {
        "JSON Parse Only": "json.loads(data_json)",
        "Dataclass Validation": "UserData(**json.loads(data_json))",
        "Pydantic Validation": "UserModel.model_validate_json(data_json)",
    }

    print(f"Benchmark: json_vs_pydantic_validation_benchmark.py")
    print(f"Python: {platform.python_version()}")

    for name, stmt in tests.items():
        t = timeit.timeit(stmt, setup=setup_code, number=N)
        print(f"{name}: {t:.6f}")


if __name__ == "__main__":
    run_benchmark()
