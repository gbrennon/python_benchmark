#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
unset PYENV_VERSION

VERSIONS=($(pyenv versions --bare))
BENCHMARKS=(*_benchmark.py)

clear

echo "======================================="
echo "========= Running Benchmarks =========="
echo "======================================="

if [[ ${#BENCHMARKS[@]} -eq 0 ]]; then
    echo "❌ No benchmark scripts found matching *_benchmark.py in $(pwd)"
    exit 1
fi

for benchmark in "${BENCHMARKS[@]}"; do
    echo "🚀 Benchmark file: $benchmark"
    echo "======================================="

    for version in "${VERSIONS[@]}"; do
        echo
        echo "🐍 Python $version"
        echo
        echo "---------------------------------------"

        if pyenv shell "$version" 2>/dev/null; then
            if [[ -f "$benchmark" ]]; then
                echo "▶️  Running $benchmark with Python $version ..."
                python "$benchmark" || echo "⚠️  Benchmark failed for $benchmark on Python $version"
            else
                echo "❌ Benchmark file not found: $benchmark"
                break
            fi
        else
            echo "❌ pyenv could not activate Python $version (is it installed?)"
        fi

        echo "---------------------------------------"
    done

    echo "======================================="
    echo "✅ Finished benchmark: $benchmark"
    echo "======================================="
done

# --- CLEANUP ---
pyenv shell --unset || true
unset PYENV_VERSION

echo "======================================="
echo "======= All Benchmarks Complete ======="
echo "======================================="
