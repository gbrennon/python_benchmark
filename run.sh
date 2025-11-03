#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
unset PYENV_VERSION

BENCH_DIR="benchmarks"
VERSIONS=($(pyenv versions --bare))
BENCHMARKS=("$BENCH_DIR"/*.py)

clear
echo "======================================="
echo "========= Running Benchmarks =========="
echo "======================================="

if [[ ! -d "$BENCH_DIR" ]]; then
    echo "❌ Benchmarks directory not found: $(pwd)/$BENCH_DIR"
    exit 1
fi

if [[ ${#BENCHMARKS[@]} -eq 0 ]]; then
    echo "❌ No benchmark scripts found in $(pwd)/$BENCH_DIR"
    exit 1
fi

for benchmark in "${BENCHMARKS[@]}"; do
    echo
    echo "🚀 Benchmark file: $(basename "$benchmark")"
    echo "======================================="

    for version in "${VERSIONS[@]}"; do
        echo
        echo "🐍 Python $version"
        echo "---------------------------------------"

        if pyenv shell "$version" 2>/dev/null; then
            echo "▶️  Running $(basename "$benchmark") with Python $version ..."
            python "$benchmark" || echo "⚠️  Benchmark failed for $(basename "$benchmark") on Python $version"
        else
            echo "❌ pyenv could not activate Python $version (is it installed?)"
        fi

        echo "---------------------------------------"
    done

    echo "======================================="
    echo "✅ Finished benchmark: $(basename "$benchmark")"
    echo "======================================="
done

pyenv shell --unset || true
unset PYENV_VERSION

echo
echo "======================================="
echo "======= All Benchmarks Complete ======="
echo "======================================="
