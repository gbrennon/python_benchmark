#!/usr/bin/env bash
set -euo pipefail

# Usage: ./new_benchmark.sh <name>
# Example: ./new_benchmark.sh dict_vs_list

if [[ $# -lt 1 ]]; then
  echo "Usage: ./new_benchmark.sh <name>"
  exit 1
fi

name=$1
file="benchmarks/${name}_benchmark.py"

mkdir -p benchmarks

cat > "$file" << 'EOF'
"""
<BenchmarkName> Benchmark

This benchmark compares multiple approaches for the same operation.
Each entry in the `tests` dictionary defines a named approach
that will be included in the summary table automatically.
"""

import platform
import timeit


def run_benchmark() -> None:
    N = 1_000_000

    setup_code = """
# Place any setup code here
data = [i for i in range(100)]
"""

    tests = {
        "Approach A": "sum(data)",
        "Approach B": "[x * 2 for x in data]",
    }

    print(f"Benchmark: <BenchmarkName>_benchmark.py")
    print(f"Python: {platform.python_version()}")

    for name, stmt in tests.items():
        t = timeit.timeit(stmt, setup=setup_code, number=N)
        print(f"{name}: {t:.6f}")


if __name__ == "__main__":
    run_benchmark()
EOF

sed -i "s/<BenchmarkName>/${name^}/" "$file"

chmod +x "$file"
echo "✅ Created benchmark template: $file"
